import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import '../models/sensor_data_model.dart';
import '../models/spectral_data_model.dart';
import '../isolate/spectral_compute_isolate.dart';

/// Dual-mode Concurrent Acquisition Service
/// Coordinates AS7341 Multi-spectral + OpenMV Machine Vision streams.
/// Dispatches high-frequency updates via ValueNotifier and StreamControllers
/// allowing StreamBuilder and ValueListenableBuilder to perform micro-tree repaints.
class DualSensorAcquisitionService {
  static final DualSensorAcquisitionService instance =
      DualSensorAcquisitionService._internal();

  DualSensorAcquisitionService._internal() {
    _initSensors();
  }

  // 1. Cabin Micro-climate State (ValueNotifier for minimal widget rebuilds)
  final ValueNotifier<CabinSensorData> cabinState =
      ValueNotifier<CabinSensorData>(const CabinSensorData());

  // 2. High-Frequency Spectral & Vision Streams for StreamBuilder
  final StreamController<AS7341SpectralData> _spectralStreamController =
      StreamController<AS7341SpectralData>.broadcast();
  Stream<AS7341SpectralData> get spectralStream =>
      _spectralStreamController.stream;

  final StreamController<OpenMVVisionData> _visionStreamController =
      StreamController<OpenMVVisionData>.broadcast();
  Stream<OpenMVVisionData> get visionStream =>
      _visionStreamController.stream;

  final StreamController<OriginGradeReport> _gradeReportStreamController =
      StreamController<OriginGradeReport>.broadcast();
  Stream<OriginGradeReport> get gradeReportStream =>
      _gradeReportStreamController.stream;

  // Active Origin Grade Cache
  OriginGradeReport _currentReport = OriginGradeReport(
    assessmentTime: DateTime.now(),
  );
  OriginGradeReport get currentReport => _currentReport;

  Timer? _acquisitionTimer;
  final math.Random _random = math.Random();
  bool _isAcquiring = true;
  double _frequencyHz = 20.0; // 20Hz default sample tick

  void _initSensors() {
    _startSamplingLoop();
  }

  void _startSamplingLoop() {
    _acquisitionTimer?.cancel();
    final intervalMs = (1000.0 / _frequencyHz).round();

    _acquisitionTimer =
        Timer.periodic(Duration(milliseconds: intervalMs), (timer) {
      if (!_isAcquiring) return;
      _sampleSensorTick();
    });
  }

  int _tickCount = 0;

  /// High-frequency sensor tick simulating dual hardware concurrency
  void _sampleSensorTick() {
    _tickCount++;

    // A. Cabin Micro-variations (every 10 ticks ~0.5s)
    if (_tickCount % 10 == 0) {
      final current = cabinState.value;
      final tempDrift = (_random.nextDouble() - 0.5) * 0.04;
      final humDrift = (_random.nextDouble() - 0.5) * 0.12;

      final updated = current.copyWith(
        currentTemp: double.parse(
            (current.currentTemp + tempDrift).clamp(3.4, 4.2).toStringAsFixed(1)),
        currentHumidity: double.parse(
            (current.currentHumidity + humDrift).clamp(63.8, 65.5).toStringAsFixed(1)),
      );
      cabinState.value = updated;
    }

    // B. Spectral & Vision Data Packets (every 15 ticks ~0.75s)
    if (_tickCount % 15 == 0) {
      // Generate synthetic raw hardware readings
      final rawAs7341 = [
        0.42 + (_random.nextDouble() - 0.5) * 0.02,
        0.58 + (_random.nextDouble() - 0.5) * 0.02,
        0.76 + (_random.nextDouble() - 0.5) * 0.02,
        0.88 + (_random.nextDouble() - 0.5) * 0.015,
        0.94 + (_random.nextDouble() - 0.5) * 0.015,
        0.82 + (_random.nextDouble() - 0.5) * 0.02,
        0.65 + (_random.nextDouble() - 0.5) * 0.02,
        0.48 + (_random.nextDouble() - 0.5) * 0.02,
        0.92 + (_random.nextDouble() - 0.5) * 0.01,
      ];

      final rawOpenMv = [
        94.6 + (_random.nextDouble() - 0.5) * 0.8, // pearl density
        3.85 + (_random.nextDouble() - 0.5) * 0.05, // rhizome ratio
        96.2 + (_random.nextDouble() - 0.5) * 0.6, // head tightness
        95.8 + (_random.nextDouble() - 0.5) * 0.5, // ring texture
      ];

      // Dispatch raw sensor data to background Isolate!
      // This guarantees zero main thread jank.
      final task = SpectralComputeTask(
        rawAs7341Channels: rawAs7341,
        rawOpenMvFeatures: rawOpenMv,
        environmentFactor: 97.8 + (_random.nextDouble() - 0.5) * 0.4,
        processingFactor: 98.6 + (_random.nextDouble() - 0.5) * 0.3,
      );

      SpectralComputeIsolate.computeAuthenticityGrade(task).then((report) {
        _currentReport = report;
        _spectralStreamController.add(report.spectralData);
        _visionStreamController.add(report.visionData);
        _gradeReportStreamController.add(report);
      }).catchError((err) {
        debugPrint('Spectral isolate computation error: $err');
      });
    }
  }

  /// Change sampling rate dynamically (10Hz to 120Hz)
  void setAcquisitionRate(double hz) {
    _frequencyHz = hz.clamp(10.0, 120.0);
    _startSamplingLoop();
  }

  void toggleSampling() {
    _isAcquiring = !_isAcquiring;
  }

  void dispose() {
    _acquisitionTimer?.cancel();
    _spectralStreamController.close();
    _visionStreamController.close();
    _gradeReportStreamController.close();
    cabinState.dispose();
  }
}

import 'package:flutter_test/flutter_test.dart';
import 'package:tcm_precision_mobile/core/isolate/spectral_compute_isolate.dart';
import 'package:tcm_precision_mobile/core/models/sensor_data_model.dart';

void main() {
  group('TCM Precision Isolate & Model Verification', () {
    test('CabinSensorData default constructor and copyWith integrity', () {
      const data = CabinSensorData();
      expect(data.currentTemp, 3.8);
      expect(data.currentHumidity, 64.5);
      expect(data.oxygenPercentage, 3.2);
      expect(data.nitrogenPercentage, 96.0);
      expect(data.isSteadyState, true);

      final updated = data.copyWith(currentTemp: 4.1);
      expect(updated.currentTemp, 4.1);
      expect(updated.currentHumidity, 64.5);
    });

    test('SpectralComputeIsolate mathematical evaluation calculation', () async {
      const testTask = SpectralComputeTask(
        rawAs7341Channels: [0.42, 0.58, 0.76, 0.88, 0.94, 0.82, 0.65, 0.48, 0.92],
        rawOpenMvFeatures: [94.6, 3.85, 96.2, 95.8],
        environmentFactor: 97.8,
        processingFactor: 98.6,
      );

      final report = await SpectralComputeIsolate.computeAuthenticityGrade(testTask);
      expect(report.overallScore, greaterThan(95.0));
      expect(report.gradeLevel, contains('AAA'));
      expect(report.spectralDimensionScore, greaterThan(98.0));
      expect(report.environmentDimensionScore, 97.8);
      expect(report.processingDimensionScore, 98.6);
      expect(report.spectralData.spectralHash, isNotEmpty);
      expect(report.spectralData.saponinRatioRg1Re, greaterThanOrEqualTo(1.20));
    });
  });
}

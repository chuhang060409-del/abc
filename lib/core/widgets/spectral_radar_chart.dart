import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/tcm_theme.dart';
import '../models/spectral_data_model.dart';

/// AS7341 NIR Spectral Fingerprint Wave Curve
/// Renders real-time continuous absorption peaks and standard comparison spline
class SpectralWaveChart extends StatelessWidget {
  final AS7341SpectralData spectralData;

  const SpectralWaveChart({
    super.key,
    required this.spectralData,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = (constraints.maxWidth * 0.24).clamp(70.0, 110.0);

        return Container(
          width: double.infinity,
          height: height,
          decoration: BoxDecoration(
            color: TcmColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(TcmSpacing.radiusSm),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: CustomPaint(
            painter: _SpectralWavePainter(spectralData: spectralData),
          ),
        );
      },
    );
  }
}

class _SpectralWavePainter extends CustomPainter {
  final AS7341SpectralData spectralData;

  _SpectralWavePainter({required this.spectralData});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // 1. Benchmark Standard Reference Wave (Dashed)
    final refPaint = Paint()
      ..color = TcmColors.primary.withOpacity(0.35)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final refPath = Path();
    final refPoints = [
      Offset(0, h * 0.75),
      Offset(w * 0.15, h * 0.35),
      Offset(w * 0.30, h * 0.85),
      Offset(w * 0.48, h * 0.22),
      Offset(w * 0.65, h * 0.65),
      Offset(w * 0.82, h * 0.18),
      Offset(w * 1.0, h * 0.55),
    ];

    refPath.moveTo(refPoints[0].dx, refPoints[0].dy);
    for (int i = 0; i < refPoints.length - 1; i++) {
      final p0 = refPoints[i];
      final p1 = refPoints[i + 1];
      final cx = (p0.dx + p1.dx) / 2;
      refPath.cubicTo(cx, p0.dy, cx, p1.dy, p1.dx, p1.dy);
    }
    _drawDashedPath(canvas, refPath, refPaint);

    // 2. Real-time AS7341 Measured Curve (Solid with Glow)
    final livePaint = Paint()
      ..color = TcmColors.primary
      ..strokeWidth = 2.4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final channels = spectralData.channelVector;
    final livePath = Path();

    // Map 9 channel intensity points across width
    final stepX = w / (channels.length - 1);
    final livePoints = <Offset>[];
    for (int i = 0; i < channels.length; i++) {
      final normY = (1.0 - channels[i]).clamp(0.08, 0.92);
      livePoints.add(Offset(i * stepX, h * normY));
    }

    livePath.moveTo(livePoints[0].dx, livePoints[0].dy);
    for (int i = 0; i < livePoints.length - 1; i++) {
      final p0 = livePoints[i];
      final p1 = livePoints[i + 1];
      final cx = (p0.dx + p1.dx) / 2;
      livePath.cubicTo(cx, p0.dy, cx, p1.dy, p1.dx, p1.dy);
    }

    canvas.drawPath(livePath, livePaint);

    // Subtle peak dots
    for (final p in [livePoints[2], livePoints[4], livePoints[7]]) {
      canvas.drawCircle(p, 3.0, Paint()..color = TcmColors.primary);
      canvas.drawCircle(
        p,
        6.0,
        Paint()..color = TcmColors.primary.withOpacity(0.2),
      );
    }
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint) {
    for (final metric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        final length = math.min(4.0, metric.length - distance);
        final extract = metric.extractPath(distance, distance + length);
        canvas.drawPath(extract, paint);
        distance += 8.0;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _SpectralWavePainter oldDelegate) {
    return oldDelegate.spectralData != spectralData;
  }
}

/// Three-Dimensional Weighted Authenticity Matrix Radar
class OriginRadarChart extends StatelessWidget {
  final double spectralScore; // 40% (0~100)
  final double envScore; // 30% (0~100)
  final double processScore; // 30% (0~100)

  const OriginRadarChart({
    super.key,
    required this.spectralScore,
    required this.envScore,
    required this.processScore,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = (constraints.maxWidth * 0.55).clamp(160.0, 220.0);

        return SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _RadarChartPainter(
              spectral: spectralScore,
              env: envScore,
              process: processScore,
            ),
          ),
        );
      },
    );
  }
}

class _RadarChartPainter extends CustomPainter {
  final double spectral;
  final double env;
  final double process;

  _RadarChartPainter({
    required this.spectral,
    required this.env,
    required this.process,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.42;

    // 3 axes: top (Spectral), bottom-right (Process), bottom-left (Environment)
    final angles = [-math.pi / 2, math.pi / 6, 5 * math.pi / 6];

    // Grid concentric rings
    final gridPaint = Paint()
      ..color = TcmColors.outlineVariant.withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    for (final step in [0.33, 0.66, 1.0]) {
      final r = radius * step;
      final ringPath = Path();
      for (int i = 0; i < 3; i++) {
        final x = center.dx + r * math.cos(angles[i]);
        final y = center.dy + r * math.sin(angles[i]);
        if (i == 0) {
          ringPath.moveTo(x, y);
        } else {
          ringPath.lineTo(x, y);
        }
      }
      ringPath.close();
      canvas.drawPath(ringPath, gridPaint);
    }

    // Draw Spokes
    for (final angle in angles) {
      canvas.drawLine(
        center,
        Offset(center.dx + radius * math.cos(angle),
            center.dy + radius * math.sin(angle)),
        gridPaint,
      );
    }

    // Draw Data Triangle
    final values = [spectral / 100.0, process / 100.0, env / 100.0];
    final dataPath = Path();
    for (int i = 0; i < 3; i++) {
      final r = radius * values[i].clamp(0.1, 1.0);
      final x = center.dx + r * math.cos(angles[i]);
      final y = center.dy + r * math.sin(angles[i]);
      if (i == 0) {
        dataPath.moveTo(x, y);
      } else {
        dataPath.lineTo(x, y);
      }
    }
    dataPath.close();

    // Fill
    final fillPaint = Paint()
      ..color = TcmColors.primary.withOpacity(0.18)
      ..style = PaintingStyle.fill;
    canvas.drawPath(dataPath, fillPaint);

    // Border
    final borderPaint = Paint()
      ..color = TcmColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawPath(dataPath, borderPaint);

    // Vertex points
    for (int i = 0; i < 3; i++) {
      final r = radius * values[i].clamp(0.1, 1.0);
      final p = Offset(center.dx + r * math.cos(angles[i]),
          center.dy + r * math.sin(angles[i]));
      canvas.drawCircle(p, 4.0, Paint()..color = TcmColors.primary);
      canvas.drawCircle(p, 2.0, Paint()..color = Colors.white);
    }
  }

  @override
  bool shouldRepaint(covariant _RadarChartPainter oldDelegate) {
    return oldDelegate.spectral != spectral ||
        oldDelegate.env != env ||
        oldDelegate.process != process;
  }
}

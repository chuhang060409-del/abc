import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../theme/tcm_theme.dart';

/// 24-Hour High-Performance Dual-Axis Temperature and Humidity Trend Chart
/// Rendered with CustomPainter for 120Hz smooth animations without DOM/SVG overhead.
/// Features dual y-axes, cubic bezier curves, gradient fills, and safe-threshold bands.
class CustomTrendChart extends StatefulWidget {
  final double currentTemp;
  final double currentHumidity;

  const CustomTrendChart({
    super.key,
    required this.currentTemp,
    required this.currentHumidity,
  });

  @override
  State<CustomTrendChart> createState() => _CustomTrendChartState();
}

class _CustomTrendChartState extends State<CustomTrendChart>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Proportional height adapting to parent container
        final chartHeight = (constraints.maxWidth * 0.45).clamp(180.0, 260.0);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Dual Axis Labels
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: TcmColors.error,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '左轴：温度 (0 ~ 6℃)',
                      style: TcmTypography.labelDataSmall(color: TcmColors.error),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: TcmColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '右轴：湿度 (50 ~ 80%)',
                      style: TcmTypography.labelDataSmall(color: TcmColors.primary),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Canvas Chart Container
            Container(
              height: chartHeight,
              width: double.infinity,
              decoration: BoxDecoration(
                color: TcmColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(TcmSpacing.radiusDefault),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(TcmSpacing.radiusDefault),
                child: AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: _TrendChartPainter(
                        currentTemp: widget.currentTemp,
                        currentHumidity: widget.currentHumidity,
                        pulseRatio: _pulseController.value,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 6),

            // Time Axis X-Labels
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('00:00', style: TcmTypography.labelDataSmall()),
                  Text('06:00', style: TcmTypography.labelDataSmall()),
                  Text('12:00', style: TcmTypography.labelDataSmall()),
                  Text('18:00', style: TcmTypography.labelDataSmall()),
                  Text(
                    '当前 (实时)',
                    style: TcmTypography.labelDataSmall(color: TcmColors.primary)
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _TrendChartPainter extends CustomPainter {
  final double currentTemp;
  final double currentHumidity;
  final double pulseRatio;

  _TrendChartPainter({
    required this.currentTemp,
    required this.currentHumidity,
    required this.pulseRatio,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final padX = 24.0;
    final padTop = 30.0;
    final padBottom = 20.0;
    final chartH = h - padTop - padBottom;
    final chartW = w - padX * 2;

    // 1. Draw dashed horizontal grid lines
    final gridPaint = Paint()
      ..color = TcmColors.surfaceContainerHighest
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    for (int i = 0; i <= 3; i++) {
      final y = padTop + (chartH / 3.0) * i;
      _drawDashedLine(canvas, Offset(padX, y), Offset(w - padX, y), gridPaint);
    }

    // 2. Safe Threshold Background Band (2℃~6℃ & 60%~70% safe zone)
    final safeZoneTop = padTop + chartH * 0.18;
    final safeZoneBottom = padTop + chartH * 0.72;
    final safeRect = Rect.fromLTRB(padX, safeZoneTop, w - padX, safeZoneBottom);
    final safeBandPaint = Paint()
      ..color = TcmColors.tertiary.withOpacity(0.04)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(safeRect, const Radius.circular(6)),
      safeBandPaint,
    );

    // 3. Normalized Data Points for Humidity Curve (50% to 80%)
    // Points across 24 hours
    final humPoints = [
      Offset(padX + chartW * 0.0, padTop + chartH * 0.65),
      Offset(padX + chartW * 0.25, padTop + chartH * 0.58),
      Offset(padX + chartW * 0.50, padTop + chartH * 0.52),
      Offset(padX + chartW * 0.75, padTop + chartH * 0.44),
      Offset(padX + chartW * 1.0, padTop + chartH * (1.0 - (currentHumidity - 50.0) / 30.0).clamp(0.1, 0.9)),
    ];

    // Humidity Gradient & Smooth Spline Path
    final humPath = Path();
    humPath.moveTo(humPoints[0].dx, humPoints[0].dy);
    for (int i = 0; i < humPoints.length - 1; i++) {
      final p0 = humPoints[i];
      final p1 = humPoints[i + 1];
      final cx = (p0.dx + p1.dx) / 2;
      humPath.cubicTo(cx, p0.dy, cx, p1.dy, p1.dx, p1.dy);
    }

    final humFillPath = Path.from(humPath)
      ..lineTo(w - padX, padTop + chartH)
      ..lineTo(padX, padTop + chartH)
      ..close();

    final humFillPaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(0, padTop),
        Offset(0, h),
        [
          TcmColors.primary.withOpacity(0.25),
          TcmColors.primary.withOpacity(0.0),
        ],
      );
    canvas.drawPath(humFillPath, humFillPaint);

    final humLinePaint = Paint()
      ..color = TcmColors.primary
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(humPath, humLinePaint);

    // 4. Normalized Data Points for Temperature Curve (0℃ to 6℃)
    final tempPoints = [
      Offset(padX + chartW * 0.0, padTop + chartH * 0.52),
      Offset(padX + chartW * 0.25, padTop + chartH * 0.42),
      Offset(padX + chartW * 0.50, padTop + chartH * 0.48),
      Offset(padX + chartW * 0.75, padTop + chartH * 0.36),
      Offset(padX + chartW * 1.0, padTop + chartH * (1.0 - (currentTemp / 6.0)).clamp(0.1, 0.9)),
    ];

    final tempPath = Path();
    tempPath.moveTo(tempPoints[0].dx, tempPoints[0].dy);
    for (int i = 0; i < tempPoints.length - 1; i++) {
      final p0 = tempPoints[i];
      final p1 = tempPoints[i + 1];
      final cx = (p0.dx + p1.dx) / 2;
      tempPath.cubicTo(cx, p0.dy, cx, p1.dy, p1.dx, p1.dy);
    }

    final tempFillPath = Path.from(tempPath)
      ..lineTo(w - padX, padTop + chartH)
      ..lineTo(padX, padTop + chartH)
      ..close();

    final tempFillPaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(0, padTop),
        Offset(0, h),
        [
          TcmColors.error.withOpacity(0.22),
          TcmColors.error.withOpacity(0.0),
        ],
      );
    canvas.drawPath(tempFillPath, tempFillPaint);

    final tempLinePaint = Paint()
      ..color = TcmColors.error
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(tempPath, tempLinePaint);

    // 5. Real-time Anchor Dots & Pulsating Glow
    final latestTemp = tempPoints.last;
    final latestHum = humPoints.last;

    // Temp pulse glow
    canvas.drawCircle(
      latestTemp,
      5.0 + pulseRatio * 4.0,
      Paint()..color = TcmColors.error.withOpacity(0.35 - pulseRatio * 0.2),
    );
    canvas.drawCircle(latestTemp, 4.5, Paint()..color = TcmColors.error);

    // Humidity pulse glow
    canvas.drawCircle(
      latestHum,
      5.0 + pulseRatio * 4.0,
      Paint()..color = TcmColors.primary.withOpacity(0.35 - pulseRatio * 0.2),
    );
    canvas.drawCircle(latestHum, 4.5, Paint()..color = TcmColors.primary);

    // 6. Floating Value Bubble Badges
    _drawBubbleBadge(
      canvas,
      Offset(latestTemp.dx - 48, latestTemp.dy - 24),
      '${currentTemp.toStringAsFixed(1)}℃',
      TcmColors.error,
    );

    _drawBubbleBadge(
      canvas,
      Offset(latestHum.dx - 54, latestHum.dy + 12),
      '${currentHumidity.toStringAsFixed(1)}%',
      TcmColors.primary,
    );
  }

  void _drawBubbleBadge(
      Canvas canvas, Offset offset, String text, Color bgColor) {
    final rect = Rect.fromLTWH(offset.dx, offset.dy, 46, 20);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(6));
    canvas.drawRRect(rrect, Paint()..color = bgColor);

    final textSpan = TextSpan(
      text: text,
      style: const TextStyle(
        fontFamily: TcmTypography.monoFont,
        fontSize: 10.5,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(
      canvas,
      Offset(rect.left + (rect.width - textPainter.width) / 2,
          rect.top + (rect.height - textPainter.height) / 2),
    );
  }

  void _drawDashedLine(Canvas canvas, Offset p1, Offset p2, Paint paint) {
    const dashWidth = 5.0;
    const dashSpace = 4.0;
    double currentX = p1.dx;
    while (currentX < p2.dx) {
      canvas.drawLine(
        Offset(currentX, p1.dy),
        Offset(
            (currentX + dashWidth) > p2.dx ? p2.dx : currentX + dashWidth, p1.dy),
        paint,
      );
      currentX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant _TrendChartPainter oldDelegate) {
    return oldDelegate.currentTemp != currentTemp ||
        oldDelegate.currentHumidity != currentHumidity ||
        oldDelegate.pulseRatio != pulseRatio;
  }
}

import 'dart:ui';
import 'package:flutter/material.dart';

/// TCM Industrial Precision Design System & Color Tokens
/// Replicated strictly from DESIGN.md and Stitch specification
class TcmColors {
  TcmColors._();

  // Primary Palette (Medical Blue)
  static const Color primary = Color(0xFF004AC6);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFF2563EB);
  static const Color onPrimaryContainer = Color(0xFFEEEFFF);
  static const Color primaryFixed = Color(0xFFDBE1FF);
  static const Color primaryFixedDim = Color(0xFFB4C5FF);
  static const Color onPrimaryFixed = Color(0xFF00174B);
  static const Color onPrimaryFixedVariant = Color(0xFF003EA8);
  static const Color inversePrimary = Color(0xFFB4C5FF);

  // Secondary Palette (Industrial Slate)
  static const Color secondary = Color(0xFF545F73);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFD5E0F8);
  static const Color onSecondaryContainer = Color(0xFF586377);
  static const Color secondaryFixed = Color(0xFFD8E3FB);
  static const Color secondaryFixedDim = Color(0xFFBCC7DE);
  static const Color onSecondaryFixed = Color(0xFF111C2D);
  static const Color onSecondaryFixedVariant = Color(0xFF3C475A);

  // Tertiary Palette (Herb Pine Green / Verification)
  static const Color tertiary = Color(0xFF006242);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFF007D55);
  static const Color onTertiaryContainer = Color(0xFFBDFFDB);
  static const Color tertiaryFixed = Color(0xFF6FFBBE);
  static const Color tertiaryFixedDim = Color(0xFF4EDEA3);
  static const Color onTertiaryFixed = Color(0xFF002113);
  static const Color onTertiaryFixedVariant = Color(0xFF005236);

  // Surface & Neutrals
  static const Color background = Color(0xFFF8F9FB);
  static const Color onBackground = Color(0xFF191C1E);
  static const Color surface = Color(0xFFF8F9FB);
  static const Color onSurface = Color(0xFF191C1E);
  static const Color onSurfaceVariant = Color(0xFF434655);
  static const Color surfaceDim = Color(0xFFD9DADC);
  static const Color surfaceBright = Color(0xFFF8F9FB);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF3F4F6);
  static const Color surfaceContainer = Color(0xFFEDEEF0);
  static const Color surfaceContainerHigh = Color(0xFFE7E8EA);
  static const Color surfaceContainerHighest = Color(0xFFE1E2E4);
  static const Color inverseSurface = Color(0xFF2E3132);
  static const Color inverseOnSurface = Color(0xFFF0F1F3);

  // Outlines
  static const Color outline = Color(0xFF737686);
  static const Color outlineVariant = Color(0xFFC3C6D7);
  static const Color surfaceTint = Color(0xFF0053DB);

  // Status & Alerts (Medical Alert Red)
  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF93000A);

  // Glassmorphic Accents
  static const Color glassBorderLight = Color(0x33FFFFFF);
  static const Color glassHighlight = Color(0x1FFFFFFF);
}

/// Strict Typography Hierarchy conforming to Hanken Grotesk + JetBrains Mono
class TcmTypography {
  TcmTypography._();

  static const String primaryFont = 'Hanken Grotesk';
  static const String monoFont = 'JetBrains Mono';

  static TextStyle displayData({Color color = TcmColors.onSurface}) => TextStyle(
        fontFamily: primaryFont,
        fontSize: 68.0,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.02,
        height: 1.05,
        color: color,
      );

  static TextStyle headlineLg({Color color = TcmColors.onSurface}) => TextStyle(
        fontFamily: primaryFont,
        fontSize: 30.0,
        fontWeight: FontWeight.w700,
        height: 1.25,
        color: color,
      );

  static TextStyle headlineLgMobile({Color color = TcmColors.onSurface}) => TextStyle(
        fontFamily: primaryFont,
        fontSize: 22.0,
        fontWeight: FontWeight.w700,
        height: 1.3,
        color: color,
      );

  static TextStyle headlineMd({Color color = TcmColors.onSurface}) => TextStyle(
        fontFamily: primaryFont,
        fontSize: 20.0,
        fontWeight: FontWeight.w600,
        height: 1.3,
        color: color,
      );

  static TextStyle bodyLg({Color color = TcmColors.onSurface}) => TextStyle(
        fontFamily: primaryFont,
        fontSize: 18.0,
        fontWeight: FontWeight.w500,
        height: 1.4,
        color: color,
      );

  static TextStyle bodyMd({Color color = TcmColors.onSurface}) => TextStyle(
        fontFamily: primaryFont,
        fontSize: 15.0,
        fontWeight: FontWeight.w400,
        height: 1.45,
        color: color,
      );

  static TextStyle labelData({Color color = TcmColors.secondary}) => TextStyle(
        fontFamily: monoFont,
        fontSize: 13.0,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.05,
        height: 1.2,
        color: color,
      );

  static TextStyle labelDataSmall({Color color = TcmColors.outline}) => TextStyle(
        fontFamily: monoFont,
        fontSize: 11.0,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.04,
        height: 1.2,
        color: color,
      );
}

/// Spacing & Layout Tokens (Strict 8px rhythm)
class TcmSpacing {
  TcmSpacing._();

  static const double baseUnit = 8.0;
  static const double touchTargetMin = 56.0;
  static const double gutterMobile = 16.0;
  static const double marginMobile = 16.0;
  static const double gutterDesktop = 24.0;
  static const double marginDesktop = 40.0;

  // Corner Radii
  static const double radiusSm = 8.0;
  static const double radiusDefault = 16.0;
  static const double radiusMd = 24.0;
  static const double radiusLg = 32.0;
  static const double radiusXl = 48.0;
  static const double radiusFull = 9999.0;
}

/// Reusable Glassmorphism & Card Styles
class TcmDecorations {
  TcmDecorations._();

  static BoxDecoration card({
    Color backgroundColor = TcmColors.surfaceContainerLowest,
    double radius = TcmSpacing.radiusDefault,
    Border? border,
    List<BoxShadow>? shadows,
  }) =>
      BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(radius),
        border: border ?? Border.all(color: TcmColors.surfaceContainerHigh.withOpacity(0.5), width: 1),
        boxShadow: shadows ??
            [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
      );

  static BoxDecoration liquidGlass({
    double radius = 28.0,
    bool isElevated = true,
  }) =>
      BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.85),
            Colors.white.withOpacity(0.68),
          ],
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.4),
          width: 0.5,
        ),
        boxShadow: isElevated
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: TcmColors.primary.withOpacity(0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      );
}

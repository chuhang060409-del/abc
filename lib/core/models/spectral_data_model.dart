import 'package:flutter/foundation.dart';

/// AS7341 8-Channel Visible + NIR Multi-spectral Sensor Data
@immutable
class AS7341SpectralData {
  // Raw channel intensity readings (415nm - 680nm + NIR + Clear)
  final double f1_415nm;
  final double f2_445nm;
  final double f3_480nm;
  final double f4_515nm;
  final double f5_555nm;
  final double f6_590nm;
  final double f7_630nm;
  final double f8_680nm;
  final double clear;
  final double nir_910nm;

  final double deltaE; // Spectral color difference against standard
  final double saponinRatioRg1Re; // Active ginsenoside ratio
  final double spectralMatchPercentage; // Cosine similarity match
  final String spectralHash;

  const AS7341SpectralData({
    this.f1_415nm = 0.42,
    this.f2_445nm = 0.58,
    this.f3_480nm = 0.76,
    this.f4_515nm = 0.88,
    this.f5_555nm = 0.94,
    this.f6_590nm = 0.82,
    this.f7_630nm = 0.65,
    this.f8_680nm = 0.48,
    this.clear = 0.98,
    this.nir_910nm = 0.92,
    this.deltaE = 0.038,
    this.saponinRatioRg1Re = 1.42,
    this.spectralMatchPercentage = 99.2,
    this.spectralHash = '7a9e-f401-bc8d-3921',
  });

  List<double> get channelVector => [
        f1_415nm,
        f2_445nm,
        f3_480nm,
        f4_515nm,
        f5_555nm,
        f6_590nm,
        f7_630nm,
        f8_680nm,
        nir_910nm,
      ];
}

/// OpenMV Machine Vision Surface & Morphological Features
@immutable
class OpenMVVisionData {
  final double pearlSpotDensity; // 珍珠疙瘩密度 (0~100)
  final double rhizomeAspectRatio; // 参体长宽比
  final double headTightness; // 芦头紧致度 (0~100)
  final double ringTextureScore; // 环纹清晰度 (0~100)
  final double visualMatchPercentage; // 综合机器视觉得分

  const OpenMVVisionData({
    this.pearlSpotDensity = 94.6,
    this.rhizomeAspectRatio = 3.85,
    this.headTightness = 96.2,
    this.ringTextureScore = 95.8,
    this.visualMatchPercentage = 97.8,
  });
}

/// Comprehensive 3D Weighted Geo-Origin Authenticity Grade
@immutable
class OriginGradeReport {
  final String lotNumber;
  final String medicineName;
  final String originLocation;
  final String giCode; // 地理标志认定代码
  final double overallScore; // 综合道地指数
  final String gradeLevel; // AAA级 特级道地

  // 3-Dimensional Weighted Metrics
  final double spectralDimensionScore; // 40%
  final double environmentDimensionScore; // 30%
  final double processingDimensionScore; // 30%

  // Environmental Specifics
  final double humusSoilPercentage; // 黑腐殖土 18.4%
  final int accumulatedTemperature; // 有效积温 2710 ℃·d
  final int naturalPrecipitationMm; // 天然降水 820mm

  final AS7341SpectralData spectralData;
  final OpenMVVisionData visionData;
  final DateTime assessmentTime;

  const OriginGradeReport({
    this.lotNumber = 'CBS-2026-FUSONG-08',
    this.medicineName = '长白山野山参',
    this.originLocation = '吉林抚松核心道地产区 (北纬 41°58′22″ · 海拔 840m)',
    this.giCode = 'CN-GI-JLS2026-0042',
    this.overallScore = 98.5,
    this.gradeLevel = 'AAA级 特级道地',
    this.spectralDimensionScore = 99.2,
    this.environmentDimensionScore = 97.8,
    this.processingDimensionScore = 98.6,
    this.humusSoilPercentage = 18.4,
    this.accumulatedTemperature = 2710,
    this.naturalPrecipitationMm = 820,
    this.spectralData = const AS7341SpectralData(),
    this.visionData = const OpenMVVisionData(),
    required this.assessmentTime,
  });
}

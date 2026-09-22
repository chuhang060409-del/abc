import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/tcm_theme.dart';
import '../../core/animation/bouncing_scale_tap.dart';
import '../../core/models/spectral_data_model.dart';
import '../../core/services/dual_sensor_service.dart';
import '../../core/widgets/spectral_radar_chart.dart';
import '../../core/widgets/common_app_bar.dart';
import '../secondary_pages/traceability_archive_page.dart';
import '../secondary_pages/hardware_settings_page.dart';

/// Tab 2: Origin Quality Grade Page (产地识别分级)
/// Real-time 3D Weighted Matrix & Authenticity Scoring
/// Powered by StreamBuilder listening to the background Isolate compute output.
class OriginGradePage extends StatelessWidget {
  const OriginGradePage({super.key});

  @override
  Widget build(BuildContext context) {
    final sensorService = DualSensorAcquisitionService.instance;

    return Scaffold(
      backgroundColor: TcmColors.background,
      appBar: CommonAppBar(
        title: '谱鉴药链 · 产地识别分级',
        subtitle: '多光谱与视觉双模鉴真',
        leadingIcon: Icons.science_rounded,
        onSettingsTap: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => const HardwareSettingsPage(),
            ),
          );
        },
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 720;
          final horizontalPadding =
              isWide ? TcmSpacing.marginDesktop : TcmSpacing.marginMobile;

          return StreamBuilder<OriginGradeReport>(
            stream: sensorService.gradeReportStream,
            initialData: sensorService.currentReport,
            builder: (context, snapshot) {
              final report = snapshot.data ?? sensorService.currentReport;

              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  12.0,
                  horizontalPadding,
                  110.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Batch Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.verified_rounded,
                              size: 18.0,
                              color: TcmColors.primary,
                            ),
                            const SizedBox(width: 4.0),
                            Text(
                              'LOT: ${report.lotNumber}',
                              style: TcmTypography.labelData(
                                color: TcmColors.secondary,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 4.0),
                          decoration: BoxDecoration(
                            color: TcmColors.tertiary.withOpacity(0.12),
                            borderRadius:
                                BorderRadius.circular(TcmSpacing.radiusFull),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 6.0,
                                height: 6.0,
                                decoration: const BoxDecoration(
                                  color: TcmColors.tertiary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 4.0),
                              Text(
                                '质检已归档',
                                style: TcmTypography.labelDataSmall(
                                  color: TcmColors.tertiary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),

                    // Primary Score Bento Card
                    _buildPrimaryScoreCard(context, report, isWide),
                    const SizedBox(height: 14.0),

                    // Title of Three-Dimensional Weighted Matrix
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 4.0,
                              height: 18.0,
                              decoration: BoxDecoration(
                                color: TcmColors.primary,
                                borderRadius: BorderRadius.circular(2.0),
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            Text(
                              '三维智能加权评定矩阵',
                              style: TcmTypography.headlineLgMobile(),
                            ),
                          ],
                        ),
                        Text(
                          '模型版本 v4.2.1',
                          style: TcmTypography.labelDataSmall(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),

                    // Dimension A: Spectral Fingerprint (40%)
                    _buildSpectralDimensionCard(context, report),
                    const SizedBox(height: 12.0),

                    // Dimension B: Growing Environment (30%)
                    _buildEnvironmentDimensionCard(context, report),
                    const SizedBox(height: 12.0),

                    // Dimension C: Standard Processing Technique (30%)
                    _buildProcessingDimensionCard(context, report),
                    const SizedBox(height: 14.0),

                    // Action Buttons (Export PDF & On-chain verify)
                    _buildActionButtons(context, report),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildPrimaryScoreCard(
      BuildContext context, OriginGradeReport report, bool isWide) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: TcmDecorations.card(
        shadows: [
          BoxShadow(
            color: TcmColors.primary.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '综合道地指数',
                    style: TcmTypography.labelDataSmall(
                      color: TcmColors.outline,
                    ).copyWith(letterSpacing: 0.08),
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    '道地药材智能鉴真与评分',
                    style: TcmTypography.headlineLgMobile(),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12.0, vertical: 6.0),
                decoration: BoxDecoration(
                  color: TcmColors.tertiary,
                  borderRadius:
                      BorderRadius.circular(TcmSpacing.radiusFull),
                  boxShadow: [
                    BoxShadow(
                      color: TcmColors.tertiary.withOpacity(0.25),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Text(
                  report.gradeLevel,
                  style: TcmTypography.labelData(color: Colors.white)
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),

          // Huge Visual Score Display + Radar
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      report.overallScore.toStringAsFixed(1),
                      style: TcmTypography.displayData(
                        color: TcmColors.primary,
                      ).copyWith(fontSize: 72.0),
                    ),
                    const SizedBox(width: 8.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '/100',
                          style: TcmTypography.headlineMd(
                            color: TcmColors.secondary,
                          ),
                        ),
                        Text(
                          '评定等级: 极优',
                          style: TcmTypography.labelDataSmall(
                            color: TcmColors.outline,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: OriginRadarChart(
                  spectralScore: report.spectralDimensionScore,
                  envScore: report.environmentDimensionScore,
                  processScore: report.processingDimensionScore,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),

          // Authenticity Stamp Ribbon
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
            decoration: BoxDecoration(
              color: TcmColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(TcmSpacing.radiusSm),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.workspace_premium_rounded,
                  size: 24.0,
                  color: TcmColors.primary,
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '长白山野山参道地官方认证',
                        style: TcmTypography.bodyMd().copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '地理标志认定代码: ${report.giCode}',
                        style: TcmTypography.labelDataSmall(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Dimension A
  Widget _buildSpectralDimensionCard(
      BuildContext context, OriginGradeReport report) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: TcmDecorations.card(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 38.0,
                    height: 38.0,
                    decoration: BoxDecoration(
                      color: TcmColors.primary.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.insights_rounded,
                      size: 22.0,
                      color: TcmColors.primary,
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('光谱特征指纹', style: TcmTypography.headlineMd()),
                          const SizedBox(width: 6.0),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6.0, vertical: 2.0),
                            decoration: BoxDecoration(
                              color: TcmColors.surfaceContainer,
                              borderRadius: BorderRadius.circular(
                                  TcmSpacing.radiusFull),
                            ),
                            child: Text(
                              '权重 40%',
                              style: TcmTypography.labelDataSmall(),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'AS7341 8通道近红外与可见光特征谱',
                        style: TcmTypography.labelDataSmall(),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${report.spectralDimensionScore}%',
                    style: TcmTypography.headlineLgMobile(
                      color: TcmColors.primary,
                    ),
                  ),
                  Text(
                    '优良无掺假',
                    style: TcmTypography.labelDataSmall(
                      color: TcmColors.tertiary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12.0),

          // Spectral Wave Chart
          SpectralWaveChart(spectralData: report.spectralData),
          const SizedBox(height: 8.0),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'HASH: ${report.spectralData.spectralHash}',
                style: TcmTypography.labelDataSmall(),
              ),
              Text(
                '主成分峰完全比对',
                style: TcmTypography.labelDataSmall(
                  color: TcmColors.tertiary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10.0),

          // 2 Mini detail cards
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: TcmColors.surfaceContainer,
                    borderRadius: BorderRadius.circular(TcmSpacing.radiusSm),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('人参皂苷Rg1/Re比值',
                          style: TcmTypography.labelDataSmall()),
                      const SizedBox(height: 2.0),
                      Text(
                        report.spectralData.saponinRatioRg1Re.toString(),
                        style: TcmTypography.headlineMd(),
                      ),
                      Text(
                        '药典规范合格 (≥1.20)',
                        style: TcmTypography.labelDataSmall(
                            color: TcmColors.tertiary),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: TcmColors.surfaceContainer,
                    borderRadius: BorderRadius.circular(TcmSpacing.radiusSm),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('外源添加剂筛查',
                          style: TcmTypography.labelDataSmall()),
                      const SizedBox(height: 2.0),
                      Text('未检出', style: TcmTypography.headlineMd()),
                      Text(
                        '零硫熏 / 零糖浸',
                        style: TcmTypography.labelDataSmall(
                            color: TcmColors.tertiary),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Dimension B
  Widget _buildEnvironmentDimensionCard(
      BuildContext context, OriginGradeReport report) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: TcmDecorations.card(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 38.0,
                    height: 38.0,
                    decoration: BoxDecoration(
                      color: TcmColors.tertiary.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.landscape_rounded,
                      size: 22.0,
                      color: TcmColors.tertiary,
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('产地生长环境', style: TcmTypography.headlineMd()),
                          const SizedBox(width: 6.0),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6.0, vertical: 2.0),
                            decoration: BoxDecoration(
                              color: TcmColors.surfaceContainer,
                              borderRadius: BorderRadius.circular(
                                  TcmSpacing.radiusFull),
                            ),
                            child: Text('权重 30%',
                                style: TcmTypography.labelDataSmall()),
                          ),
                        ],
                      ),
                      Text('吉林抚松核心道地产区',
                          style: TcmTypography.labelDataSmall()),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${report.environmentDimensionScore}%',
                    style: TcmTypography.headlineLgMobile(
                      color: TcmColors.tertiary,
                    ),
                  ),
                  Text('环境契合度', style: TcmTypography.labelDataSmall()),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12.0),

          // Location Banner
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: TcmColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(TcmSpacing.radiusSm),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('长白山西麓抚松核心基地',
                        style: TcmTypography.bodyMd().copyWith(
                            fontWeight: FontWeight.bold)),
                    Text('北纬 41°58′22″ · 海拔 840m',
                        style: TcmTypography.labelDataSmall()),
                  ],
                ),
                const Icon(Icons.pin_drop_rounded,
                    color: TcmColors.primary, size: 22.0),
              ],
            ),
          ),
          const SizedBox(height: 10.0),

          // 3 Environmental metrics
          Row(
            children: [
              Expanded(
                child: _buildEnvMiniCard(
                  '黑腐殖土',
                  '${report.humusSoilPercentage}%',
                  '有机质富集',
                  TcmColors.tertiary,
                ),
              ),
              const SizedBox(width: 6.0),
              Expanded(
                child: _buildEnvMiniCard(
                  '有效积温',
                  report.accumulatedTemperature.toString(),
                  '℃·d 年均',
                  TcmColors.secondary,
                ),
              ),
              const SizedBox(width: 6.0),
              Expanded(
                child: _buildEnvMiniCard(
                  '天然降水',
                  '${report.naturalPrecipitationMm}mm',
                  '水源纯净',
                  TcmColors.tertiary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEnvMiniCard(
      String title, String val, String tag, Color tagColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 6.0),
      decoration: BoxDecoration(
        color: TcmColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(TcmSpacing.radiusSm),
      ),
      child: Column(
        children: [
          Text(title, style: TcmTypography.labelDataSmall()),
          const SizedBox(height: 2.0),
          Text(val, style: TcmTypography.headlineMd()),
          const SizedBox(height: 2.0),
          Text(
            tag,
            style: TcmTypography.labelDataSmall(color: tagColor)
                .copyWith(fontSize: 10.0),
          ),
        ],
      ),
    );
  }

  // Dimension C
  Widget _buildProcessingDimensionCard(
      BuildContext context, OriginGradeReport report) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: TcmDecorations.card(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 38.0,
                height: 38.0,
                decoration: BoxDecoration(
                  color: TcmColors.secondaryContainer,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.precision_manufacturing_rounded,
                  size: 22.0,
                  color: TcmColors.primary,
                ),
              ),
              const SizedBox(width: 10.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('炮制工艺规范', style: TcmTypography.headlineMd()),
                      const SizedBox(width: 6.0),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6.0, vertical: 2.0),
                        decoration: BoxDecoration(
                          color: TcmColors.surfaceContainer,
                          borderRadius:
                              BorderRadius.circular(TcmSpacing.radiusFull),
                        ),
                        child: Text('权重 30%',
                            style: TcmTypography.labelDataSmall()),
                      ),
                    ],
                  ),
                  Text('刷洗排湿 · 低温冷风循环干燥',
                      style: TcmTypography.labelDataSmall()),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${report.processingDimensionScore}%',
                style: TcmTypography.headlineLgMobile(
                  color: TcmColors.primary,
                ),
              ),
              Text('工艺遵从度', style: TcmTypography.labelDataSmall()),
            ],
          ),
        ],
      ),
    );
  }

  // Action Buttons
  Widget _buildActionButtons(BuildContext context, OriginGradeReport report) {
    return Row(
      children: [
        Expanded(
          child: BouncingScaleTap(
            onTap: () {
              HapticFeedback.lightImpact();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('已生成道地鉴真报告 PDF 并导出至本地存证库',
                      style: TcmTypography.bodyMd(color: Colors.white)),
                  backgroundColor: TcmColors.primary,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: Container(
              height: 52.0,
              decoration: BoxDecoration(
                color: TcmColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(TcmSpacing.radiusDefault),
                border: Border.all(
                  color: TcmColors.outlineVariant,
                  width: 1.0,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.picture_as_pdf_rounded,
                      size: 20.0, color: TcmColors.primary),
                  const SizedBox(width: 6.0),
                  Text(
                    '导出鉴真报告',
                    style: TcmTypography.bodyMd().copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12.0),
        Expanded(
          child: BouncingScaleTap(
            onTap: () {
              HapticFeedback.mediumImpact();
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => const TraceabilityArchivePage(),
                ),
              );
            },
            child: Container(
              height: 52.0,
              decoration: BoxDecoration(
                color: TcmColors.primary,
                borderRadius: BorderRadius.circular(TcmSpacing.radiusDefault),
                boxShadow: [
                  BoxShadow(
                    color: TcmColors.primary.withOpacity(0.28),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.link_rounded,
                      size: 20.0, color: Colors.white),
                  const SizedBox(width: 6.0),
                  Text(
                    '链上存证哈希比对',
                    style: TcmTypography.bodyMd(color: Colors.white).copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

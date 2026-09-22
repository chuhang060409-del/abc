import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/tcm_theme.dart';
import '../../core/animation/bouncing_scale_tap.dart';
import '../../core/models/sensor_data_model.dart';
import '../../core/models/spectral_data_model.dart';
import '../../core/services/dual_sensor_service.dart';
import '../../core/widgets/custom_trend_chart.dart';
import '../../core/widgets/common_app_bar.dart';
import '../secondary_pages/parameter_presets_page.dart';
import '../secondary_pages/traceability_archive_page.dart';
import '../secondary_pages/hardware_settings_page.dart';

/// Tab 1: Warehouse Central Control Page (仓储中控)
/// Features localized ValueNotifier & StreamBuilder updates,
/// responsive LayoutBuilder, no hardcoded absolute dimensions,
/// and iOS BouncingScrollPhysics.
class WarehouseControlPage extends StatelessWidget {
  const WarehouseControlPage({super.key});

  void _copyLotNumber(BuildContext context, String lot) {
    Clipboard.setData(ClipboardData(text: lot));
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text('已成功复制批次号: $lot', style: TcmTypography.bodyMd(color: Colors.white)),
          ],
        ),
        backgroundColor: TcmColors.tertiary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(milliseconds: 1800),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sensorService = DualSensorAcquisitionService.instance;

    return Scaffold(
      backgroundColor: TcmColors.background,
      appBar: CommonAppBar(
        title: '谱鉴药链 · 药材恒温仓储系统',
        subtitle: 'NODE #A03 · 实时监控在线',
        leadingIcon: Icons.inventory_2_rounded,
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

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              12.0,
              horizontalPadding,
              110.0, // Space for floating bottom nav
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Cabin Status Overview Card
                _buildCabinOverviewCard(context, sensorService),
                const SizedBox(height: 12.0),

                // 2. Active TCM Herb Detail Bento Card
                _buildHerbDetailCard(context, sensorService),
                const SizedBox(height: 12.0),

                // 3. Ultra-large Metrics Dashboard (Temp & Humidity & CA Gases)
                _buildMetricsDashboard(context, sensorService, isWide),
                const SizedBox(height: 12.0),

                // 4. 24-Hour Trend Chart
                _buildTrendChartSection(context, sensorService),
                const SizedBox(height: 12.0),

                // 5. Quick Control Terminal (2x2 Grid)
                _buildControlTerminalGrid(context, sensorService, isWide),
              ],
            ),
          );
        },
      ),
    );
  }

  // 1. Cabin Status Overview
  Widget _buildCabinOverviewCard(
      BuildContext context, DualSensorAcquisitionService service) {
    return ValueListenableBuilder<CabinSensorData>(
      valueListenable: service.cabinState,
      builder: (context, data, child) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          decoration: TcmDecorations.card(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 8.0,
                          runSpacing: 4.0,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 4.0),
                              decoration: BoxDecoration(
                                color: TcmColors.primaryFixed,
                                borderRadius:
                                    BorderRadius.circular(TcmSpacing.radiusFull),
                              ),
                              child: Text(
                                '舱室 ${data.cabinCode}',
                                style: TcmTypography.labelData(
                                  color: TcmColors.onPrimaryFixed,
                                ),
                              ),
                            ),
                            Text(
                              data.cabinName,
                              style: TcmTypography.headlineLgMobile(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4.0),
                        Row(
                          children: [
                            const Icon(
                              Icons.check_circle_rounded,
                              size: 16.0,
                              color: TcmColors.tertiary,
                            ),
                            const SizedBox(width: 4.0),
                            Text(
                              '智能恒温恒湿 · 气调锁鲜循环运作中',
                              style: TcmTypography.bodyMd(
                                color: TcmColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Steady State Pill
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
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '运行稳态',
                          style: TcmTypography.labelData(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12.0),

              // Blockchain On-chain Status Bar
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
                    Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: TcmColors.primaryContainer.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.lock_rounded,
                            size: 16.0,
                            color: TcmColors.primary,
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          '存证区块高度',
                          style: TcmTypography.bodyMd(color: TcmColors.secondary),
                        ),
                        const SizedBox(width: 6.0),
                        Text(
                          data.blockHeight,
                          style: TcmTypography.labelData(
                            color: TcmColors.onSurface,
                          ).copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 3.0),
                      decoration: BoxDecoration(
                        color: TcmColors.tertiaryContainer.withOpacity(0.2),
                        borderRadius:
                            BorderRadius.circular(TcmSpacing.radiusFull),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.verified_user_rounded,
                            size: 14.0,
                            color: TcmColors.tertiary,
                          ),
                          const SizedBox(width: 3.0),
                          Text(
                            '秒级全链已确权',
                            style: TcmTypography.labelDataSmall(
                              color: TcmColors.tertiary,
                            ),
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
      },
    );
  }

  // 2. TCM Herb Detail Card
  Widget _buildHerbDetailCard(
      BuildContext context, DualSensorAcquisitionService service) {
    return ValueListenableBuilder<CabinSensorData>(
      valueListenable: service.cabinState,
      builder: (context, data, child) {
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
                        width: 4.0,
                        height: 20.0,
                        decoration: BoxDecoration(
                          color: TcmColors.primary,
                          borderRadius: BorderRadius.circular(2.0),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Text('吉林长白山鲜人参', style: TcmTypography.headlineLgMobile()),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: TcmColors.tertiaryContainer.withOpacity(0.25),
                      borderRadius:
                          BorderRadius.circular(TcmSpacing.radiusFull),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.workspace_premium_rounded,
                          size: 16.0,
                          color: TcmColors.tertiary,
                        ),
                        const SizedBox(width: 4.0),
                        Text(
                          'AAA级 特优',
                          style: TcmTypography.labelData(
                            color: TcmColors.tertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12.0, top: 2.0),
                child: Text(
                  '特级道地野山参 · 500g真空充氮保鲜装',
                  style: TcmTypography.bodyMd(color: TcmColors.secondary),
                ),
              ),
              const SizedBox(height: 12.0),

              // Lot code bar with BouncingScaleTap buttons
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12.0, vertical: 8.0),
                decoration: BoxDecoration(
                  color: TcmColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(TcmSpacing.radiusSm),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('溯源追踪批次 LOT',
                              style: TcmTypography.labelDataSmall()),
                          const SizedBox(height: 2.0),
                          Text(
                            data.lotNumber,
                            style: TcmTypography.labelData(
                              color: TcmColors.onSurface,
                            ).copyWith(fontSize: 14.5, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    BouncingScaleTap(
                      onTap: () => _copyLotNumber(context, data.lotNumber),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 8.0),
                        decoration: BoxDecoration(
                          color: TcmColors.surfaceContainerLowest,
                          borderRadius:
                              BorderRadius.circular(TcmSpacing.radiusFull),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.copy_rounded,
                                size: 16.0, color: TcmColors.primary),
                            const SizedBox(width: 4.0),
                            Text('复制',
                                style: TcmTypography.labelData(
                                    color: TcmColors.primary)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    BouncingScaleTap(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) =>
                                const TraceabilityArchivePage(),
                          ),
                        );
                      },
                      child: Container(
                        width: 36.0,
                        height: 36.0,
                        decoration: const BoxDecoration(
                          color: TcmColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.qr_code_scanner_rounded,
                          size: 20.0,
                          color: TcmColors.onPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12.0),

              // 3-Column Key Stats
              Row(
                children: [
                  Expanded(
                    child: _buildBentoStatItem(
                      '在仓总重',
                      data.totalWeightKg.toStringAsFixed(0),
                      'KG 公斤',
                      TcmColors.onSurface,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: _buildBentoStatItem(
                      '库龄天数',
                      data.storageDays.toString(),
                      '天 (第2周)',
                      TcmColors.primary,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: _buildBentoStatItem(
                      '鲜参活性值',
                      '${data.freshActiveIndex}%',
                      '极佳',
                      TcmColors.tertiary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBentoStatItem(
      String title, String value, String unit, Color valColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
      decoration: BoxDecoration(
        color: TcmColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(TcmSpacing.radiusSm),
      ),
      child: Column(
        children: [
          Text(title, style: TcmTypography.labelDataSmall()),
          const SizedBox(height: 4.0),
          Text(
            value,
            style: TcmTypography.headlineLgMobile(color: valColor),
          ),
          const SizedBox(height: 2.0),
          Text(unit, style: TcmTypography.labelDataSmall()),
        ],
      ),
    );
  }

  // 3. Ultra-large Metrics Dashboard
  Widget _buildMetricsDashboard(BuildContext context,
      DualSensorAcquisitionService service, bool isWide) {
    return ValueListenableBuilder<CabinSensorData>(
      valueListenable: service.cabinState,
      builder: (context, data, child) {
        final tempCard = Container(
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
                          color: TcmColors.errorContainer.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.device_thermostat_rounded,
                          size: 22.0,
                          color: TcmColors.error,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('库内实际温度', style: TcmTypography.headlineMd()),
                          Text('设定基准 2.0 ~ 6.0℃',
                              style: TcmTypography.labelDataSmall()),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: TcmColors.surfaceContainerHigh,
                      borderRadius:
                          BorderRadius.circular(TcmSpacing.radiusFull),
                    ),
                    child: Text('探头阵列#1',
                        style: TcmTypography.labelDataSmall()),
                  ),
                ],
              ),
              const SizedBox(height: 12.0),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      data.currentTemp.toStringAsFixed(1),
                      style: TcmTypography.displayData(),
                    ),
                    const SizedBox(width: 4.0),
                    Text(
                      '℃',
                      style: TcmTypography.headlineLg(
                          color: TcmColors.secondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12.0),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12.0, vertical: 8.0),
                decoration: BoxDecoration(
                  color: TcmColors.surfaceContainerLow,
                  borderRadius:
                      BorderRadius.circular(TcmSpacing.radiusFull),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
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
                        const SizedBox(width: 6),
                        Text('恒速制冷', style: TcmTypography.bodyMd()),
                      ],
                    ),
                    Text('压缩机组 #1 运行',
                        style: TcmTypography.labelDataSmall()),
                  ],
                ),
              ),
            ],
          ),
        );

        final humCard = Container(
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
                          color: TcmColors.primaryFixed,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.water_drop_rounded,
                          size: 22.0,
                          color: TcmColors.primary,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('库内相对湿度', style: TcmTypography.headlineMd()),
                          Text('设定基准 60.0 ~ 70.0%',
                              style: TcmTypography.labelDataSmall()),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: TcmColors.surfaceContainerHigh,
                      borderRadius:
                          BorderRadius.circular(TcmSpacing.radiusFull),
                    ),
                    child: Text('红外感湿#3',
                        style: TcmTypography.labelDataSmall()),
                  ),
                ],
              ),
              const SizedBox(height: 12.0),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      data.currentHumidity.toStringAsFixed(1),
                      style: TcmTypography.displayData(),
                    ),
                    const SizedBox(width: 4.0),
                    Text(
                      '%',
                      style: TcmTypography.headlineLg(
                          color: TcmColors.secondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12.0),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12.0, vertical: 8.0),
                decoration: BoxDecoration(
                  color: TcmColors.surfaceContainerLow,
                  borderRadius:
                      BorderRadius.circular(TcmSpacing.radiusFull),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: TcmColors.tertiary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text('微湿平衡', style: TcmTypography.bodyMd()),
                      ],
                    ),
                    Text('超声波雾化泵待机',
                        style: TcmTypography.labelDataSmall()),
                  ],
                ),
              ),
            ],
          ),
        );

        return Column(
          children: [
            if (isWide)
              Row(
                children: [
                  Expanded(child: tempCard),
                  const SizedBox(width: 12.0),
                  Expanded(child: humCard),
                ],
              )
            else ...[
              tempCard,
              const SizedBox(height: 12.0),
              humCard,
            ],
            const SizedBox(height: 12.0),

            // Controlled Atmosphere Mini Indicators
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: TcmDecorations.card(),
              child: Row(
                children: [
                  Expanded(
                    child: _buildCAMicroItem(
                      'O₂ 氧气浓度',
                      '${data.oxygenPercentage}%',
                      '低氧抑菌休眠',
                      Icons.air_rounded,
                      TcmColors.tertiary,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: _buildCAMicroItem(
                      'N₂ 充盈度',
                      '${data.nitrogenPercentage}%',
                      '高纯锁鲜保护',
                      Icons.shield_rounded,
                      TcmColors.primary,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: _buildCAMicroItem(
                      '舱内微正压',
                      '+${data.microPositivePressurePa} Pa',
                      '防外界尘菌渗透',
                      Icons.compress_rounded,
                      TcmColors.secondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCAMicroItem(String label, String value, String tag,
      IconData icon, Color accentColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 6.0),
      decoration: BoxDecoration(
        color: TcmColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(TcmSpacing.radiusSm),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 15.0, color: TcmColors.secondary),
              const SizedBox(width: 3.0),
              Text(label, style: TcmTypography.labelDataSmall()),
            ],
          ),
          const SizedBox(height: 4.0),
          Text(value, style: TcmTypography.headlineLgMobile()),
          const SizedBox(height: 2.0),
          Text(tag,
              style: TcmTypography.labelDataSmall(color: accentColor)
                  .copyWith(fontSize: 10.0)),
        ],
      ),
    );
  }

  // 4. Trend Chart Section
  Widget _buildTrendChartSection(
      BuildContext context, DualSensorAcquisitionService service) {
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
                    width: 4.0,
                    height: 20.0,
                    decoration: BoxDecoration(
                      color: TcmColors.primary,
                      borderRadius: BorderRadius.circular(2.0),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Text('温湿度实时与历史趋势', style: TcmTypography.headlineLgMobile()),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: TcmColors.primary,
                  borderRadius:
                      BorderRadius.circular(TcmSpacing.radiusFull),
                ),
                child: Text(
                  '24小时',
                  style: TcmTypography.labelData(color: Colors.white),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0, top: 2.0, bottom: 8.0),
            child: Text(
              '高精温湿传感器阵列采样 · 24小时周期记录',
              style: TcmTypography.bodyMd(color: TcmColors.outline),
            ),
          ),

          // High-performance Trend Chart
          ValueListenableBuilder<CabinSensorData>(
            valueListenable: service.cabinState,
            builder: (context, data, child) {
              return CustomTrendChart(
                currentTemp: data.currentTemp,
                currentHumidity: data.currentHumidity,
              );
            },
          ),
          const SizedBox(height: 10.0),

          // Pharmacopoeia compliance banner
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: TcmColors.tertiaryContainer.withOpacity(0.2),
              borderRadius: BorderRadius.circular(TcmSpacing.radiusSm),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.verified_rounded,
                  size: 18.0,
                  color: TcmColors.tertiary,
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Text(
                    '近24小时波动均在《中国药典》鲜参储藏安全阈值内，未触发预警',
                    style: TcmTypography.bodyMd(color: TcmColors.onSurface)
                        .copyWith(fontSize: 13.0, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 5. Control Terminal Grid (2x2)
  Widget _buildControlTerminalGrid(BuildContext context,
      DualSensorAcquisitionService service, bool isWide) {
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
                    width: 4.0,
                    height: 20.0,
                    decoration: BoxDecoration(
                      color: TcmColors.primary,
                      borderRadius: BorderRadius.circular(2.0),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Text('仓控快捷操作终端', style: TcmTypography.headlineLgMobile()),
                ],
              ),
              Text('手套防误触模式开启', style: TcmTypography.labelDataSmall()),
            ],
          ),
          const SizedBox(height: 12.0),

          // 2x2 Big Touch Target Buttons
          Row(
            children: [
              Expanded(
                child: _buildBigTouchButton(
                  title: '手动调温',
                  subtitle: '基准微调 ±0.5℃',
                  icon: Icons.tune_rounded,
                  iconColor: TcmColors.primary,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => const ParameterPresetsPage(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: _buildBigTouchButton(
                  title: '气调微调',
                  subtitle: 'N₂注入 / 排湿',
                  icon: Icons.air_rounded,
                  iconColor: TcmColors.tertiary,
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('已启动气调保鲜自适应注氮循环',
                            style: TcmTypography.bodyMd(color: Colors.white)),
                        backgroundColor: TcmColors.tertiary,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          Row(
            children: [
              Expanded(
                child: _buildBigTouchButton(
                  title: '批次台账',
                  subtitle: '调拨出库与入库',
                  icon: Icons.receipt_long_rounded,
                  iconColor: TcmColors.secondary,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) =>
                            const TraceabilityArchivePage(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: _buildBigTouchButton(
                  title: '链上确权',
                  subtitle: '生成新区块Hash',
                  icon: Icons.token_rounded,
                  iconColor: Colors.white,
                  isPrimaryFilled: true,
                  onTap: () {
                    HapticFeedback.heavyImpact();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            const Icon(Icons.verified_rounded,
                                color: Colors.white),
                            const SizedBox(width: 8),
                            Text('国密算法存证已上链: #18,492,032',
                                style:
                                    TcmTypography.bodyMd(color: Colors.white)),
                          ],
                        ),
                        backgroundColor: TcmColors.primary,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBigTouchButton({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
    bool isPrimaryFilled = false,
  }) {
    return BouncingScaleTap(
      onTap: onTap,
      child: Container(
        height: 76.0,
        padding: const EdgeInsets.symmetric(horizontal: 14.0),
        decoration: BoxDecoration(
          color: isPrimaryFilled
              ? TcmColors.primary
              : TcmColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(TcmSpacing.radiusDefault),
          border: isPrimaryFilled
              ? null
              : Border.all(
                  color: TcmColors.surfaceContainerHigh.withOpacity(0.6),
                  width: 1,
                ),
          boxShadow: [
            BoxShadow(
              color: isPrimaryFilled
                  ? TcmColors.primary.withOpacity(0.28)
                  : Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 42.0,
              height: 42.0,
              decoration: BoxDecoration(
                color: isPrimaryFilled
                    ? Colors.white.withOpacity(0.2)
                    : TcmColors.surfaceContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 22.0, color: iconColor),
            ),
            const SizedBox(width: 10.0),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TcmTypography.headlineMd(
                      color: isPrimaryFilled
                          ? Colors.white
                          : TcmColors.onSurface,
                    ).copyWith(fontSize: 16.0),
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TcmTypography.labelDataSmall(
                      color: isPrimaryFilled
                          ? Colors.white70
                          : TcmColors.outline,
                    ).copyWith(fontSize: 11.0),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

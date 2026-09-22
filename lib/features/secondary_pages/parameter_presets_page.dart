import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/tcm_theme.dart';
import '../../core/animation/bouncing_scale_tap.dart';
import '../../core/services/dual_sensor_service.dart';

/// Secondary Page: Parameter Presets (参数预设模板)
/// Pushed via CupertinoPageRoute with native iOS edge slide-to-pop.
class ParameterPresetsPage extends StatefulWidget {
  const ParameterPresetsPage({super.key});

  @override
  State<ParameterPresetsPage> createState() => _ParameterPresetsPageState();
}

class _ParameterPresetsPageState extends State<ParameterPresetsPage> {
  int _selectedTemplateIndex = 0;

  final List<Map<String, dynamic>> _templates = [
    {
      'name': '人参 (长白山野山参)',
      'category': '根茎类 · 严控温湿度',
      'icon': Icons.psychiatry_rounded,
      'temp': 3.8,
      'tempRange': '2.0 ~ 6.0℃',
      'humidity': 64.5,
      'humRange': '60.0 ~ 70.0%',
      'n2Purity': 96.0,
      'o2Target': 3.2,
      'pressure': 12,
    },
    {
      'name': '三七 (文山三七)',
      'category': '根茎类 · 忌高温发酵',
      'icon': Icons.spa_rounded,
      'temp': 12.0,
      'tempRange': '10.0 ~ 15.0℃',
      'humidity': 50.0,
      'humRange': '45.0 ~ 55.0%',
      'n2Purity': 95.0,
      'o2Target': 4.0,
      'pressure': 10,
    },
    {
      'name': '当归 (岷县当归)',
      'category': '挥发油丰富 · 防泛油变色',
      'icon': Icons.eco_rounded,
      'temp': 10.0,
      'tempRange': '8.0 ~ 12.0℃',
      'humidity': 55.0,
      'humRange': '50.0 ~ 60.0%',
      'n2Purity': 96.5,
      'o2Target': 3.0,
      'pressure': 15,
    },
    {
      'name': '枸杞 (宁夏枸杞)',
      'category': '糖分极高 · 严防潮解发粘',
      'icon': Icons.grain_rounded,
      'temp': 8.0,
      'tempRange': '5.0 ~ 10.0℃',
      'humidity': 42.0,
      'humRange': '38.0 ~ 45.0%',
      'n2Purity': 97.0,
      'o2Target': 2.5,
      'pressure': 12,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final active = _templates[_selectedTemplateIndex];

    return Scaffold(
      backgroundColor: TcmColors.background,
      appBar: CupertinoNavigationBar(
        backgroundColor: TcmColors.surface.withOpacity(0.88),
        middle: Text(
          '参数预设模板',
          style: TcmTypography.headlineMd().copyWith(fontSize: 17.0),
        ),
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
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '选择适合当前仓储药材的恒温气调配置',
                  style: TcmTypography.bodyMd(color: TcmColors.onSurfaceVariant),
                ),
                const SizedBox(height: 14.0),

                // Grid of 4 Presets
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isWide ? 2 : 1,
                    mainAxisExtent: 180.0,
                    crossAxisSpacing: 12.0,
                    mainAxisSpacing: 12.0,
                  ),
                  itemCount: _templates.length,
                  itemBuilder: (context, index) {
                    final item = _templates[index];
                    final isSelected = index == _selectedTemplateIndex;

                    return BouncingScaleTap(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        setState(() {
                          _selectedTemplateIndex = index;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: TcmColors.surfaceContainerLowest,
                          borderRadius:
                              BorderRadius.circular(TcmSpacing.radiusDefault),
                          border: Border.all(
                            color: isSelected
                                ? TcmColors.primary
                                : TcmColors.outlineVariant.withOpacity(0.5),
                            width: isSelected ? 2.5 : 1.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isSelected
                                  ? TcmColors.primary.withOpacity(0.18)
                                  : Colors.black.withOpacity(0.03),
                              blurRadius: isSelected ? 12 : 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                        color: isSelected
                                            ? TcmColors.primaryFixed
                                            : TcmColors.surfaceContainer,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        item['icon'] as IconData,
                                        color: isSelected
                                            ? TcmColors.primary
                                            : TcmColors.secondary,
                                        size: 22.0,
                                      ),
                                    ),
                                    const SizedBox(width: 10.0),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item['name'] as String,
                                          style: TcmTypography.headlineMd(
                                            color: isSelected
                                                ? TcmColors.primary
                                                : TcmColors.onSurface,
                                          ).copyWith(fontSize: 16.5),
                                        ),
                                        Text(
                                          item['category'] as String,
                                          style: TcmTypography.labelDataSmall(),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                if (isSelected)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 3.0),
                                    decoration: BoxDecoration(
                                      color: TcmColors.primary,
                                      borderRadius: BorderRadius.circular(
                                          TcmSpacing.radiusFull),
                                    ),
                                    child: Text(
                                      '当前选中',
                                      style: TcmTypography.labelDataSmall(
                                        color: Colors.white,
                                      ).copyWith(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      color: TcmColors.surfaceContainerLow,
                                      borderRadius: BorderRadius.circular(
                                          TcmSpacing.radiusSm),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('目标温度',
                                            style: TcmTypography
                                                .labelDataSmall()),
                                        Text(
                                          item['tempRange'] as String,
                                          style: TcmTypography.bodyMd()
                                              .copyWith(
                                                  fontWeight:
                                                      FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8.0),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      color: TcmColors.surfaceContainerLow,
                                      borderRadius: BorderRadius.circular(
                                          TcmSpacing.radiusSm),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('目标湿度',
                                            style: TcmTypography
                                                .labelDataSmall()),
                                        Text(
                                          item['humRange'] as String,
                                          style: TcmTypography.bodyMd()
                                              .copyWith(
                                                  fontWeight:
                                                      FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20.0),

                // Detailed Parameter Sliders and Target Control
                Container(
                  padding: const EdgeInsets.all(18.0),
                  decoration: TcmDecorations.card(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        '微环境控制目标精细调优',
                        style: TcmTypography.headlineMd(),
                      ),
                      const SizedBox(height: 12.0),
                      _buildSliderRow(
                        '设定基准温度',
                        '${active['temp']} ℃',
                        active['temp'] as double,
                        0.0,
                        25.0,
                        (v) {},
                      ),
                      const SizedBox(height: 10.0),
                      _buildSliderRow(
                        '设定基准湿度',
                        '${active['humidity']} %',
                        active['humidity'] as double,
                        30.0,
                        80.0,
                        (v) {},
                      ),
                      const SizedBox(height: 10.0),
                      _buildSliderRow(
                        'N₂ 气调充盈目标',
                        '${active['n2Purity']} %',
                        active['n2Purity'] as double,
                        85.0,
                        99.0,
                        (v) {},
                      ),
                      const SizedBox(height: 16.0),

                      // Apply Button
                      BouncingScaleTap(
                        onTap: () {
                          HapticFeedback.heavyImpact();
                          final s = DualSensorAcquisitionService.instance;
                          final curr = s.cabinState.value;
                          s.cabinState.value = curr.copyWith(
                            currentTemp: active['temp'] as double,
                            currentHumidity: active['humidity'] as double,
                            nitrogenPercentage: active['n2Purity'] as double,
                            oxygenPercentage: active['o2Target'] as double,
                            microPositivePressurePa: active['pressure'] as int,
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '已成功将【${active['name']}】预设参数应用至当前保鲜仓！',
                                style: TcmTypography.bodyMd(color: Colors.white),
                              ),
                              backgroundColor: TcmColors.primary,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 52.0,
                          decoration: BoxDecoration(
                            color: TcmColors.primary,
                            borderRadius:
                                BorderRadius.circular(TcmSpacing.radiusDefault),
                            boxShadow: [
                              BoxShadow(
                                color: TcmColors.primary.withOpacity(0.32),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              '应用此模板至当前舱室 (A-01)',
                              style: TcmTypography.bodyMd(color: Colors.white)
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSliderRow(String label, String valText, double value, double min,
      double max, ValueChanged<double> onChanged) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: TcmTypography.bodyMd()),
            Text(valText,
                style: TcmTypography.headlineMd(color: TcmColors.primary)
                    .copyWith(fontSize: 16.0)),
          ],
        ),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: TcmColors.primary,
            inactiveTrackColor: TcmColors.surfaceContainerHigh,
            thumbColor: TcmColors.primary,
            overlayColor: TcmColors.primary.withOpacity(0.12),
            trackHeight: 4.0,
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            onChanged: (newVal) {},
          ),
        ),
      ],
    );
  }
}

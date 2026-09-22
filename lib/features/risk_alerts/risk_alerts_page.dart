import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/tcm_theme.dart';
import '../../core/animation/bouncing_scale_tap.dart';
import '../../core/widgets/common_app_bar.dart';
import '../secondary_pages/hardware_settings_page.dart';

/// Tab 4: Intelligent Risk Alerts Engine (智能风险预警引擎 · CORE-V6.2)
class RiskAlertsPage extends StatelessWidget {
  const RiskAlertsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TcmColors.background,
      appBar: CommonAppBar(
        title: '谱鉴药链 · 风险预警',
        subtitle: 'CORE-V6.2 · 实时联锁激活',
        leadingIcon: Icons.warning_amber_rounded,
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
              110.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Operational Banner
                _buildOperationalBanner(context),
                const SizedBox(height: 14.0),

                // Diagnostic Alert Cards
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
                        Text('实时预警与联锁诊断流', style: TcmTypography.headlineLgMobile()),
                      ],
                    ),
                    Text('共3项运行事件', style: TcmTypography.labelDataSmall()),
                  ],
                ),
                const SizedBox(height: 10.0),

                _buildAlertItem(
                  context,
                  title: '舱室 B-02 湿度微升预警',
                  desc: '当前湿度 68.2% 逼近设定基准上限 70.0% · 气调排湿与超声波调控已自动联动介入降湿',
                  severity: 'WARNING',
                  cabinId: '舱室 B-02 (岷县当归)',
                  timestamp: '10分钟前',
                  icon: Icons.water_drop_rounded,
                  accentColor: const Color(0xFFD97706),
                ),
                const SizedBox(height: 10.0),

                _buildAlertItem(
                  context,
                  title: 'A区01号仓 运行稳态极佳',
                  desc: '吉林长白山鲜人参仓储微环境温度 3.8℃ / 湿度 64.5% / N₂ 96.0% 均处《中国药典》最优储藏区间',
                  severity: 'STABLE',
                  cabinId: '舱室 A-01 (野山参)',
                  timestamp: '实时监控中',
                  icon: Icons.check_circle_rounded,
                  accentColor: TcmColors.tertiary,
                ),
                const SizedBox(height: 10.0),

                _buildAlertItem(
                  context,
                  title: 'AS7341 多光谱与OpenMV双模基线自检',
                  desc: '光度通道增益校准通过 · 显微镜头对焦灵敏度99.4% · 建议18天后进行例行标准白板标定',
                  severity: 'INFO',
                  cabinId: '多光谱采集终端 #01',
                  timestamp: '08:00 今日',
                  icon: Icons.biotech_rounded,
                  accentColor: TcmColors.primary,
                ),
                const SizedBox(height: 16.0),

                // Emergency Control Actions
                _buildEmergencyCard(context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOperationalBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18.0),
      decoration: TcmDecorations.card(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 48.0,
                        height: 48.0,
                        decoration: const BoxDecoration(
                          color: TcmColors.primaryContainer,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.verified_user_rounded,
                          color: Colors.white,
                          size: 26.0,
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          width: 12.0,
                          height: 12.0,
                          decoration: BoxDecoration(
                            color: TcmColors.tertiary,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('智能风险预警引擎', style: TcmTypography.headlineMd()),
                      const SizedBox(height: 2.0),
                      Row(
                        children: [
                          const Icon(Icons.bolt_rounded,
                              size: 14.0, color: TcmColors.tertiary),
                          const SizedBox(width: 2.0),
                          Text(
                            '全链路守护中 · 实时联锁激活',
                            style: TcmTypography.labelDataSmall(
                                color: TcmColors.tertiary),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: TcmColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(TcmSpacing.radiusFull),
                ),
                child: Text('CORE-V6.2',
                    style: TcmTypography.labelDataSmall(
                      color: TcmColors.secondary,
                    ).copyWith(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 14.0),

          // 3-Col Quick Status
          Row(
            children: [
              Expanded(
                child: _buildBannerStat(
                    '传感器在线率', '100%', '32/32 探头', TcmColors.tertiary),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: _buildBannerStat(
                    '预警响应延迟', '<12ms', '纳秒级中断', TcmColors.primary),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: _buildBannerStat(
                    '联锁保护范围', '8舱全覆', '气调锁鲜', TcmColors.secondary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBannerStat(
      String title, String val, String desc, Color accent) {
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
          Text(val,
              style: TcmTypography.headlineMd(color: accent)
                  .copyWith(fontSize: 18.0)),
          const SizedBox(height: 2.0),
          Text(desc, style: TcmTypography.labelDataSmall()),
        ],
      ),
    );
  }

  Widget _buildAlertItem(
    BuildContext context, {
    required String title,
    required String desc,
    required String severity,
    required String cabinId,
    required String timestamp,
    required IconData icon,
    required Color accentColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: TcmDecorations.card(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 32.0,
                    height: 32.0,
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, size: 18.0, color: accentColor),
                  ),
                  const SizedBox(width: 8.0),
                  Text(title,
                      style: TcmTypography.headlineMd().copyWith(fontSize: 16.0)),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(TcmSpacing.radiusFull),
                ),
                child: Text(
                  severity,
                  style: TcmTypography.labelDataSmall(color: accentColor)
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Text(desc, style: TcmTypography.bodyMd()),
          const SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('受影响节点: $cabinId', style: TcmTypography.labelDataSmall()),
              Text(timestamp, style: TcmTypography.labelDataSmall()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: TcmColors.errorContainer.withOpacity(0.35),
        borderRadius: BorderRadius.circular(TcmSpacing.radiusDefault),
        border: Border.all(color: TcmColors.error.withOpacity(0.25), width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.shield_rounded,
                  color: TcmColors.error, size: 24.0),
              const SizedBox(width: 8.0),
              Text(
                '应急保护联锁终端',
                style: TcmTypography.headlineMd(color: TcmColors.error),
              ),
            ],
          ),
          const SizedBox(height: 6.0),
          Text(
            '当监测到极端气调泄漏或温湿严重异常时，可手动触发紧急气调闭锁，全仓注氮阻氧并封闭循环管路。',
            style: TcmTypography.bodyMd(color: TcmColors.onSurfaceVariant),
          ),
          const SizedBox(height: 12.0),
          BouncingScaleTap(
            onTap: () {
              HapticFeedback.heavyImpact();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('全仓应急自闭锁已触发，系统安全协议已生效！',
                      style: TcmTypography.bodyMd(color: Colors.white)),
                  backgroundColor: TcmColors.error,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: Container(
              height: 48.0,
              decoration: BoxDecoration(
                color: TcmColors.error,
                borderRadius: BorderRadius.circular(TcmSpacing.radiusDefault),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.emergency_rounded,
                      color: Colors.white, size: 20.0),
                  const SizedBox(width: 8.0),
                  Text(
                    '一键气调应急自闭锁',
                    style: TcmTypography.bodyMd(color: Colors.white).copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

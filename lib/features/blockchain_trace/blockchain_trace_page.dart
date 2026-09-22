import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/tcm_theme.dart';
import '../../core/animation/bouncing_scale_tap.dart';
import '../../core/widgets/common_app_bar.dart';
import '../secondary_pages/traceability_archive_page.dart';
import '../secondary_pages/hardware_settings_page.dart';

/// Tab 3: Blockchain Traceability Page (国密算法存证链 · 谱鉴药链)
/// Features anti-counterfeit QR verification, immutable timestamps,
/// and full-lifecycle cryptographic timeline with iOS bouncing physics.
class BlockchainTracePage extends StatelessWidget {
  const BlockchainTracePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TcmColors.background,
      appBar: CommonAppBar(
        title: '谱鉴药链 · 国密存证',
        subtitle: 'SM2/SM3 级加密 · 8节点同步',
        leadingIcon: Icons.hub_rounded,
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
                // Top Banner & Node Sync Status
                _buildTopBanner(context),
                const SizedBox(height: 12.0),

                // QR & Authenticity Section (一物一码验真区)
                _buildQRCodeAuthenticitySection(context),
                const SizedBox(height: 14.0),

                // Timeline Section Title
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
                        Text('全流程溯源存证时序', style: TcmTypography.headlineLgMobile()),
                      ],
                    ),
                    Text('共5个链上区块', style: TcmTypography.labelDataSmall()),
                  ],
                ),
                const SizedBox(height: 10.0),

                // Chronological Timeline Cards
                _buildTimelineList(context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTopBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: TcmDecorations.card(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 42.0,
                height: 42.0,
                decoration: BoxDecoration(
                  color: TcmColors.primaryFixed,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.verified_user_rounded,
                  color: TcmColors.primary,
                  size: 24.0,
                ),
              ),
              const SizedBox(width: 12.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('国密算法存证链', style: TcmTypography.headlineMd()),
                      const SizedBox(width: 8.0),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 2.0),
                        decoration: BoxDecoration(
                          color: TcmColors.tertiaryContainer,
                          borderRadius:
                              BorderRadius.circular(TcmSpacing.radiusFull),
                        ),
                        child: Text(
                          '8节点已同步',
                          style: TcmTypography.labelDataSmall(
                            color: TcmColors.onTertiaryContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    'SM2/SM3 级加密 · 不可篡改时间戳',
                    style: TcmTypography.labelDataSmall(),
                  ),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('区块高度', style: TcmTypography.labelDataSmall()),
              Text(
                '#18,492,031',
                style: TcmTypography.labelData(
                  color: TcmColors.primary,
                ).copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQRCodeAuthenticitySection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: TcmDecorations.card(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('一物一码验真区', style: TcmTypography.headlineMd()),
                  Text('消费端与监管端双向防伪溯源',
                      style: TcmTypography.bodyMd(color: TcmColors.secondary)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: TcmColors.tertiary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(TcmSpacing.radiusFull),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_rounded,
                        color: TcmColors.tertiary, size: 16.0),
                    const SizedBox(width: 4.0),
                    Text(
                      '验真通过',
                      style: TcmTypography.labelDataSmall(
                          color: TcmColors.tertiary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),

          // Center Simulated QR Container
          Center(
            child: Container(
              padding: const EdgeInsets.all(14.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(TcmSpacing.radiusDefault),
                border: Border.all(color: TcmColors.primaryFixed, width: 2.0),
                boxShadow: [
                  BoxShadow(
                    color: TcmColors.primary.withOpacity(0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.qr_code_2_rounded,
                    size: 130.0,
                    color: TcmColors.onSurface,
                  ),
                  const SizedBox(height: 6.0),
                  Text(
                    '防伪识别码: 9203-8812-4019-3321',
                    style: TcmTypography.labelDataSmall(
                      color: TcmColors.secondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16.0),

          // Verification Hash Box
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
            decoration: BoxDecoration(
              color: TcmColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(TcmSpacing.radiusSm),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('国密存证哈希 SM3', style: TcmTypography.labelDataSmall()),
                    Text('验证一致率 100%',
                        style: TcmTypography.labelDataSmall(
                            color: TcmColors.tertiary)),
                  ],
                ),
                const SizedBox(height: 4.0),
                Text(
                  '0x8f2b3e41982c7a6e4d2091b4c3e801ab8829f0e1c2a3b4c5d6e7f8091a2b3c4d',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TcmTypography.labelData(color: TcmColors.primary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineList(BuildContext context) {
    final steps = [
      {
        'title': '道地种植基地采收',
        'sub': '抚松万良人参种植基地 · 09-08 09:30',
        'operator': '种植户：王长贵 (数字证书认证)',
        'hash': '0x3a9f...e420',
        'icon': Icons.potted_plant_rounded,
        'color': TcmColors.tertiary,
      },
      {
        'title': '气调初加工与清洗',
        'sub': '抚松万良初加工中心 · 09-10 14:20',
        'operator': '技工：李国强 · 零硫熏冷风干燥核验',
        'hash': '0x7b1c...d881',
        'icon': Icons.cleaning_services_rounded,
        'color': TcmColors.secondary,
      },
      {
        'title': 'AS7341与OpenMV双模质检',
        'sub': '药企数字化中心实验室 · 09-12 10:15',
        'operator': '质检员：张雪峰 · 综合道地98.5分',
        'hash': '0x4d2e...993f',
        'icon': Icons.biotech_rounded,
        'color': TcmColors.primary,
      },
      {
        'title': '气调恒温保鲜入库',
        'sub': 'A区01号气调保鲜仓 (TCM-A892) · 09-14 16:45',
        'operator': '仓储中控系统 · 3.8℃ / 64.5% RH 连续存证',
        'hash': '0x8f2b...3321',
        'icon': Icons.inventory_2_rounded,
        'color': TcmColors.tertiary,
      },
    ];

    return Column(
      children: List.generate(steps.length, (index) {
        final item = steps[index];
        final isLast = index == steps.length - 1;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Timeline line and dot
              Column(
                children: [
                  Container(
                    width: 32.0,
                    height: 32.0,
                    decoration: BoxDecoration(
                      color: (item['color'] as Color).withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      item['icon'] as IconData,
                      size: 18.0,
                      color: item['color'] as Color,
                    ),
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 2.0,
                        color: TcmColors.outlineVariant.withOpacity(0.5),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12.0),

              // Step Detail Card
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : 12.0),
                  child: BouncingScaleTap(
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
                      padding: const EdgeInsets.all(14.0),
                      decoration: TcmDecorations.card(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(item['title'] as String,
                                  style: TcmTypography.headlineMd()
                                      .copyWith(fontSize: 16.0)),
                              const Icon(Icons.arrow_forward_ios_rounded,
                                  size: 14.0, color: TcmColors.outline),
                            ],
                          ),
                          const SizedBox(height: 2.0),
                          Text(item['sub'] as String,
                              style: TcmTypography.labelDataSmall()),
                          const SizedBox(height: 4.0),
                          Text(item['operator'] as String,
                              style: TcmTypography.bodyMd(
                                  color: TcmColors.onSurfaceVariant)),
                          const SizedBox(height: 6.0),
                          Text(
                            '存证交易Hash: ${item['hash']}',
                            style: TcmTypography.labelDataSmall(
                                color: TcmColors.primary),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

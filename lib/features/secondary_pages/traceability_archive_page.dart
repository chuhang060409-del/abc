import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/tcm_theme.dart';
import '../../core/animation/bouncing_scale_tap.dart';

/// Secondary Page: Traceability Full Archive (追溯档案)
/// Pushed with CupertinoPageRoute with native iOS edge swipe pop.
class TraceabilityArchivePage extends StatelessWidget {
  const TraceabilityArchivePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TcmColors.background,
      appBar: CupertinoNavigationBar(
        backgroundColor: TcmColors.surface.withOpacity(0.88),
        middle: Text(
          '全生命周期追溯档案',
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
                // Digital Certificate Banner Card
                Container(
                  padding: const EdgeInsets.all(18.0),
                  decoration: TcmDecorations.card(
                    shadows: [
                      BoxShadow(
                        color: TcmColors.primary.withOpacity(0.08),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 44.0,
                                height: 44.0,
                                decoration: BoxDecoration(
                                  color: TcmColors.primaryFixed,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.verified_user_rounded,
                                  color: TcmColors.primary,
                                  size: 26.0,
                                ),
                              ),
                              const SizedBox(width: 12.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('国家道地中药材数字存证证书',
                                      style: TcmTypography.headlineMd()),
                                  Text(
                                    '证书编号: CERT-TCM-2026-JL00892',
                                    style: TcmTypography.labelDataSmall(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 4.0),
                            decoration: BoxDecoration(
                              color: TcmColors.tertiary,
                              borderRadius:
                                  BorderRadius.circular(TcmSpacing.radiusFull),
                            ),
                            child: Text('官方存证',
                                style: TcmTypography.labelDataSmall(
                                    color: Colors.white)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14.0),
                      Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: TcmColors.surfaceContainerLow,
                          borderRadius:
                              BorderRadius.circular(TcmSpacing.radiusSm),
                        ),
                        child: Column(
                          children: [
                            _buildCertRow('药材品名', '吉林长白山鲜人参 (特级野山参)'),
                            _buildCertRow('批次编码', 'LOT-CBS-202608-89240'),
                            _buildCertRow('认证产地', '吉林抚松长白山西麓 GAP 示范基地'),
                            _buildCertRow('综合道地指数', '98.5分 (AAA级 特级道地)'),
                            _buildCertRow(
                                '国密哈希', '0x8f2b3e41...982c7a (SM3不可篡改)'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),

                // Lifecycle Steps Detailed Timeline
                Text('全程五大追溯节点档案', style: TcmTypography.headlineLgMobile()),
                const SizedBox(height: 10.0),

                _buildArchiveNode(
                  stage: '节点 01',
                  title: 'GAP 道地规范种植与采挖',
                  desc: '抚松长白山天然黑腐殖土林下种植 · 经北纬41°天然冷泉浇灌 · 人工精心带土采挖',
                  operator: '种植基地技术总监：张德贵 · 认证编号 GAP-JL-041',
                  time: '2026-09-08 09:30:15',
                  icon: Icons.eco_rounded,
                  accentColor: TcmColors.tertiary,
                ),
                const SizedBox(height: 10.0),

                _buildArchiveNode(
                  stage: '节点 02',
                  title: '绿色低温冷风循环初加工',
                  desc: '超声波净水微雾清洗泥沙 · 严格零二氧化硫熏蒸 · 15℃恒低温微风干燥控水',
                  operator: '初加工中心质控员：赵国富 · 纯正绿色无硫认证',
                  time: '2026-09-10 14:22:40',
                  icon: Icons.cleaning_services_rounded,
                  accentColor: TcmColors.secondary,
                ),
                const SizedBox(height: 10.0),

                _buildArchiveNode(
                  stage: '节点 03',
                  title: 'AS7341多光谱与OpenMV双模智检',
                  desc: 'AS7341 8通道近红外特征谱吻合度99.2% · 皂苷Rg1/Re比值1.42 · OpenMV外观珍珠点特征评分97.8',
                  operator: '药企数字化实验室高级工程师：钱雪梅',
                  time: '2026-09-12 10:15:00',
                  icon: Icons.biotech_rounded,
                  accentColor: TcmColors.primary,
                ),
                const SizedBox(height: 10.0),

                _buildArchiveNode(
                  stage: '节点 04',
                  title: '气调保鲜微正压恒温立体入库',
                  desc: '自动进入A区01号仓 · 温度3.8℃ · 相对湿度64.5% · 氮气96%低氧抑菌 · 连续监测正常',
                  operator: '仓储中控系统智能调度 · 舱室 A-01 (TCM-A892)',
                  time: '2026-09-14 16:45:10',
                  icon: Icons.inventory_2_rounded,
                  accentColor: TcmColors.tertiary,
                ),
                const SizedBox(height: 10.0),

                _buildArchiveNode(
                  stage: '节点 05',
                  title: '冷链密闭全流程数字追踪',
                  desc: '全程GPS地理位置上链 · 温湿度异常实时联锁报警已就绪 · 到货即刻一物一码验真',
                  operator: '专线冷链物流车 #JL-8821 · 驾驶员：刘建军',
                  time: '2026-09-16 08:00:00',
                  icon: Icons.local_shipping_rounded,
                  accentColor: TcmColors.primary,
                ),
                const SizedBox(height: 16.0),

                // Share / Download actions
                BouncingScaleTap(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('已生成完整追溯存证凭证，已存入系统相册及存证链！',
                            style: TcmTypography.bodyMd(color: Colors.white)),
                        backgroundColor: TcmColors.primary,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: Container(
                    height: 52.0,
                    decoration: BoxDecoration(
                      color: TcmColors.primary,
                      borderRadius:
                          BorderRadius.circular(TcmSpacing.radiusDefault),
                      boxShadow: [
                        BoxShadow(
                          color: TcmColors.primary.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        '保存并导出全流程存证凭证',
                        style: TcmTypography.bodyMd(color: Colors.white)
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCertRow(String label, String val) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TcmTypography.labelDataSmall()),
          Text(val,
              style: TcmTypography.bodyMd()
                  .copyWith(fontWeight: FontWeight.w600, fontSize: 13.5)),
        ],
      ),
    );
  }

  Widget _buildArchiveNode({
    required String stage,
    required String title,
    required String desc,
    required String operator,
    required String time,
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
                      color: accentColor.withOpacity(0.12),
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
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                decoration: BoxDecoration(
                  color: TcmColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(TcmSpacing.radiusFull),
                ),
                child: Text(stage, style: TcmTypography.labelDataSmall()),
              ),
            ],
          ),
          const SizedBox(height: 6.0),
          Text(desc, style: TcmTypography.bodyMd()),
          const SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(operator, style: TcmTypography.labelDataSmall()),
              Text(time, style: TcmTypography.labelDataSmall()),
            ],
          ),
        ],
      ),
    );
  }
}

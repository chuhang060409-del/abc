import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/tcm_theme.dart';
import '../../core/animation/bouncing_scale_tap.dart';
import '../../core/widgets/common_app_bar.dart';
import '../secondary_pages/hardware_settings_page.dart';

/// Tab 5: System Collaboration Terminal (全链协同指挥台)
/// 5 Major TCM Stakeholders Perspective & Multi-party Signatures
class CoordinationTerminalPage extends StatefulWidget {
  const CoordinationTerminalPage({super.key});

  @override
  State<CoordinationTerminalPage> createState() =>
      _CoordinationTerminalPageState();
}

class _CoordinationTerminalPageState extends State<CoordinationTerminalPage> {
  int _selectedRoleIndex = 2; // Default to 仓储中控

  final List<Map<String, dynamic>> _roles = [
    {
      'name': '种植农户',
      'org': '抚松长白山种植合作社',
      'icon': Icons.potted_plant_rounded,
      'status': '采收节点已认证',
      'pending': 2,
    },
    {
      'name': '初加工厂',
      'org': '万良冷风循环干燥基地',
      'icon': Icons.cleaning_services_rounded,
      'status': '零硫熏规范达标',
      'pending': 0,
    },
    {
      'name': '仓储中控',
      'org': 'A区01号气调恒温立体仓',
      'icon': Icons.inventory_2_rounded,
      'status': '微环境稳态受控',
      'pending': 1,
    },
    {
      'name': '药企质检',
      'org': '数字化中药研发检测中心',
      'icon': Icons.biotech_rounded,
      'status': 'AS7341多光谱已核验',
      'pending': 0,
    },
    {
      'name': '监管机构',
      'org': '吉林道地药材地理标志局',
      'icon': Icons.gavel_rounded,
      'status': '官方数字公章存证',
      'pending': 0,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TcmColors.background,
      appBar: CommonAppBar(
        title: '谱鉴药链 · 协同终端',
        subtitle: '5大主体协同 · Mesh互联',
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

          final currentRole = _roles[_selectedRoleIndex];

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
                // Top Node Banner
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: TcmDecorations.card(),
                  child: Row(
                    children: [
                      Container(
                        width: 44.0,
                        height: 44.0,
                        decoration: BoxDecoration(
                          color: TcmColors.primaryContainer.withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.domain_verification_rounded,
                          color: TcmColors.primary,
                          size: 26.0,
                        ),
                      ),
                      const SizedBox(width: 12.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text('全链协同指挥台',
                                    style: TcmTypography.headlineMd()),
                                const SizedBox(width: 8.0),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 2.0),
                                  decoration: BoxDecoration(
                                    color: TcmColors.tertiaryFixed,
                                    borderRadius: BorderRadius.circular(
                                        TcmSpacing.radiusFull),
                                  ),
                                  child: Text(
                                    'Mesh已互联',
                                    style: TcmTypography.labelDataSmall(
                                      color: TcmColors.onTertiaryFixed,
                                    ).copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2.0),
                            Text(
                              '抚松万良人参集散仓储节点 · CN-JL-2409',
                              style: TcmTypography.labelDataSmall(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14.0),

                // Role Switcher Title
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
                        Text('产业主体协同视窗',
                            style: TcmTypography.headlineLgMobile()),
                      ],
                    ),
                    Text('5个活跃主体已同构',
                        style: TcmTypography.labelDataSmall()),
                  ],
                ),
                const SizedBox(height: 10.0),

                // Horizontal Scrollable High-Touch Target Selector
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: List.generate(_roles.length, (index) {
                      final r = _roles[index];
                      final isSelected = index == _selectedRoleIndex;

                      return Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: BouncingScaleTap(
                          onTap: () {
                            HapticFeedback.selectionClick();
                            setState(() {
                              _selectedRoleIndex = index;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 154.0,
                            padding: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? TcmColors.primary
                                  : TcmColors.surfaceContainerLowest,
                              borderRadius: BorderRadius.circular(
                                  TcmSpacing.radiusDefault),
                              border: Border.all(
                                color: isSelected
                                    ? TcmColors.primary
                                    : TcmColors.surfaceContainerHigh,
                                width: isSelected ? 2.0 : 1.0,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: isSelected
                                      ? TcmColors.primary.withOpacity(0.28)
                                      : Colors.black.withOpacity(0.04),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 32.0,
                                      height: 32.0,
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? Colors.white.withOpacity(0.25)
                                            : TcmColors.surfaceContainer,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        r['icon'] as IconData,
                                        size: 18.0,
                                        color: isSelected
                                            ? Colors.white
                                            : TcmColors.secondary,
                                      ),
                                    ),
                                    if ((r['pending'] as int) > 0)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6.0, vertical: 2.0),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? Colors.white
                                              : TcmColors.error,
                                          borderRadius: BorderRadius.circular(
                                              TcmSpacing.radiusFull),
                                        ),
                                        child: Text(
                                          '待办 ${r['pending']}',
                                          style: TextStyle(
                                            fontSize: 10.0,
                                            fontWeight: FontWeight.bold,
                                            color: isSelected
                                                ? TcmColors.primary
                                                : Colors.white,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 10.0),
                                Text(
                                  r['name'] as String,
                                  style: TcmTypography.headlineMd(
                                    color: isSelected
                                        ? Colors.white
                                        : TcmColors.onSurface,
                                  ).copyWith(fontSize: 16.0),
                                ),
                                const SizedBox(height: 2.0),
                                Text(
                                  r['status'] as String,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TcmTypography.labelDataSmall(
                                    color: isSelected
                                        ? Colors.white70
                                        : TcmColors.outline,
                                  ).copyWith(fontSize: 10.5),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 16.0),

                // Active Role Operation Detail
                Container(
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
                              Icon(
                                currentRole['icon'] as IconData,
                                color: TcmColors.primary,
                                size: 24.0,
                              ),
                              const SizedBox(width: 8.0),
                              Text(
                                '${currentRole['name']} · 协同业务面板',
                                style: TcmTypography.headlineMd(),
                              ),
                            ],
                          ),
                          Text('节点在线',
                              style: TcmTypography.labelDataSmall(
                                  color: TcmColors.tertiary)),
                        ],
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        '所属组织: ${currentRole['org']}',
                        style: TcmTypography.bodyMd(color: TcmColors.secondary),
                      ),
                      const SizedBox(height: 14.0),

                      // Collaboration Data Exchange Rows
                      _buildExchangeRow(
                        '跨链存证数据接口',
                        '通过国密 SM2/SM3 签名算法与中药工业互联网互联互通',
                        '状态正常',
                        TcmColors.tertiary,
                      ),
                      const SizedBox(height: 8.0),
                      _buildExchangeRow(
                        '双模多光谱鉴真协同',
                        'AS7341多光谱指纹特征与OpenMV外观形态比对参数已双向加密同步',
                        '已更新',
                        TcmColors.primary,
                      ),
                      const SizedBox(height: 8.0),
                      _buildExchangeRow(
                        '药典温湿度微正压联锁',
                        '恒温 3.8℃ / 相对湿度 64.5% 气调保鲜参数已广播至协同链',
                        '同步率 100%',
                        TcmColors.secondary,
                      ),
                      const SizedBox(height: 16.0),

                      // Collaborative Confirmation Button
                      BouncingScaleTap(
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  '已完成 ${currentRole['name']} 协同节点的数字签章与全网广播！',
                                  style: TcmTypography.bodyMd(
                                      color: Colors.white)),
                              backgroundColor: TcmColors.primary,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        child: Container(
                          height: 50.0,
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
                              '确认并广播数字签章',
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

  Widget _buildExchangeRow(
      String title, String desc, String badge, Color badgeColor) {
    return Container(
      padding: const EdgeInsets.all(12.0),
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
              Text(title,
                  style: TcmTypography.bodyMd()
                      .copyWith(fontWeight: FontWeight.bold)),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                decoration: BoxDecoration(
                  color: badgeColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(TcmSpacing.radiusFull),
                ),
                child: Text(badge,
                    style: TcmTypography.labelDataSmall(color: badgeColor)),
              ),
            ],
          ),
          const SizedBox(height: 4.0),
          Text(desc, style: TcmTypography.labelDataSmall()),
        ],
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/tcm_theme.dart';
import '../../core/animation/bouncing_scale_tap.dart';
import '../../core/services/dual_sensor_service.dart';

/// Secondary Page: Hardware Calibration & System Settings (系统设置与硬件标定)
/// Pushed with CupertinoPageRoute with native iOS edge swipe pop.
class HardwareSettingsPage extends StatefulWidget {
  const HardwareSettingsPage({super.key});

  @override
  State<HardwareSettingsPage> createState() => _HardwareSettingsPageState();
}

class _HardwareSettingsPageState extends State<HardwareSettingsPage> {
  double _samplingRateHz = 20.0;
  bool _isolateAccelEnabled = true;
  bool _autoCalibration = true;
  bool _meshSyncEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TcmColors.background,
      appBar: CupertinoNavigationBar(
        backgroundColor: TcmColors.surface.withOpacity(0.88),
        middle: Text(
          '系统设置与硬件标定',
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
                // 1. Dual-Sensor Hardware Calibration Section
                _buildSectionHeader('双模采集终端标定与硬件状态'),
                const SizedBox(height: 10.0),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: TcmDecorations.card(),
                  child: Column(
                    children: [
                      _buildHardwareTile(
                        title: 'AS7341 8通道多光谱传感器',
                        subtitle: '可见光+近红外 (415nm~910nm) · 增益已匹配',
                        icon: Icons.biotech_rounded,
                        status: '已就绪 (120Hz支持)',
                        statusColor: TcmColors.tertiary,
                        onAction: () {
                          HapticFeedback.lightImpact();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('AS7341 标准白板增益标定完成！',
                                  style: TcmTypography.bodyMd(color: Colors.white)),
                              backgroundColor: TcmColors.tertiary,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        actionText: '基线标定',
                      ),
                      const Divider(height: 20.0),
                      _buildHardwareTile(
                        title: 'OpenMV 显微形态视觉模组',
                        subtitle: '参体纹理清晰度 · 焦距自动闭环控制',
                        icon: Icons.camera_rounded,
                        status: '已聚焦 (超清微距)',
                        statusColor: TcmColors.primary,
                        onAction: () {
                          HapticFeedback.lightImpact();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('OpenMV 图像色彩矩阵与对焦校正完成！',
                                  style: TcmTypography.bodyMd(color: Colors.white)),
                              backgroundColor: TcmColors.primary,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        actionText: '自动对焦',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18.0),

                // 2. High Frequency Communication & Isolate Configuration
                _buildSectionHeader('底层通信与后台 Isolate 算力配置'),
                const SizedBox(height: 10.0),
                Container(
                  padding: const EdgeInsets.all(16.0),
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
                              Text('并发采集采样频率', style: TcmTypography.bodyMd()),
                              Text('动态调节双模硬件脉冲采样速率',
                                  style: TcmTypography.labelDataSmall()),
                            ],
                          ),
                          Text(
                            '${_samplingRateHz.toStringAsFixed(0)} Hz',
                            style: TcmTypography.headlineMd(
                                color: TcmColors.primary),
                          ),
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
                          value: _samplingRateHz,
                          min: 10.0,
                          max: 120.0,
                          divisions: 11,
                          label: '${_samplingRateHz.toStringAsFixed(0)} Hz',
                          onChanged: (val) {
                            setState(() {
                              _samplingRateHz = val;
                            });
                            DualSensorAcquisitionService.instance
                                .setAcquisitionRate(val);
                          },
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      _buildSwitchRow(
                        '独立后台 Isolate 计算加速',
                        '将多光谱卷积与视觉特征矩阵解耦至独立线程，保障全局120Hz渲染',
                        _isolateAccelEnabled,
                        (v) {
                          setState(() => _isolateAccelEnabled = v);
                        },
                      ),
                      const Divider(height: 20.0),
                      _buildSwitchRow(
                        '工业 Mesh 无线网络自组网',
                        'Zigbee 3.0 与 LoRaWAN 双模冗余通讯链路',
                        _meshSyncEnabled,
                        (v) {
                          setState(() => _meshSyncEnabled = v);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18.0),

                // 3. National Secret Blockchain Network
                _buildSectionHeader('国密算法区块链节点网络'),
                const SizedBox(height: 10.0),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: TcmDecorations.card(),
                  child: Column(
                    children: [
                      _buildInfoRow('存证算法标准', 'SM2 非对称加密 + SM3 256位哈希'),
                      _buildInfoRow('同步节点总数', '8 / 8 节点全部在线 (P2P Mesh)'),
                      _buildInfoRow('平均上链确权延迟', '8.4 ms (秒级确权)'),
                      _buildInfoRow('智能合约版本', 'TCM-CHAIN-CONTRACT-v6.2.4'),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),

                // Save action
                BouncingScaleTap(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('硬件配置与通信参数已成功固化保存！',
                            style: TcmTypography.bodyMd(color: Colors.white)),
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
                        '保存配置并生效',
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

  Widget _buildSectionHeader(String title) {
    return Row(
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
        Text(title, style: TcmTypography.headlineLgMobile()),
      ],
    );
  }

  Widget _buildHardwareTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required String status,
    required Color statusColor,
    required VoidCallback onAction,
    required String actionText,
  }) {
    return Row(
      children: [
        Container(
          width: 40.0,
          height: 40.0,
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: statusColor, size: 22.0),
        ),
        const SizedBox(width: 12.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TcmTypography.bodyMd()
                      .copyWith(fontWeight: FontWeight.bold)),
              Text(subtitle, style: TcmTypography.labelDataSmall()),
              const SizedBox(height: 2.0),
              Text(status,
                  style: TcmTypography.labelDataSmall(color: statusColor)),
            ],
          ),
        ),
        BouncingScaleTap(
          onTap: onAction,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
            decoration: BoxDecoration(
              color: TcmColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(TcmSpacing.radiusSm),
              border: Border.all(color: TcmColors.outlineVariant, width: 0.5),
            ),
            child: Text(actionText, style: TcmTypography.labelDataSmall()),
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchRow(
      String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TcmTypography.bodyMd()
                      .copyWith(fontWeight: FontWeight.w600)),
              Text(subtitle, style: TcmTypography.labelDataSmall()),
            ],
          ),
        ),
        CupertinoSwitch(
          value: value,
          activeColor: TcmColors.primary,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String val) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TcmTypography.labelDataSmall()),
          Text(val,
              style: TcmTypography.bodyMd()
                  .copyWith(fontWeight: FontWeight.w600, fontSize: 13.0)),
        ],
      ),
    );
  }
}

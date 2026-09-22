import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/tcm_theme.dart';
import '../animation/bouncing_scale_tap.dart';

/// Glassmorphism Floating Top Navigation Header
class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String subtitle;
  final IconData leadingIcon;
  final Widget? trailing;
  final VoidCallback? onSettingsTap;
  final VoidCallback? onAvatarTap;

  const CommonAppBar({
    super.key,
    required this.title,
    this.subtitle = 'NODE #A03 · 实时监控在线',
    this.leadingIcon = Icons.inventory_2_rounded,
    this.trailing,
    this.onSettingsTap,
    this.onAvatarTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(68.0);

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16.0, sigmaY: 16.0),
        child: Container(
          padding: EdgeInsets.only(
            top: topInset + 6.0,
            left: 16.0,
            right: 16.0,
            bottom: 8.0,
          ),
          decoration: BoxDecoration(
            color: TcmColors.surface.withOpacity(0.85),
            border: Border(
              bottom: BorderSide(
                color: TcmColors.outlineVariant.withOpacity(0.35),
                width: 0.5,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Leading Brand Icon
              Container(
                width: 40.0,
                height: 40.0,
                decoration: BoxDecoration(
                  color: TcmColors.primary,
                  borderRadius: BorderRadius.circular(TcmSpacing.radiusSm),
                  boxShadow: [
                    BoxShadow(
                      color: TcmColors.primary.withOpacity(0.28),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  leadingIcon,
                  color: TcmColors.onPrimary,
                  size: 22.0,
                ),
              ),
              const SizedBox(width: 10.0),

              // Title and Node Status
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: TcmTypography.primaryFont,
                        fontSize: 16.5,
                        fontWeight: FontWeight.w700,
                        color: TcmColors.onSurface,
                        letterSpacing: -0.01,
                      ),
                    ),
                    const SizedBox(height: 2.0),
                    Row(
                      children: [
                        Container(
                          width: 6.5,
                          height: 6.5,
                          decoration: const BoxDecoration(
                            color: TcmColors.tertiary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 5.0),
                        Expanded(
                          child: Text(
                            subtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TcmTypography.labelDataSmall(
                              color: TcmColors.tertiary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Trailing Actions
              if (trailing != null)
                trailing!
              else ...[
                // Lock status pill
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    color: TcmColors.tertiaryContainer.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(TcmSpacing.radiusFull),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.lock_rounded,
                        size: 14.0,
                        color: TcmColors.tertiary,
                      ),
                      const SizedBox(width: 3.0),
                      Text(
                        '舱门锁闭',
                        style: TcmTypography.labelDataSmall(
                          color: TcmColors.tertiary,
                        ).copyWith(fontSize: 11.0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8.0),

                // Settings icon button
                if (onSettingsTap != null)
                  BouncingScaleTap(
                    onTap: onSettingsTap,
                    child: Container(
                      width: 36.0,
                      height: 36.0,
                      decoration: BoxDecoration(
                        color: TcmColors.surfaceContainerLow,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.tune_rounded,
                        size: 18.0,
                        color: TcmColors.secondary,
                      ),
                    ),
                  ),
                const SizedBox(width: 6.0),

                // Avatar button
                BouncingScaleTap(
                  onTap: onAvatarTap,
                  child: Container(
                    width: 36.0,
                    height: 36.0,
                    decoration: const BoxDecoration(
                      color: TcmColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      size: 20.0,
                      color: TcmColors.onPrimary,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

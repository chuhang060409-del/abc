import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/tcm_theme.dart';
import '../animation/bouncing_scale_tap.dart';

class NavTabItem {
  final IconData icon;
  final String label;
  final String pathKey;

  const NavTabItem({
    required this.icon,
    required this.label,
    required this.pathKey,
  });
}

/// Floating Liquid Glassmorphism Bottom Navigation Bar
/// Built with ClipRRect + BackdropFilter(sigma: 18.0, 18.0),
/// 0.5px subtle glowing white border, and ultra-low opacity gradient.
/// Floats via Stack above the page content.
/// Features bidirectional animated binding with PageView and horizontal drag damping gestures.
class LiquidGlassBottomNav extends StatefulWidget {
  final PageController pageController;
  final int currentIndex;
  final ValueChanged<int> onTabSelected;
  final List<NavTabItem> items;

  const LiquidGlassBottomNav({
    super.key,
    required this.pageController,
    required this.currentIndex,
    required this.onTabSelected,
    required this.items,
  });

  @override
  State<LiquidGlassBottomNav> createState() => _LiquidGlassBottomNavState();
}

class _LiquidGlassBottomNavState extends State<LiquidGlassBottomNav> {
  double _dragAccumulator = 0.0;

  void _onHorizontalDragUpdate(DragUpdateDetails details, double itemWidth) {
    _dragAccumulator += details.primaryDelta ?? 0.0;
    // Damping resistance: require threshold to flip tabs
    if (_dragAccumulator.abs() > itemWidth * 0.45) {
      if (_dragAccumulator < 0 && widget.currentIndex < widget.items.length - 1) {
        // Dragged left -> Next tab
        HapticFeedback.selectionClick();
        widget.onTabSelected(widget.currentIndex + 1);
        _dragAccumulator = 0.0;
      } else if (_dragAccumulator > 0 && widget.currentIndex > 0) {
        // Dragged right -> Previous tab
        HapticFeedback.selectionClick();
        widget.onTabSelected(widget.currentIndex - 1);
        _dragAccumulator = 0.0;
      }
    }
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    _dragAccumulator = 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bottomInset = mediaQuery.padding.bottom;
    final screenWidth = mediaQuery.size.width;

    // Responsive nav bar width adapting to mobile, tablet, foldables
    final navWidth = screenWidth > 600 ? 560.0 : screenWidth - 32.0;

    return Positioned(
      left: (screenWidth - navWidth) / 2.0,
      right: (screenWidth - navWidth) / 2.0,
      bottom: bottomInset > 0 ? bottomInset + 8.0 : 20.0,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final totalWidth = constraints.maxWidth;
          final tabCount = widget.items.length;
          final itemWidth = totalWidth / tabCount;

          return GestureDetector(
            onHorizontalDragUpdate: (details) =>
                _onHorizontalDragUpdate(details, itemWidth),
            onHorizontalDragEnd: _onHorizontalDragEnd,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(TcmSpacing.radiusLg),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 18.0, sigmaY: 18.0),
                child: Container(
                  height: 68.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(TcmSpacing.radiusLg),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.88),
                        Colors.white.withOpacity(0.72),
                      ],
                    ),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.55),
                      width: 0.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.07),
                        blurRadius: 28,
                        offset: const Offset(0, 10),
                      ),
                      BoxShadow(
                        color: TcmColors.primary.withOpacity(0.08),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Bidirectionally Bound Fluid Animated Capsule Indicator
                      AnimatedBuilder(
                        animation: widget.pageController,
                        builder: (context, child) {
                          double page = widget.currentIndex.toDouble();
                          if (widget.pageController.hasClients &&
                              widget.pageController.position.hasContentDimensions) {
                            page = widget.pageController.page ?? page;
                          }

                          // Calculate indicator position
                          final leftOffset = page * itemWidth + 6.0;
                          final pillWidth = itemWidth - 12.0;

                          return Positioned(
                            left: leftOffset,
                            top: 8.0,
                            bottom: 8.0,
                            width: pillWidth > 0 ? pillWidth : 48.0,
                            child: Container(
                              decoration: BoxDecoration(
                                color: TcmColors.primary,
                                borderRadius:
                                    BorderRadius.circular(TcmSpacing.radiusDefault),
                                boxShadow: [
                                  BoxShadow(
                                    color: TcmColors.primary.withOpacity(0.35),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                      // Navigation Tab Items Row
                      Row(
                        children: List.generate(widget.items.length, (index) {
                          final item = widget.items[index];

                          return Expanded(
                            child: AnimatedBuilder(
                              animation: widget.pageController,
                              builder: (context, child) {
                                double page = widget.currentIndex.toDouble();
                                if (widget.pageController.hasClients &&
                                    widget.pageController.position.hasContentDimensions) {
                                  page = widget.pageController.page ?? page;
                                }

                                final distance = (page - index).abs();
                                final activeWeight = (1.0 - distance).clamp(0.0, 1.0);
                                final isCurrentlyActive = activeWeight > 0.5;

                                final textColor = Color.lerp(
                                  TcmColors.onSurfaceVariant,
                                  TcmColors.onPrimary,
                                  activeWeight,
                                )!;

                                final iconColor = Color.lerp(
                                  TcmColors.secondary,
                                  TcmColors.onPrimary,
                                  activeWeight,
                                )!;

                                return BouncingScaleTap(
                                  scaleFactor: 0.92,
                                  onTap: () {
                                    HapticFeedback.selectionClick();
                                    widget.onTabSelected(index);
                                  },
                                  child: Container(
                                    height: 68.0,
                                    color: Colors.transparent,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          item.icon,
                                          size: 22.0,
                                          color: iconColor,
                                        ),
                                        const SizedBox(height: 3.0),
                                        Text(
                                          item.label,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontFamily: TcmTypography.primaryFont,
                                            fontSize: 11.5,
                                            fontWeight: isCurrentlyActive
                                                ? FontWeight.w700
                                                : FontWeight.w500,
                                            color: textColor,
                                            height: 1.1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

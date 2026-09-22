import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/theme/tcm_theme.dart';
import 'core/navigation/liquid_glass_bottom_nav.dart';
import 'features/warehouse_control/warehouse_control_page.dart';
import 'features/origin_grade/origin_grade_page.dart';
import 'features/blockchain_trace/blockchain_trace_page.dart';
import 'features/risk_alerts/risk_alerts_page.dart';
import 'features/coordination_terminal/coordination_terminal_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Set system UI overlay style for ultra-clean industrial precision look
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const TcmPrecisionApp());
}

class TcmPrecisionApp extends StatelessWidget {
  const TcmPrecisionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '慧识药藏 · 药材恒温仓储与双模道地鉴别系统',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: TcmColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: TcmColors.primary,
          primary: TcmColors.primary,
          surface: TcmColors.surface,
          surfaceContainer: TcmColors.surfaceContainer,
        ),
        fontFamily: TcmTypography.primaryFont,
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      home: const MainScaffold(),
    );
  }
}

/// Main Application Shell hosting the bidirectional bound PageView
/// and the floating Liquid Glassmorphic Bottom Navigation Bar.
class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  late final PageController _pageController;
  int _currentIndex = 0;

  final List<NavTabItem> _navItems = const [
    NavTabItem(
      icon: Icons.space_dashboard_rounded,
      label: '系统状态',
      pathKey: 'system-status',
    ),
    NavTabItem(
      icon: Icons.science_rounded,
      label: '产地质检',
      pathKey: 'origin-inspection',
    ),
    NavTabItem(
      icon: Icons.qr_code_scanner_rounded,
      label: '区块溯源',
      pathKey: 'blockchain-trace',
    ),
    NavTabItem(
      icon: Icons.warning_amber_rounded,
      label: '风险预警',
      pathKey: 'risk-alert',
    ),
    NavTabItem(
      icon: Icons.hub_rounded,
      label: '协同终端',
      pathKey: 'coordination-terminal',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabSelected(int index) {
    if (_currentIndex == index) return;
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeInOutCubic,
    );
  }

  void _onPageChanged(int index) {
    if (_currentIndex != index) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TcmColors.background,
      body: Stack(
        children: [
          // 1. Full-screen PageView with iOS Bouncing Physics
          PageView(
            controller: _pageController,
            physics: const BouncingScrollPhysics(),
            onPageChanged: _onPageChanged,
            children: const [
              WarehouseControlPage(),
              OriginGradePage(),
              BlockchainTracePage(),
              RiskAlertsPage(),
              CoordinationTerminalPage(),
            ],
          ),

          // 2. Floating Liquid Glassmorphism Bottom Navigation Bar
          // Outside standard document flow, Stack positioned above content
          LiquidGlassBottomNav(
            pageController: _pageController,
            currentIndex: _currentIndex,
            onTabSelected: _onTabSelected,
            items: _navItems,
          ),
        ],
      ),
    );
  }
}

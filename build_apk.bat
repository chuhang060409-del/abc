@echo off
chcp 65001 >nul
echo ========================================================
echo   慧识药藏 · 药材恒温仓储系统 Android APK 自动打包脚本
echo ========================================================
echo.

where flutter >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [提示] 检测到当前系统 PATH 中未找到 Flutter SDK。
    echo.
    echo 推荐安装方式（二选一）：
    echo 1. 使用 Scoop 一键安装：
    echo    scoop bucket add extras
    echo    scoop install flutter
    echo.
    echo 2. 官方下载解压配置环境变量：
    echo    https://docs.flutter.dev/get-started/install/windows
    echo.
    echo 配置好 Flutter 并安装 Android Studio/SDK 后，直接再次运行本脚本即可！
    pause
    exit /b 1
)

echo [1/3] 正在拉取 Flutter 依赖包 (flutter pub get)...
call flutter pub get
if %ERRORLEVEL% NEQ 0 (
    echo [错误] 依赖拉取失败，请检查网络或 Flutter 配置。
    pause
    exit /b 1
)

echo.
echo [2/3] 正在编译生成 Release 版本的 Android APK (flutter build apk --release)...
call flutter build apk --release
if %ERRORLEVEL% NEQ 0 (
    echo [错误] APK 编译失败。
    pause
    exit /b 1
)

echo.
echo [3/3] 打包完成！
echo APK 安装包生成路径:
echo   %CD%\build\app\outputs\flutter-apk\app-release.apk
echo.
echo ========================================================
pause

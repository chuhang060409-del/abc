@echo off
chcp 65001 >nul
title 推送代码到 GitHub
cd /d "%~dp0"

echo ========================================================
echo   正在推送代码到 GitHub 仓库: chuhang060409-del/abc
echo ========================================================
echo.
echo 提示：稍后系统会自动弹出浏览器进行 GitHub 授权确认。
echo 确认授权后，云端将自动开始为您编译 APK 安装包！
echo.

git push -u origin main

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================================
    echo   [成功] 代码推送成功！
    echo   云端 APK 打包流水线已自动触发。
    echo   请在浏览器中打开以下链接下载 APK：
    echo   https://github.com/chuhang060409-del/abc/actions
    echo ========================================================
) else (
    echo.
    echo [提示] 推送未完成，请确认网络连接与 GitHub 授权。
)

echo.
pause

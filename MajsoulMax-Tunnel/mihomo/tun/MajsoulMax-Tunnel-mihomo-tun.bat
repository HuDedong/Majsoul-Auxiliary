@echo off
chcp 936 >nul
cd /d "%~dp0"

REM 后台启动 mihomo
start /b .\mihomo-v1.19.24.exe -d . -f config.yaml

echo mihomo is running in background.
echo mihomo 已在后台运行.
echo.
echo Press any key three times to stop mihomo...
echo 请按任意键三次，将停止 mihomo...
echo.

pause >nul
echo [1/3] Press any key...
echo [1/3] 按任意键...
pause >nul
echo [2/3] Press any key...
echo [2/3] 按任意键...
pause >nul
echo [3/3] Press any key...
echo [3/3] 按任意键...
pause >nul

REM 结束 mihomo 进程
taskkill /f /im mihomo-v1.19.24.exe >nul 2>&1

echo mihomo stopped.
echo mihomo 已停止.
pause
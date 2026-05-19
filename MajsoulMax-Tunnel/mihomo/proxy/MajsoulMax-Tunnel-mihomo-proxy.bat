@echo off
chcp 936 >nul
cd /d "%~dp0"

REM 开启系统代理
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 1 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyServer /t REG_SZ /d "127.0.0.1:12345" /f >nul
Rundll32.exe InetCpl.cpl,ClearMyTracksByProcess 8 >nul

REM 后台启动 mihomo
start /b .\mihomo-v1.19.24.exe -d . -f config.yaml

echo mihomo is running in background.
echo mihomo 已在后台运行.
echo.
echo Press any key three times to disable proxy and stop mihomo...
echo 请按任意键三次，将关闭代理并停止 mihomo...
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

REM 关闭系统代理
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 0 /f >nul
Rundll32.exe InetCpl.cpl,ClearMyTracksByProcess 8 >nul

echo System proxy disabled.
echo 系统代理已关闭.
pause
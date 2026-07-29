@echo off
setlocal enabledelayedexpansion
title PC Network Tweak by Fear Studio
color 0A

:: ---------------------------------------------
:: Admin Check (auto-elevate like the power plan script)
:: ---------------------------------------------
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting Administrator access...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

cls
echo ==========================================
echo       PC Network Tweak by Fear Studio
echo ==========================================
echo.

echo Resetting Network Stack...
netsh int ip reset >nul
netsh winsock reset >nul
echo Done. (This part only fully applies after a restart.)
echo.

echo Flushing DNS Cache...
ipconfig /flushdns >nul
echo.

echo Applying TCP Performance Tweaks...
:: Enable Receive Side Scaling
netsh int tcp set global rss=enabled >nul
:: Disable TCP Heuristics
netsh int tcp set heuristics disabled >nul
:: Enable TCP Fast Open
netsh int tcp set global fastopen=enabled >nul
:: Disable TCP Timestamps
netsh int tcp set global timestamps=disabled >nul
:: Set CTCP Congestion Provider
netsh int tcp set supplemental template=internet congestionprovider=ctcp >nul
:: Balanced TCP Autotuning
netsh int tcp set global autotuninglevel=normal >nul
:: Disable ECN
netsh int tcp set global ecncapability=disabled >nul
echo Done.
echo.

echo Optimizing Windows Gaming Network Settings...
:: Disable Network Throttling
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" ^
 /v NetworkThrottlingIndex /t REG_DWORD /d 4294967295 /f >nul
:: Improve System Responsiveness
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" ^
 /v SystemResponsiveness /t REG_DWORD /d 0 /f >nul
:: DNS Cache Optimization
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" ^
 /v MaxCacheTtl /t REG_DWORD /d 86400 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" ^
 /v MaxNegativeCacheTtl /t REG_DWORD /d 0 /f >nul
echo Done.
echo.

echo Applying Low Latency TCP ACK Tweaks (Nagle disable)...
:: FIXED: registry query paths are a single token (no spaces),
:: so we use tokens=1 and skip the 2 header lines reg query prints.
set "IFACE_COUNT=0"
for /f "skip=2 tokens=1" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" 2^>nul') do (
    if not "%%a"=="" (
        reg add "%%a" /v TcpAckFrequency /t REG_DWORD /d 1 /f >nul 2>&1
        if !errorlevel! equ 0 (
            reg add "%%a" /v TCPNoDelay /t REG_DWORD /d 1 /f >nul 2>&1
            set /a IFACE_COUNT+=1
        )
    )
)

if !IFACE_COUNT! gtr 0 (
    echo Applied to !IFACE_COUNT! network interface^(s^).
) else (
    echo WARNING: No interfaces were updated. This can happen if the
    echo Tcpip Interfaces registry key is empty or access was denied.
    echo Everything else in this script still applied successfully.
)
echo.

echo Optimizing Gaming Priority...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" ^
 /v "GPU Priority" /t REG_DWORD /d 8 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" ^
 /v "Priority" /t REG_DWORD /d 6 /f >nul
echo Done.
echo.

echo ==========================================
echo   PC Network Tweak Applied Successfully
echo ==========================================
echo.
echo Restart your PC for all changes to fully apply.
echo.
pause

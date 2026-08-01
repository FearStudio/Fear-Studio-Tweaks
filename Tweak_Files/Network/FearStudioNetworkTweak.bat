@echo off
setlocal enabledelayedexpansion
title PC Network Tweak - Fear Studio
color 0A

:: ---------------------------------------------
:: Admin Check
:: ---------------------------------------------
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting Administrator access...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:menu
cls
echo ==========================================
echo       PC Network Tweak - Fear Studio
echo ==========================================
echo.
echo  [1] Apply Tweak  - Optimize Network/Gaming Settings
echo  [2] Revert Tweak - Restore Windows Defaults
echo  [3] Exit
echo.
set "choice="
set /p choice="Select an option (1-3): "

if "%choice%"=="1" goto apply
if "%choice%"=="2" goto revert
if "%choice%"=="3" exit /b
echo.
echo Invalid selection. Please choose 1, 2, or 3.
timeout /t 2 >nul
goto menu

:: ============================================================
:: APPLY
:: ============================================================
:apply
cls
echo ==========================================
echo       PC Network Tweak - Fear Studio
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
netsh int tcp set global rss=enabled >nul
netsh int tcp set heuristics disabled >nul
netsh int tcp set global fastopen=enabled >nul
netsh int tcp set global timestamps=disabled >nul
netsh int tcp set supplemental template=internet congestionprovider=ctcp >nul
netsh int tcp set global autotuninglevel=normal >nul
netsh int tcp set global ecncapability=disabled >nul
echo Done.
echo.

echo Optimizing Windows Gaming Network Settings...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" ^
 /v NetworkThrottlingIndex /t REG_DWORD /d 4294967295 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" ^
 /v SystemResponsiveness /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" ^
 /v MaxCacheTtl /t REG_DWORD /d 86400 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" ^
 /v MaxNegativeCacheTtl /t REG_DWORD /d 0 /f >nul
echo Done.
echo.

echo Applying Low Latency TCP ACK Tweaks (Nagle disable)...
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
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" ^
 /v "Scheduling Category" /t REG_SZ /d "High" /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" ^
 /v "SFIO Priority" /t REG_SZ /d "High" /f >nul
echo Done.
echo.

echo ==========================================
echo   PC Network Tweak Applied Successfully
echo ==========================================
echo.
echo Restart your PC for all changes to fully apply.
echo.
pause
exit /b

:: ============================================================
:: REVERT
:: ============================================================
:revert
cls
echo ==========================================
echo       PC Network Tweak - Fear Studio
echo ==========================================
echo.

echo Restoring TCP Settings to Windows Defaults...
netsh int tcp set global rss=default >nul
netsh int tcp set heuristics default >nul
netsh int tcp set global fastopen=enabled >nul
netsh int tcp set global timestamps=default >nul
netsh int tcp set supplemental template=internet congestionprovider=cubic >nul
netsh int tcp set global autotuninglevel=normal >nul
netsh int tcp set global ecncapability=default >nul
echo Done.
echo.

echo Restoring Windows Gaming Network Settings...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" ^
 /v NetworkThrottlingIndex /t REG_DWORD /d 10 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" ^
 /v SystemResponsiveness /t REG_DWORD /d 20 /f >nul
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" ^
 /v MaxCacheTtl /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" ^
 /v MaxNegativeCacheTtl /f >nul 2>&1
echo Done.
echo.

echo Removing Low Latency TCP ACK Tweaks (restoring Nagle)...
set "IFACE_COUNT=0"
for /f "skip=2 tokens=1" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" 2^>nul') do (
    if not "%%a"=="" (
        reg delete "%%a" /v TcpAckFrequency /f >nul 2>&1
        reg delete "%%a" /v TCPNoDelay /f >nul 2>&1
        set /a IFACE_COUNT+=1
    )
)
echo Checked !IFACE_COUNT! network interface^(s^).
echo.

echo Restoring Gaming Priority defaults...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" ^
 /v "GPU Priority" /t REG_DWORD /d 8 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" ^
 /v "Priority" /t REG_DWORD /d 6 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" ^
 /v "Scheduling Category" /t REG_SZ /d "Medium" /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" ^
 /v "SFIO Priority" /t REG_SZ /d "Normal" /f >nul
echo Done.
echo.

echo ==========================================
echo   PC Network Tweak Reverted Successfully
echo ==========================================
echo.
echo Restart your PC for all changes to fully apply.
echo.
pause
exit /b
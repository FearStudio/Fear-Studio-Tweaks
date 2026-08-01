@echo off
setlocal enabledelayedexpansion
title Delivery Optimization Disable - Fear Studio
color 0A

:: ============================================================
:: Disable/Enable Delivery Optimization (Windows Update P2P sharing)
:: Must be run as Administrator
:: ============================================================

net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Requesting Administrator access...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:menu
cls
echo ==========================================
echo   Delivery Optimization - Fear Studio
echo ==========================================
echo.
echo  [1] Apply Tweak  - Disable Delivery Optimization
echo  [2] Revert Tweak - Enable Delivery Optimization
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

:apply
cls
echo ==========================================
echo   Delivery Optimization - Fear Studio
echo ==========================================
echo.
echo Disabling Delivery Optimization...
echo.

reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" ^
 /v DODownloadMode /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" ^
 /v DODownloadMode /t REG_DWORD /d 0 /f >nul

echo Stopping DoSvc service...
net stop DoSvc >nul 2>&1

echo Setting DoSvc service to disabled...
sc config DoSvc start= disabled >nul

echo.
echo ==========================================
echo Delivery Optimization has been disabled.
echo   - DODownloadMode set to 0 (HTTP only)
echo   - DoSvc service stopped and set to Disabled
echo ==========================================
echo.
pause
exit /b

:revert
cls
echo ==========================================
echo   Delivery Optimization - Fear Studio
echo ==========================================
echo.
echo Re-enabling Delivery Optimization...
echo.

reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" ^
 /v DODownloadMode /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" ^
 /v DODownloadMode /f >nul 2>&1

echo Restoring DoSvc service to default startup...
sc config DoSvc start= delayed-auto >nul

echo Starting DoSvc service...
net start DoSvc >nul 2>&1

echo.
echo ==========================================
echo Delivery Optimization has been re-enabled.
echo   - DODownloadMode registry overrides removed
echo   - DoSvc service restored and started
echo ==========================================
echo.
pause
exit /b
@echo off
setlocal enabledelayedexpansion
title Background Apps Disable - Fear Studio
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
echo     Background Apps Disable by Fear Studio
echo ==========================================
echo.
echo  [1] Apply Tweak  - Disable Background Apps
echo  [2] Revert Tweak - Enable Background Apps
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
echo     Background Apps Disable by Fear Studio
echo ==========================================
echo.
echo Disabling Microsoft Store Background Apps...
echo.

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" ^
 /v GlobalUserDisabled /t REG_DWORD /d 1 /f >nul

if %errorlevel%==0 (
    echo Background apps disabled successfully.
) else (
    echo Failed to apply tweak.
)

echo.
echo ==========================================
echo       Tweak Applied Successfully
echo ==========================================
echo.
echo Sign out or restart Windows Explorer
echo for all changes to fully apply.
echo.
pause
exit /b

:revert
cls
echo ==========================================
echo     Background Apps Disable by Fear Studio
echo ==========================================
echo.
echo Re-enabling Microsoft Store Background Apps...
echo.

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" ^
 /v GlobalUserDisabled /t REG_DWORD /d 0 /f >nul

if %errorlevel%==0 (
    echo Background apps re-enabled successfully.
) else (
    echo Failed to revert tweak.
)

echo.
echo ==========================================
echo       Tweak Reverted Successfully
echo ==========================================
echo.
echo Sign out or restart Windows Explorer
echo for all changes to fully apply.
echo.
pause
exit /b
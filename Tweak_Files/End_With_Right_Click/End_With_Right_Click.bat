@echo off
setlocal enabledelayedexpansion
title End Task With Right Click - Fear Studio
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
echo   End Task With Right Click - Fear Studio
echo ==========================================
echo.
echo  [1] Apply Tweak  - Enable End Task on Right Click
echo  [2] Revert Tweak - Disable End Task on Right Click
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
echo   End Task With Right Click - Fear Studio
echo ==========================================
echo.
echo Enabling End Task option...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarDeveloperSettings" ^
 /v TaskbarEndTask /t REG_DWORD /d 1 /f >nul
if %errorlevel% neq 0 (
    echo Failed to apply the tweak.
    pause
    exit /b
)

echo Restarting Windows Explorer...
taskkill /f /im explorer.exe >nul 2>&1
timeout /t 2 >nul
start explorer.exe

echo.
echo ==========================================
echo      Tweak Applied Successfully
echo ==========================================
echo.
echo The End Task option is now enabled.
echo No system restart required.
echo.
echo NOTE: This tweak requires Windows 11 version 23H2 or newer.
echo If it still doesn't show up, check your Windows build number.
echo.
pause
exit /b

:revert
cls
echo ==========================================
echo   End Task With Right Click - Fear Studio
echo ==========================================
echo.
echo Disabling End Task option...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarDeveloperSettings" ^
 /v TaskbarEndTask /t REG_DWORD /d 0 /f >nul
if %errorlevel% neq 0 (
    echo Failed to revert the tweak.
    pause
    exit /b
)

echo Restarting Windows Explorer...
taskkill /f /im explorer.exe >nul 2>&1
timeout /t 2 >nul
start explorer.exe

echo.
echo ==========================================
echo      Tweak Reverted Successfully
echo ==========================================
echo.
echo The End Task option is now disabled.
echo No system restart required.
echo.
pause
exit /b
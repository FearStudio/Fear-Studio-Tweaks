@echo off
setlocal enabledelayedexpansion
title Location Tracking - Fear Studio
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

:MENU
cls
echo ==========================================
echo      Location Tracking by Fear Studio
echo ==========================================
echo.
echo [1] Disable Location Tracking
echo [2] Restore Default Settings
echo [3] Exit
echo.
echo ==========================================
echo.

choice /c 123 /n /m "Select an option: "

if errorlevel 3 goto EXIT
if errorlevel 2 goto RESTORE
if errorlevel 1 goto DISABLE


:DISABLE
cls
echo ==========================================
echo     Disabling Location Tracking...
echo ==========================================
echo.

:: Disable Location Service
echo Disabling Location Service...
sc config lfsvc start= disabled >nul 2>&1
sc stop lfsvc >nul 2>&1


:: Block Location Access
echo Blocking Location Access...
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" ^
 /v Value /t REG_SZ /d Deny /f >nul


:: Disable Sensor Permission
echo Disabling Sensor Location Permission...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" ^
 /v SensorPermissionState /t REG_DWORD /d 0 /f >nul


:: Disable Maps Auto Updates
echo Disabling Maps Auto Updates...
reg add "HKLM\SYSTEM\Maps" ^
 /v AutoUpdateEnabled /t REG_DWORD /d 0 /f >nul


echo.
echo ==========================================
echo       Location Tracking Disabled
echo ==========================================
echo.
pause
goto MENU



:RESTORE
cls
echo ==========================================
echo     Restoring Location Settings...
echo ==========================================
echo.

:: Restore Location Service
echo Restoring Location Service...
sc config lfsvc start= demand >nul 2>&1


:: Restore Location Access
echo Restoring Location Access...
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" ^
 /v Value /t REG_SZ /d Allow /f >nul


:: Restore Sensor Permission
echo Restoring Sensor Permission...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" ^
 /v SensorPermissionState /t REG_DWORD /d 1 /f >nul


:: Restore Maps Updates
echo Restoring Maps Updates...
reg add "HKLM\SYSTEM\Maps" ^
 /v AutoUpdateEnabled /t REG_DWORD /d 1 /f >nul


echo.
echo ==========================================
echo       Location Settings Restored
echo ==========================================
echo.
pause
goto MENU



:EXIT
exit /b
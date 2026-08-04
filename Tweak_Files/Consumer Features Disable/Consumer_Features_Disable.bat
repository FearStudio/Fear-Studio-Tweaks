@echo off
setlocal enabledelayedexpansion
title Consumer Features - Fear Studio
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
echo     Consumer Features by Fear Studio
echo ==========================================
echo.
echo This tweak:
echo.
echo  [1] Disable Microsoft Consumer Features
echo      - Stops promoted app installs
echo      - Reduces Microsoft Store suggestions
echo.
echo  [2] Restore Default Settings
echo.      
echo.
echo  [3] Exit
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
echo    Disabling Consumer Features...
echo ==========================================
echo.

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" ^
 /v DisableWindowsConsumerFeatures /t REG_DWORD /d 1 /f >nul

if %errorlevel%==0 (
    echo Consumer Features disabled successfully.
) else (
    echo Failed to apply tweak.
)

echo.
echo ==========================================
echo       Tweak Applied Successfully
echo ==========================================
echo.
echo Restart Explorer or sign out for
echo changes to fully apply.
echo.

pause
goto MENU


:RESTORE
cls
echo ==========================================
echo    Restoring Consumer Features...
echo ==========================================
echo.

reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" ^
 /v DisableWindowsConsumerFeatures /f >nul 2>&1

if %errorlevel%==0 (
    echo Consumer Features restored successfully.
) else (
    echo Registry entry was already removed.
)

echo.
echo ==========================================
echo       Restore Completed Successfully
echo ==========================================
echo.
echo Restart Explorer or sign out for
echo changes to fully apply.
echo.

pause
goto MENU


:EXIT
cls
echo.
echo ==========================================
echo          Fear Studio - Exiting
echo ==========================================
echo.
timeout /t 2 >nul
exit /b
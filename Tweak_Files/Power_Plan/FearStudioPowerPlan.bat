@echo off
setlocal enabledelayedexpansion
title Ultimate Performance Plan - Fear Studio
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
echo    Ultimate Performance Plan - Fear Studio
echo ==========================================
echo.
echo  [1] Apply Tweak  - Create ^& Activate Ultimate Performance
echo  [2] Revert Tweak - Remove Plan ^& Restore Defaults
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
echo    Ultimate Performance Plan - Fear Studio
echo ==========================================
echo.

:: ---------------------------------------------
:: Check if Ultimate Performance already exists
:: (prevents duplicate plans on repeated runs)
:: ---------------------------------------------
set "PLAN="
for /f "tokens=2 delims=:" %%g in ('powercfg -list ^| findstr /i "Fear Studio Ultimate"') do (
    for /f "tokens=1" %%h in ("%%g") do set "PLAN=%%h"
)

if defined PLAN (
    echo [i] Existing Fear Studio plan found: !PLAN!
    goto :activate
)

echo [1/4] Creating Ultimate Performance plan...
echo.

:: ---------------------------------------------
:: Duplicate the hidden Ultimate Performance scheme
:: Save raw output so we can debug if it fails
:: ---------------------------------------------
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 > "%temp%\fs_plan_output.txt" 2>&1
type "%temp%\fs_plan_output.txt"
echo.

for /f "tokens=4 delims= " %%a in ('type "%temp%\fs_plan_output.txt" ^| findstr /i "GUID"') do set "PLAN=%%a"

if not defined PLAN (
    echo ==========================================
    echo   ERROR: Could not create the power plan.
    echo ==========================================
    echo This usually means one of the following:
    echo  1. Ultimate Performance is not available on this
    echo     Windows edition ^(Home edition does not support it -
    echo     you need Pro, Enterprise, or Education^).
    echo  2. Your Windows display language changed the powercfg
    echo     output format so it could not be parsed.
    echo.
    echo Raw output was saved to: %temp%\fs_plan_output.txt
    echo Please check that file and share it if you need help.
    pause
    exit /b 1
)

echo       Created Plan GUID: %PLAN%
echo       Done.
echo.

:: Rename it so it's easy to identify next time
powercfg -changename %PLAN% "Fear Studio Ultimate Performance"

:activate
echo [2/4] Activating plan...
powercfg -setactive %PLAN%
if %errorlevel% neq 0 (
    echo       ERROR: Failed to activate plan %PLAN%
    pause
    exit /b 1
)
echo       Done.
echo.

echo [3/4] Applying performance settings...

:: CPU Performance
powercfg -setacvalueindex %PLAN% SUB_PROCESSOR PROCTHROTTLEMIN 100
powercfg -setacvalueindex %PLAN% SUB_PROCESSOR PROCTHROTTLEMAX 100

:: USB Selective Suspend OFF
powercfg -setacvalueindex %PLAN% SUB_USB USBSELECTIVE 0

:: PCI Express - ASPM off
powercfg -setacvalueindex %PLAN% SUB_PCIE ASPM 0

:: Disable Sleep / Hibernate idle timers
powercfg -setacvalueindex %PLAN% SUB_SLEEP STANDBYIDLE 0
powercfg -setacvalueindex %PLAN% SUB_SLEEP HIBERNATEIDLE 0

:: Re-apply plan so settings take effect
powercfg -setactive %PLAN%
echo       Done.
echo.

echo [4/4] Applying gaming registry tweaks...
:: GPU Hardware Scheduling
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v HwSchMode /t REG_DWORD /d 2 /f >nul

:: Game Mode
reg add "HKCU\Software\Microsoft\GameBar" /v AllowAutoGameMode /t REG_DWORD /d 1 /f >nul

:: Disable Game DVR
reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f >nul
echo       Done.
echo.

echo ==========================================
echo   Tweak Applied Successfully
echo ==========================================
echo.
powercfg -list
echo.
echo Restart your PC for full effect.
echo.
pause
exit /b

:: ============================================================
:: REVERT
:: ============================================================
:revert
cls
echo ==========================================
echo    Ultimate Performance Plan - Fear Studio
echo ==========================================
echo.

echo Looking for an existing Fear Studio plan...
set "PLAN="
for /f "tokens=2 delims=:" %%g in ('powercfg -list ^| findstr /i "Fear Studio Ultimate"') do (
    for /f "tokens=1" %%h in ("%%g") do set "PLAN=%%h"
)

if defined PLAN (
    echo [i] Found plan: !PLAN!
    echo Switching to Windows' default Balanced plan...
    powercfg -setactive 381b4222-f694-41f0-9685-ff5bb260df2e
    echo Removing Fear Studio Ultimate Performance plan...
    powercfg -delete !PLAN! >nul 2>&1
    if !errorlevel! equ 0 (
        echo       Plan removed successfully.
    ) else (
        echo       WARNING: Could not remove the plan automatically.
        echo       You can delete it manually from Power Options.
    )
) else (
    echo [i] No Fear Studio plan found - nothing to remove.
)
echo.

echo Restoring gaming registry tweaks to Windows defaults...
:: Let the system/driver decide GPU scheduling instead of forcing it
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v HwSchMode /f >nul 2>&1
:: Game Mode and Game DVR are enabled by default on stock Windows
reg add "HKCU\Software\Microsoft\GameBar" /v AllowAutoGameMode /t REG_DWORD /d 1 /f >nul
reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 1 /f >nul
echo       Done.
echo.

echo ==========================================
echo   Tweak Reverted Successfully
echo ==========================================
echo.
powercfg -list
echo.
echo Restart your PC for full effect.
echo.
pause
exit /b
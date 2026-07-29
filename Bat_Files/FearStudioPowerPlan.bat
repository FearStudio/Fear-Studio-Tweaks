@echo off
setlocal enabledelayedexpansion
title Fear Studio Ultimate Performance Creator
color 0A

:: ---------------------------------------------
:: Check Admin
:: ---------------------------------------------
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting Administrator access...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

cls
echo ==========================================
echo   FEAR STUDIO ULTIMATE PERFORMANCE PLAN
echo   POWER PLAN CREATOR
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
    echo Existing Fear Studio plan found: !PLAN!
    goto :activate
)

echo Creating Ultimate Performance plan...
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
    echo ERROR: Could not create the power plan.
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

echo Created Plan GUID: %PLAN%
echo.

:: Rename it so it's easy to identify next time
powercfg -changename %PLAN% "Fear Studio Ultimate Performance"

:activate
echo Activating plan...
powercfg -setactive %PLAN%
if %errorlevel% neq 0 (
    echo ERROR: Failed to activate plan %PLAN%
    pause
    exit /b 1
)
echo.

echo Applying performance settings...

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

:: GPU Hardware Scheduling
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v HwSchMode /t REG_DWORD /d 2 /f

:: Game Mode
reg add "HKCU\Software\Microsoft\GameBar" /v AllowAutoGameMode /t REG_DWORD /d 1 /f

:: Disable Game DVR
reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f

echo.
echo ==========================================
echo FEAR STUDIO POWER PLAN CREATED / ACTIVATED
echo ==========================================
echo.
powercfg -list
echo.
echo Restart PC for full effect.
pause

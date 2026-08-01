@echo off
setlocal enabledelayedexpansion
title Telemetry Disable - Fear Studio
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
echo       Telemetry Disable - Fear Studio
echo ==========================================
echo.
echo  [1] Apply Tweak  - Disable Telemetry
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
echo       Telemetry Disable - Fear Studio
echo ==========================================
echo.
echo Disabling Microsoft Telemetry...
echo.

:: Advertising ID
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" ^
 /v Enabled /t REG_DWORD /d 0 /f >nul
:: Tailored Experiences
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Privacy" ^
 /v TailoredExperiencesWithDiagnosticDataEnabled /t REG_DWORD /d 0 /f >nul
:: Online Speech Privacy
reg add "HKCU\Software\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy" ^
 /v HasAccepted /t REG_DWORD /d 0 /f >nul
:: Input Telemetry
reg add "HKCU\Software\Microsoft\Input\TIPC" ^
 /v Enabled /t REG_DWORD /d 0 /f >nul
:: Ink Collection
reg add "HKCU\Software\Microsoft\InputPersonalization" ^
 /v RestrictImplicitInkCollection /t REG_DWORD /d 1 /f >nul
:: Text Collection
reg add "HKCU\Software\Microsoft\InputPersonalization" ^
 /v RestrictImplicitTextCollection /t REG_DWORD /d 1 /f >nul
:: Contact Harvesting
reg add "HKCU\Software\Microsoft\InputPersonalization\TrainedDataStore" ^
 /v HarvestContacts /t REG_DWORD /d 0 /f >nul
:: Privacy Policy
reg add "HKCU\Software\Microsoft\Personalization\Settings" ^
 /v AcceptedPrivacyPolicy /t REG_DWORD /d 0 /f >nul
:: System Telemetry
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" ^
 /v AllowTelemetry /t REG_DWORD /d 0 /f >nul
:: Disable Start Menu Tracking
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" ^
 /v Start_TrackProgs /t REG_DWORD /d 0 /f >nul
:: Disable Activity History
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" ^
 /v PublishUserActivities /t REG_DWORD /d 0 /f >nul
:: Disable Feedback Frequency
reg add "HKCU\Software\Microsoft\Siuf\Rules" ^
 /v NumberOfSIUFInPeriod /t REG_DWORD /d 0 /f >nul
echo Registry tweaks applied.
echo.

echo Disabling Defender Sample Submission...
powershell -Command "Set-MpPreference -SubmitSamplesConsent 2" >nul 2>&1

echo Disabling Telemetry Services...
sc config DiagTrack start= disabled >nul
sc stop DiagTrack >nul 2>&1
sc config WerSvc start= disabled >nul
sc stop WerSvc >nul 2>&1

echo Disabling PowerShell Telemetry...
setx POWERSHELL_TELEMETRY_OPTOUT 1 /M >nul

echo Removing Feedback Timer...
powershell -Command "Remove-ItemProperty -Path 'HKCU:\Software\Microsoft\Siuf\Rules' -Name PeriodInNanoSeconds -ErrorAction SilentlyContinue"

echo.
echo ==========================================
echo     Tweak Applied Successfully
echo ==========================================
echo.
echo Restart Windows recommended for all
echo services to fully unload.
echo.
pause
exit /b

:: ============================================================
:: REVERT
:: ============================================================
:revert
cls
echo ==========================================
echo       Telemetry Disable - Fear Studio
echo ==========================================
echo.
echo Restoring Windows telemetry defaults...
echo.

:: Advertising ID - default is enabled
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" ^
 /v Enabled /t REG_DWORD /d 1 /f >nul
:: Tailored Experiences - default is enabled
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Privacy" ^
 /v TailoredExperiencesWithDiagnosticDataEnabled /t REG_DWORD /d 1 /f >nul
:: Online Speech Privacy - doesn't exist until user accepts, so remove override
reg delete "HKCU\Software\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy" ^
 /v HasAccepted /f >nul 2>&1
:: Input Telemetry - default is enabled
reg add "HKCU\Software\Microsoft\Input\TIPC" ^
 /v Enabled /t REG_DWORD /d 1 /f >nul
:: Ink/Text Collection - default is not restricted
reg add "HKCU\Software\Microsoft\InputPersonalization" ^
 /v RestrictImplicitInkCollection /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Microsoft\InputPersonalization" ^
 /v RestrictImplicitTextCollection /t REG_DWORD /d 0 /f >nul
:: Contact Harvesting - optional key, remove override
reg delete "HKCU\Software\Microsoft\InputPersonalization\TrainedDataStore" ^
 /v HarvestContacts /f >nul 2>&1
:: Privacy Policy acceptance flag - optional key, remove override
reg delete "HKCU\Software\Microsoft\Personalization\Settings" ^
 /v AcceptedPrivacyPolicy /f >nul 2>&1
:: System Telemetry policy - remove the policy override entirely
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" ^
 /v AllowTelemetry /f >nul 2>&1
:: Start Menu Tracking - default is enabled
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" ^
 /v Start_TrackProgs /t REG_DWORD /d 1 /f >nul
:: Activity History policy - remove the policy override entirely
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" ^
 /v PublishUserActivities /f >nul 2>&1
:: Feedback Frequency - optional key, remove override
reg delete "HKCU\Software\Microsoft\Siuf\Rules" ^
 /v NumberOfSIUFInPeriod /f >nul 2>&1
echo Registry tweaks reverted.
echo.

echo Restoring Defender Sample Submission...
powershell -Command "Set-MpPreference -SubmitSamplesConsent 1" >nul 2>&1

echo Restoring Telemetry Services...
sc config DiagTrack start= delayed-auto >nul
net start DiagTrack >nul 2>&1
sc config WerSvc start= demand >nul

echo Restoring PowerShell Telemetry...
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" ^
 /v POWERSHELL_TELEMETRY_OPTOUT /f >nul 2>&1

echo.
echo ==========================================
echo     Tweak Reverted Successfully
echo ==========================================
echo.
echo Restart Windows recommended for all
echo services to fully reload.
echo.
pause
exit /b
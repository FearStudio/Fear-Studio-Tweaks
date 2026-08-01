@echo off
setlocal enabledelayedexpansion
title Services Optimizer - Fear Studio
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
cls
echo ==========================================
echo        Services Optimizer by Fear Studio
echo ==========================================
echo.
echo Applying Windows Service Optimizations...
echo.
:: Disable Offline Files Service
echo Disabling CscService...
sc config CscService start= disabled >nul 2>&1
sc stop CscService >nul 2>&1
:: Disable Connected User Experiences and Telemetry
echo Disabling DiagTrack...
sc config DiagTrack start= disabled >nul 2>&1
sc stop DiagTrack >nul 2>&1
:: Set Maps Broker to Manual
echo Setting MapsBroker to Manual...
sc config MapsBroker start= demand >nul 2>&1
:: Set Storage Service to Manual
echo Setting StorSvc to Manual...
sc config StorSvc start= demand >nul 2>&1
:: Disable Internet Connection Sharing
echo Disabling SharedAccess...
sc config SharedAccess start= disabled >nul 2>&1
sc stop SharedAccess >nul 2>&1
echo.
echo Adjusting Service Host Split Threshold...
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
"$ErrorActionPreference='Stop'; try { $Memory = [math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1KB); Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control' -Name SvcHostSplitThresholdInKB -Value $Memory -Type DWord -Force; Write-Host \"SvcHostSplitThresholdInKB set to $Memory KB\" } catch { Write-Host 'Failed to set SvcHostSplitThresholdInKB:' $_.Exception.Message }"
echo.
echo ==========================================
echo      Services Optimized Successfully
echo ==========================================
echo.
echo Restart Windows for all services
echo changes to fully apply.
echo.
pause
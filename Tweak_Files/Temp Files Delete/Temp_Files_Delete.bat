@echo off
setlocal
title Temporary Files Remove - Fear Studio
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
echo    Temporary Files Remove by Fear Studio
echo ==========================================
echo.
echo [1] Execute Cleanup
echo [2] Exit
echo.

choice /c 12 /n /m "Select an option: "

if %errorlevel%==2 exit
if %errorlevel%==1 goto CLEAN


:CLEAN
cls
echo ==========================================
echo       Removing Temporary Files...
echo ==========================================
echo.

powershell.exe -NoProfile -Command "Remove-Item -Path $env:Temp\* -Recurse -Force -ErrorAction SilentlyContinue"

powershell.exe -NoProfile -Command "Remove-Item -Path $env:SystemRoot\Temp\* -Recurse -Force -ErrorAction SilentlyContinue"


echo.
echo ==========================================
echo       Cleanup Completed Successfully
echo ==========================================
echo.

pause
exit /b
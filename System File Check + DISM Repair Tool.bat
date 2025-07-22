@echo off
:: Windows Repair Script - SFC & DISM
:: Automatically runs as Administrator

:: Check for Admin rights
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo ==========================================
    echo  Requesting Administrator privileges...
    echo ==========================================
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit
)

echo ==========================================
echo  WINDOWS SYSTEM REPAIR SCRIPT
echo ==========================================

:: Step 1: Run System File Checker (SFC)
echo [1/4] Running SFC /scannow...
sfc /scannow
if %errorLevel% neq 0 (
    echo ERROR: SFC /scannow failed!
    pause
    exit /b
)

:: Step 2: Run DISM StartComponentCleanup
echo [2/4] Running DISM StartComponentCleanup...
Dism /online /Cleanup-Image /StartComponentCleanup
if %errorLevel% neq 0 (
    echo ERROR: DISM /StartComponentCleanup failed!
    pause
    exit /b
)

:: Step 3: Run DISM ScanHealth
echo [3/4] Running DISM ScanHealth...
Dism /Online /Cleanup-Image /ScanHealth
if %errorLevel% neq 0 (
    echo ERROR: DISM /ScanHealth failed!
    pause
    exit /b
)

:: Step 4: Run DISM RestoreHealth
echo [4/4] Running DISM RestoreHealth...
Dism /Online /Cleanup-Image /RestoreHealth
if %errorLevel% neq 0 (
    echo ERROR: DISM /RestoreHealth failed!
    pause
    exit /b
)

echo ==========================================
echo  WINDOWS SYSTEM REPAIR SCRIPT - 2ND PASS
echo ==========================================

:: Step 1: Run System File Checker (SFC)
echo [1/4] Running SFC /scannow...
sfc /scannow
if %errorLevel% neq 0 (
    echo ERROR: SFC /scannow failed!
    pause
    exit /b
)

echo ==========================================
echo  ALL REPAIRS COMPLETED SUCCESSFULLY
echo ==========================================
pause
exit
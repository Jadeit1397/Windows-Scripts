@echo off
echo ================================
echo     ADVANCED CLEANUP SCRIPT
echo ================================

:: Delete Recycle Bin contents
rd /s /q C:\$Recycle.Bin

echo The Recycle Bin has been emptied successfully!

@echo off
setlocal

echo =========================================
echo        CLEAR WINDOWS DOWNLOADS FOLDER
echo =========================================
echo.
echo WARNING: This will permanently delete all files in your Downloads folder!
echo.

set /p userChoice=Do you want to continue? (Y/N): 

if /i "%userChoice%"=="Y" (
    echo.
    echo Deleting all files in Downloads folder...
    del /q /f /s "%USERPROFILE%\Downloads\*" >nul 2>&1
    for /d %%p in ("%USERPROFILE%\Downloads\*.*") do rmdir "%%p" /s /q
    echo Done! Downloads folder has been cleared.
) else (
    echo Operation cancelled. No files were deleted.
)

:: 2. Run Disk Cleanup (silent)
echo [*] Running Disk Cleanup...
cleanmgr /sagerun:1

:: 3. Clear user TEMP folder
echo [*] Clearing User TEMP folder...
del /q /f /s "%TEMP%\*" >nul 2>&1
for /d %%p in ("%TEMP%\*.*") do rmdir "%%p" /s /q

:: 4. Clear system TEMP folder
echo [*] Clearing Windows TEMP folder...
del /q /f /s "C:\Windows\Temp\*" >nul 2>&1
for /d %%p in ("C:\Windows\Temp\*.*") do rmdir "%%p" /s /q

:: 5. Clear Prefetch (optional)
echo [*] Clearing Prefetch folder...
del /q /f /s "C:\Windows\Prefetch\*" >nul 2>&1

:: 6. Delete Windows log files
echo [*] Deleting Windows log files...
del /q /f /s "C:\Windows\Logs\*" >nul 2>&1

:: 8. Delete memory dump files
echo [*] Deleting memory dump files...
del /q /f /s "C:\Windows\MEMORY.DMP" >nul 2>&1
del /q /f /s "C:\Windows\Minidump\*" >nul 2>&1

:: 9. Clear Windows Update cache
echo [*] Cleaning Windows Update cache...
net stop wuauserv >nul 2>&1
rmdir /s /q "C:\Windows\SoftwareDistribution\Download"
net start wuauserv >nul 2>&1

:: 10. Clear recent file history
echo [*] Clearing Recent Files history...
del /q /f "%APPDATA%\Microsoft\Windows\Recent\*" >nul 2>&1

echo ================================
echo       CLEANUP COMPLETED
echo ================================
pause

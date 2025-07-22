@echo off
echo ====================================
echo  CREATE NEW LOCAL WINDOWS ADMIN USER
echo ====================================

:: Prompt for username
set /p username=Enter the new username: 

:: Prompt for password (hidden input via PowerShell)
for /f "usebackq delims=" %%P in (`powershell -Command "Read-Host -AsSecureString 'Enter the password:' | ConvertFrom-SecureString"`) do set password=%%P

:: Convert password back to plain text
for /f "usebackq delims=" %%P in (`powershell -Command "ConvertTo-SecureString '%password%' | ConvertFrom-SecureString -AsPlainText -Force"`) do set plainpass=%%P

:: Create the user
net user "%username%" "%plainpass%" /add
if %errorlevel% neq 0 (
    echo Failed to create user. Make sure you run this script as Administrator.
    pause
    exit /b
)

:: Add the user to Administrators group
net localgroup Administrators "%username%" /add
if %errorlevel% neq 0 (
    echo Failed to add user to Administrators group.
    pause
    exit /b
)

echo =================================
echo SUCCESS: User "%username%" created with admin rights.
echo =================================
pause

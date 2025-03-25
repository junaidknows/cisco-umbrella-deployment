@echo off
setlocal

:: Setup paths
set SHARE=\\server-d01\NETLOGON\Software
set VPN=%SHARE%\cisco-secure-client-win-5.1.8.122-core-vpn-predeploy-k9.msi
set UMBRELLA=%SHARE%\cisco-secure-client-win-5.1.8.122-umbrella-predeploy-k9.msi
set DART=%SHARE%\cisco-secure-client-win-5.1.8.122-dart-predeploy-k9.msi
set PROFILE=%SHARE%\OrgInfo.json
set MARKER=C:\ProgramData\Cisco\CiscoClient_Deployed.txt

:: Check if correct version is already installed
wmic product where "Name='Cisco Secure Client - AnyConnect VPN'" get Version | findstr "5.1.8.122" >nul
if %ERRORLEVEL% EQU 0 (
    :: Version is already installed, do nothing
    exit
)

:: Uninstall any existing Cisco Secure Client components
wmic product where "Name like '%%Cisco Secure Client - AnyConnect VPN%%'" call uninstall /nointeractive >nul 2>&1
wmic product where "Name like '%%Cisco Secure Client - Umbrella%%'" call uninstall /nointeractive >nul 2>&1
wmic product where "Name like '%%Cisco Secure Client - Diagnostics and Reporting Tool%%'" call uninstall /nointeractive >nul 2>&1

:: Wait for uninstalls to finish
timeout /t 10 /nobreak >nul

:: Install Core VPN
if exist "%VPN%" (
    msiexec /i "%VPN%" /qn /norestart PRE_DEPLOY_DISABLE_VPN=1
)

:: Install Umbrella
if exist "%UMBRELLA%" (
    msiexec /i "%UMBRELLA%" /qn /norestart
)

:: Install DART
if exist "%DART%" (
    msiexec /i "%DART%" /qn /norestart
)

:: Ensure target folder exists for OrgInfo
if not exist "C:\ProgramData\Cisco\Cisco Secure Client\Umbrella" (
    mkdir "C:\ProgramData\Cisco\Cisco Secure Client\Umbrella"
)

:: Copy OrgInfo.json silently
if exist "%PROFILE%" (
    xcopy "%PROFILE%" "C:\ProgramData\Cisco\Cisco Secure Client\Umbrella\" /Y /I >nul 2>&1
)

:: Create a marker so we know this machine is now on 5.1.8.122
echo Installed Cisco Secure Client 5.1.8.122 on %DATE% %TIME% > "%MARKER%"

exit

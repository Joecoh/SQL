@echo off
setlocal

:: Optional: Skip if already installed
if exist "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysqld.exe" (
    echo MySQL already installed. Skipping...
    goto :eof
)

echo Installing MySQL Installer...
start /wait "" msiexec /i "mysql-installer-community-8.0.42.0.msi" /quiet

:: Wait for tools to extract
timeout /t 10 >nul

:: Run silent install using CLI tool
set INSTALLER_PATH="C:\Program Files (x86)\MySQL\MySQL Installer for Windows\MySQLInstallerConsole.exe"
%INSTALLER_PATH% install server;8.0.42 workbench shell --silent

:: Add MySQL to PATH
set MYSQL_BIN="C:\Program Files\MySQL\MySQL Server 8.0\bin"
setx PATH "%PATH%;%MYSQL_BIN%" >nul

:: Wait for MySQL service to start
timeout /t 10 >nul

:: Set root password using init.sql
echo Configuring MySQL root password...
"%MYSQL_BIN%\mysql.exe" -u root --connect-expired-password < init.sql

echo.
echo ✅ MySQL installed silently.
echo 🔐 Root password set to: gtec
echo 📂 MySQL path added to environment variables.
echo.
pause
endlocal

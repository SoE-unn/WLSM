@echo off
setlocal

cd /d "%~dp0"

set "APP_NAME=WildLife Scene Manager"
set "SCRIPT=SoE_Scene_Manager.py"
set "ICON=ICO\app.ico"

where py >nul 2>nul
if %errorlevel%==0 (
    set "PYTHON=py"
) else (
    where python >nul 2>nul
    if %errorlevel%==0 (
        set "PYTHON=python"
    ) else (
        echo Python was not found.
        echo Please install Python and try again.
        pause
        exit /b 1
    )
)

if not exist "%SCRIPT%" (
    echo Script not found: %SCRIPT%
    pause
    exit /b 1
)

echo Installing/updating PyInstaller...
%PYTHON% -m pip install --upgrade pyinstaller
if errorlevel 1 (
    echo Failed to install PyInstaller.
    pause
    exit /b 1
)

set "ICON_ARG="
if exist "%ICON%" set "ICON_ARG=--icon=%ICON%"

set "DATA_ARG="
if exist "ICO" set "DATA_ARG=--add-data=ICO;ICO"

echo.
echo Building %APP_NAME%...
%PYTHON% -m PyInstaller ^
    --noconfirm ^
    --clean ^
    --windowed ^
    --name "%APP_NAME%" ^
    %ICON_ARG% ^
    %DATA_ARG% ^
    "%SCRIPT%"

if errorlevel 1 (
    echo.
    echo Build failed.
    pause
    exit /b 1
)

echo.
echo Build complete.
echo Program folder created in:
echo %cd%\dist\%APP_NAME%
echo.
echo Open this folder and run:
echo %APP_NAME%.exe
pause

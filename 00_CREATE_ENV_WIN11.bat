@echo off
setlocal EnableExtensions
cd /d "%~dp0"
title Behavior Studio - Create Windows 11 environment

set "PYTHON_EXE="

echo ============================================================
echo  BEHAVIOR STUDIO - WINDOWS 11 ENVIRONMENT v0.1.5
echo  Python 3.10-3.14 x64 + PySide6 / Qt6
echo ============================================================
echo.

echo [1/4] Detecting an installed 64-bit Python 3.10-3.14...

rem Prefer the exact Python Install Manager paths used by recent Python releases.
if exist "%LocalAppData%\Python\pythoncore-3.14-64\python.exe" set "PYTHON_EXE=%LocalAppData%\Python\pythoncore-3.14-64\python.exe"
if not defined PYTHON_EXE if exist "%LocalAppData%\Python\pythoncore-3.13-64\python.exe" set "PYTHON_EXE=%LocalAppData%\Python\pythoncore-3.13-64\python.exe"
if not defined PYTHON_EXE if exist "%LocalAppData%\Python\pythoncore-3.12-64\python.exe" set "PYTHON_EXE=%LocalAppData%\Python\pythoncore-3.12-64\python.exe"
if not defined PYTHON_EXE if exist "%LocalAppData%\Python\pythoncore-3.11-64\python.exe" set "PYTHON_EXE=%LocalAppData%\Python\pythoncore-3.11-64\python.exe"
if not defined PYTHON_EXE if exist "%LocalAppData%\Python\pythoncore-3.10-64\python.exe" set "PYTHON_EXE=%LocalAppData%\Python\pythoncore-3.10-64\python.exe"

rem Final fallback: first python.exe found on PATH.
if not defined PYTHON_EXE for /f "delims=" %%P in ('where python 2^>nul') do if not defined PYTHON_EXE set "PYTHON_EXE=%%P"
if not defined PYTHON_EXE for /f "delims=" %%P in ('where py 2^>nul') do if not defined PYTHON_EXE set "PYTHON_EXE=%%P"

if not defined PYTHON_EXE goto python_not_found

rem Validate version and architecture using Python's exit code.
rem Avoid < and > operators because cmd.exe can reinterpret them inside FOR /F.
"%PYTHON_EXE%" -c "import sys,struct; raise SystemExit(0 if sys.version_info.major == 3 and sys.version_info.minor in (10,11,12,13,14) and struct.calcsize('P')*8 == 64 else 1)" >nul 2>&1
if errorlevel 1 goto python_invalid

echo [OK] Compatible Python detected:
echo      %PYTHON_EXE%
"%PYTHON_EXE%" -c "import sys,struct; print('     Version: ' + sys.version.replace(chr(10),' ')); print('     Architecture: ' + str(struct.calcsize('P')*8) + '-bit')"
echo.

if exist ".venv" (
    echo [INFO] Removing previous .venv...
    rmdir /s /q ".venv"
)

echo [2/4] Creating virtual environment...
"%PYTHON_EXE%" -m venv .venv
if not exist ".venv\Scripts\python.exe" goto venv_fail

echo [3/4] Updating pip/setuptools/wheel...
".venv\Scripts\python.exe" -m pip install --upgrade pip setuptools wheel
if errorlevel 1 goto fail

echo [4/4] Installing Behavior Studio dependencies...
".venv\Scripts\python.exe" -m pip install -r requirements_win11.txt
if errorlevel 1 goto fail

echo.
echo [INFO] Verifying Qt runtime...
".venv\Scripts\python.exe" -c "import PySide6, lxml, regex, sortedcontainers; from PySide6 import QtCore; print('[OK] PySide6 ' + PySide6.__version__ + ' / Qt ' + QtCore.qVersion())"
if errorlevel 1 goto fail

echo.
echo ============================================================
echo [OK] Environment ready.
echo ============================================================
echo Run 01_RUN_DEV_WIN11.bat to start Behavior Studio.
echo.
pause
exit /b 0

:python_not_found
echo.
echo [ERROR] No Python executable was found.
echo Expected first choice:
echo   %%LocalAppData%%\Python\pythoncore-3.14-64\python.exe
echo.
pause
exit /b 1

:python_invalid
echo.
echo [ERROR] Python was found but is not a compatible 64-bit Python 3.10-3.14 runtime.
echo Detected candidate:
echo   %PYTHON_EXE%
echo.
echo Send me the output of:
echo   "%PYTHON_EXE%" --version
echo.
pause
exit /b 1

:venv_fail
echo.
echo [ERROR] Python was found, but .venv\Scripts\python.exe was not created.
goto fail

:fail
echo.
echo [ERROR] Environment setup failed.
pause
exit /b 1

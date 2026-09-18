@echo off
setlocal
cd /d "%~dp0"
title Behavior Studio - Development Run

if not exist ".venv\Scripts\python.exe" (
    echo [ERROR] .venv not found. Run 00_CREATE_ENV_WIN11.bat first.
    pause
    exit /b 1
)

set "BEHAVIOR_STUDIO_ROOT=%CD%"
".venv\Scripts\python.exe" "source\behavior_studio_win11.py" %*
set "RC=%ERRORLEVEL%"
if not "%RC%"=="0" (
    echo.
    echo [ERROR] Behavior Studio exited with code %RC%.
    pause
)
exit /b %RC%

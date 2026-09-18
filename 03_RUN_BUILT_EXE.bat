@echo off
setlocal
cd /d "%~dp0"
if not exist "dist\BehaviorStudio\BehaviorStudio.exe" (
    echo [ERROR] Build not found. Run 02_BUILD_EXE_WIN11.bat first.
    pause
    exit /b 1
)
start "Behavior Studio" "dist\BehaviorStudio\BehaviorStudio.exe"

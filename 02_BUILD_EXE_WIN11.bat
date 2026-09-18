@echo off
setlocal EnableExtensions
cd /d "%~dp0"
title Behavior Studio - Build EXE

if not exist ".venv\Scripts\python.exe" (
    echo [ERROR] .venv not found. Run 00_CREATE_ENV_WIN11.bat first.
    pause
    exit /b 1
)

if exist "build" rmdir /s /q "build"
if exist "dist\BehaviorStudio" rmdir /s /q "dist\BehaviorStudio"

echo ============================================================
echo  BUILDING BEHAVIOR STUDIO FOR WINDOWS 11
echo ============================================================
echo.

".venv\Scripts\python.exe" -m PyInstaller --noconfirm BehaviorStudio.spec
if errorlevel 1 goto :fail

echo [INFO] Copying editable runtime resources next to the EXE...
xcopy "config" "dist\BehaviorStudio\config\" /E /I /Y >nul
if errorlevel 1 goto :fail
xcopy "data" "dist\BehaviorStudio\data\" /E /I /Y >nul
if errorlevel 1 goto :fail
xcopy "tutorials" "dist\BehaviorStudio\tutorials\" /E /I /Y >nul
if errorlevel 1 goto :fail
copy /Y "COPYING" "dist\BehaviorStudio\COPYING" >nul
copy /Y "README_WIN11.txt" "dist\BehaviorStudio\README_WIN11.txt" >nul

if exist "dist\BehaviorStudio\BehaviorStudio.exe" (
    echo.
    echo [OK] Build completed:
    echo      dist\BehaviorStudio\BehaviorStudio.exe
    echo.
    echo Keep the whole BehaviorStudio folder together.
    pause
    exit /b 0
)

echo [ERROR] EXE not found after build.
goto :fail

:fail
echo.
echo [ERROR] Build failed.
pause
exit /b 1

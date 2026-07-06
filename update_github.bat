@echo off
setlocal EnableExtensions
chcp 65001 >nul

cd /d "%~dp0"

echo ==============================
echo Dashboard update to GitHub
echo ==============================
echo.

where git >nul 2>nul
if errorlevel 1 (
    echo ERROR: Git was not found. Please install Git for Windows first.
    pause
    exit /b 1
)

if not exist dashboard.html (
    echo ERROR: dashboard.html was not found in:
    echo %cd%
    pause
    exit /b 1
)

echo Copying dashboard.html to index.html...
copy /Y dashboard.html index.html >nul
if errorlevel 1 (
    echo ERROR: Failed to copy dashboard.html to index.html.
    pause
    exit /b 1
)

echo Staging files...
git add dashboard.html index.html update_github.bat
if errorlevel 1 (
    echo ERROR: git add failed.
    pause
    exit /b 1
)

git diff --cached --quiet
if errorlevel 1 (
    echo Creating commit...
    git commit -m "update dashboard"
    if errorlevel 1 (
        echo ERROR: git commit failed.
        pause
        exit /b 1
    )
) else (
    echo No new file changes to commit.
)

echo Pushing to GitHub...
git push
if errorlevel 1 (
    echo.
    echo ERROR: git push failed.
    echo Please check your GitHub login, network connection, or remote permissions.
    pause
    exit /b 1
)

echo.
echo ==============================
echo Done. GitHub Pages may take a short time to refresh.
echo ==============================
pause

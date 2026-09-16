@echo off
setlocal
where flutter >nul 2>&1
if errorlevel 1 (
  echo Flutter SDK is not installed or not in PATH.
  pause
  exit /b 1
)
if not exist android (
  call bootstrap_windows.bat
)
flutter pub get
flutter build appbundle --release
if errorlevel 1 exit /b 1
echo.
echo AAB created at:
echo build\app\outputs\bundle\release\app-release.aab
pause

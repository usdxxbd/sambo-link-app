@echo off
setlocal
where flutter >nul 2>&1
if errorlevel 1 (
  echo Flutter SDK is not installed or not in PATH.
  echo Install Flutter first: https://docs.flutter.dev/get-started/install/windows/mobile
  pause
  exit /b 1
)
flutter create . --platforms=android,ios --org kr.co.sambo --project-name sambo_link_app
if errorlevel 1 exit /b 1
python tool\configure_platforms.py
flutter pub get
dart run flutter_launcher_icons
dart run flutter_native_splash:create
echo.
echo SAMBO project setup complete with official logo assets.
echo Run build_android_apk.bat to create an APK.
pause

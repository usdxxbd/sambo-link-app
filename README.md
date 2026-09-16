# SAMBO Link App v3

삼보 공식 로고를 적용한 Android/iPhone 공용 Flutter 앱입니다.
앱을 실행하면 SAMBO 시작 화면 후 `https://linktr.ee/sambo_cart`를 바로 표시합니다.

## v3 적용 내용
- 사용자가 제공한 SAMBO PNG 로고 적용
- 앱 내부 시작 화면에 공식 로고 적용
- Android/iPhone 앱 아이콘 자동 생성 설정
- Android 12 / iOS 네이티브 스플래시 설정
- Linktree 자동 연결
- 뒤로가기 / 새로고침 / 공유 / 홈
- 인터넷 연결 오류 및 재시도 화면

## 배포 목표
- Android: APK 직접 배포
- Android: Google Play AAB
- iPhone: TestFlight / App Store

## Android APK를 가장 쉽게 만드는 방법
이 프로젝트 전체를 GitHub 저장소에 업로드한 뒤:
1. GitHub의 `Actions` 탭
2. `Build SAMBO Android`
3. `Run workflow`
4. 완료 후 `SAMBO-Android-APK` artifact 다운로드

그 안의 `app-release.apk`가 안드로이드 설치 파일입니다.

## Windows PC 직접 빌드
Flutter SDK와 Android Studio가 설치되어 있다면:
1. `bootstrap_windows.bat`
2. `build_android_apk.bat`
3. 결과: `build/app/outputs/flutter-apk/app-release.apk`

Google Play 업로드 파일은 `build_android_aab.bat`으로 생성합니다.

## iPhone
같은 소스를 그대로 사용합니다. TestFlight/App Store 최종 배포에는 Apple Developer 계정과 서명 설정이 필요합니다.

## 현재 기본값
- App name: `SAMBO`
- Link: `https://linktr.ee/sambo_cart`
- Project: `sambo_link_app`
- Organization: `kr.co.sambo`
- Expected Bundle/Application ID: `kr.co.sambo.sambo_link_app`

## 로고 파일
- 원본: `assets/branding/sambo_logo.png`
- 스플래시용: `assets/branding/sambo_logo_trimmed.png`
- 앱 아이콘용: `assets/branding/sambo_app_icon.png`

앱 아이콘용 이미지는 제공받은 PNG의 중앙 심볼 영역을 정사각형으로 배치해 사용하도록 준비했습니다.

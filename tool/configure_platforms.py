from pathlib import Path

# Android: app label + internet permission
manifest = Path('android/app/src/main/AndroidManifest.xml')
if manifest.exists():
    s = manifest.read_text(encoding='utf-8')
    if 'android.permission.INTERNET' not in s:
        s = s.replace('<manifest xmlns:android="http://schemas.android.com/apk/res/android">',
                      '<manifest xmlns:android="http://schemas.android.com/apk/res/android">\n    <uses-permission android:name="android.permission.INTERNET" />')
    s = s.replace('android:label="sambo_link_app"', 'android:label="SAMBO"')
    manifest.write_text(s, encoding='utf-8')

# Android package/application ID generated from --org kr.co.sambo + project name.
# Final expected ID: kr.co.sambo.sambo_link_app

# iOS: display name
plist = Path('ios/Runner/Info.plist')
if plist.exists():
    s = plist.read_text(encoding='utf-8')
    s = s.replace('<string>sambo_link_app</string>', '<string>SAMBO</string>')
    s = s.replace('<string>$(PRODUCT_NAME)</string>', '<string>SAMBO</string>', 1)
    plist.write_text(s, encoding='utf-8')

print('SAMBO platform settings applied.')

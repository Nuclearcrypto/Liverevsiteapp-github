# Rev-N-Rip Full Website Style Android App

This Android project packages the current Rev-N-Rip website baseline directly into the app assets so the app uses the same pages, tabs, images, logos, scripts, and themes.

## Based on
revnrip_ADMIN_BASELINE_EBAY_LINKS_ONLY.zip

## What changed vs the starter app
- The app now loads the full website-style Rev-N-Rip experience from Android assets.
- The `images/` folder is included inside the app.
- Internal website tabs/pages load inside the app WebView.
- eBay links open externally.
- Mail links open externally.
- Back button works.
- Added a floating share button in app pages.
- Added an offline fallback page.
- Version bumped to `versionCode 2`, `versionName 1.1.0`.

## Build APK
Open this folder in Android Studio and run:

Build > Build Bundle(s) / APK(s) > Build APK(s)

Debug APK location:
app/build/outputs/apk/debug/app-debug.apk

## Important
If you update the launcher icon again, use Android Studio's Image Asset tool. If you see XML errors, check:
app/src/main/res/drawable/ic_launcher_background.xml

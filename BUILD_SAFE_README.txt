REV-N-RIP CLEAN BUILD SAFE PROJECT

I checked and rewrote the Android launcher icon XML files to avoid this error:

The processing instruction target matching "[xX][mM][lL]" is not allowed.

If you use Android Studio Image Asset again and the build breaks, the file most likely corrupted is:
app/src/main/res/drawable/ic_launcher_background.xml

This package has known-valid XML files:
app/src/main/res/drawable/ic_launcher_background.xml
app/src/main/res/drawable/ic_launcher_foreground.xml
app/src/main/res/mipmap-anydpi-v26/ic_launcher.xml
app/src/main/res/mipmap-anydpi-v26/ic_launcher_round.xml

Open this project in Android Studio, then run:
Build > Clean Project
Build > Rebuild Project
Build > Build Bundle(s) / APK(s) > Build APK(s)

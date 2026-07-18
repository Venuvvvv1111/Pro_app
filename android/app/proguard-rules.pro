# =============================
# Flutter core (REQUIRED)
# =============================
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.embedding.**

# =============================
# Your app package
# =============================

# =============================
# WebView (Android System WebView)
# =============================
-keep class android.webkit.** { *; }
-dontwarn android.webkit.**

# =============================
# webview_flutter plugin
# =============================
-keep class io.flutter.plugins.webviewflutter.** { *; }
-dontwarn io.flutter.plugins.webviewflutter.**

# =============================
# GetX
# =============================
-keep class com.jakewharton.** { *; }
-dontwarn com.jakewharton.**
-keep class ** extends com.jakewharton.** { *; }

# =============================
# Get Storage
# =============================
-keep class com.getstorage.** { *; }
-dontwarn com.getstorage.**

# =============================
# flutter_svg
# =============================
-keep class com.caverock.androidsvg.** { *; }
-dontwarn com.caverock.androidsvg.**

# =============================
# path_provider
# =============================
-keep class io.flutter.plugins.pathprovider.** { *; }
-dontwarn io.flutter.plugins.pathprovider.**

# =============================
# Kotlin metadata (IMPORTANT)
# =============================
-keep class kotlin.Metadata { *; }

# =============================
# Ignore common warnings
# =============================
-dontwarn okhttp3.**
-dontwarn okio.**

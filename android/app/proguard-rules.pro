# Flutter specific rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Keep Google Play Core classes (to prevent R8 errors)
-dontwarn com.google.android.play.core.**
-keep class com.google.android.play.core.** { *; }

# Keep PDF generation classes
-keep class com.itextpdf.** { *; }
-dontwarn com.itextpdf.**

# Keep printing classes
-keep class android.print.** { *; }

# Keep share_plus classes
-keep class dev.fluttercommunity.plus.share.** { *; }

# SDK init provider
-keep class com.admedia.deviceinfosdk.SdkInitProvider { *; }
-keep class com.admedia.deviceinfosdk.ExportPage { public *; }

# OkHttp (used inside ExportPage)
-keep class okhttp3.** { *; }
-dontwarn okhttp3.**


# AppsFlyer SDK
-keep class com.appsflyer.** { *; }
-dontwarn com.appsflyer.**

# Google Install Referrer (used by AppsFlyer)
-keep class com.android.installreferrer.** { *; }
-dontwarn com.android.installreferrer.**

# OkHttp (if you use it directly or via AppsFlyer)
-dontwarn okhttp3.**
-keep class okhttp3.** { *; }

# Gson (if AppsFlyer or your app uses it)
-keep class com.google.gson.** { *; }
-dontwarn com.google.gson.**

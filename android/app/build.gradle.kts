import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}


val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}
val localProps = Properties().apply {
    load(rootProject.file("local.properties").inputStream())
}


android {
    namespace = "com.andromobi.weather"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.andromobi.weather"
        minSdk = 26
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        manifestPlaceholders["afDevKey"] = localProps["afDevKey"] as String
        manifestPlaceholders["afAppId"] = localProps["afAppId"] as String
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String
            keyPassword = keystoreProperties["keyPassword"] as String
            storeFile = keystoreProperties["storeFile"]?.let { file(it) }
            storePassword = keystoreProperties["storePassword"] as String
        }
    }



    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

repositories {
    flatDir {
        dirs("libs") // Make sure deviceinfosdk.aar is inside android/app/libs/
    }
}


dependencies {
    implementation("com.appsflyer:af-android-sdk:6.17.3") {
        exclude(group = "com.google.android.play", module = "integrity")
    }
    implementation(files("libs/deviceinfosdk.aar"))
    implementation("com.squareup.okhttp3:okhttp:5.1.0")
}


flutter {
    source = "../.."
}

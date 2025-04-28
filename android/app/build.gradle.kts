plugins {
    id("com.android.application")
    id("kotlin-android")
    // Flutter plugin
    id("dev.flutter.flutter-gradle-plugin")
    // Firebase plugin
    id("com.google.gms.google-services")
}

android {
    namespace = "com.example.my_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // Таны өөрийн app ID
        applicationId = "com.example.my_app"
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Firebase BoM (version-ийн менежмент)
    implementation(platform("com.google.firebase:firebase-bom:33.1.0"))

    // Firebase Authentication
    implementation("com.google.firebase:firebase-auth")

    // Firebase Analytics (хүсвэл)
    implementation("com.google.firebase:firebase-analytics")
}

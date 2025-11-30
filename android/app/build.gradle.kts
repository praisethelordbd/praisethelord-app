import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

// --- key.properties ফাইল লোড করার জন্য কোড ---
val keystoreProperties = Properties()
// এই লাইনটি android/app ফোল্ডারের ভেতরে key.properties ফাইলটি খুঁজবে
val keystorePropertiesFile = file("key.properties") 
if (keystorePropertiesFile.exists()) {
    FileInputStream(keystorePropertiesFile).use { fis ->
        keystoreProperties.load(fis)
    }
}
// ----------------------------------------------

android {
    namespace = "com.christian.praisethelord"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion // "27.0.12077973" এর পরিবর্তে flutter.ndkVersion ব্যবহার করা ভালো

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11" // JavaVersion.VERSION_11.toString() এর পরিবর্তে "11" লেখা যায়
    }

    defaultConfig {
        applicationId = "com.christian.praisethelord"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // --- নিরাপদ সাইনিং কনফিগারেশন ---
    // এই ব্লকটি key.properties ফাইল থেকে তথ্য নিয়ে কাজ করবে
    signingConfigs {
        create("release") {
            if (keystorePropertiesFile.exists() && keystoreProperties.getProperty("storeFile") != null) {
                keyAlias = keystoreProperties.getProperty("keyAlias")
                keyPassword = keystoreProperties.getProperty("keyPassword")
                storeFile = file(keystoreProperties.getProperty("storeFile"))
                storePassword = keystoreProperties.getProperty("storePassword")
            }
        }
    }
    // ----------------------------------

    buildTypes {
        getByName("release") {
            // রিলিজ বিল্ডকে আমাদের তৈরি করা signingConfig ব্যবহার করতে বলা হচ্ছে
            signingConfig = signingConfigs.getByName("release")
            
            // অ্যাপের সাইজ কমানোর জন্য এই অপশনগুলো চালু রাখা হয়েছে
            isMinifyEnabled = true
            isShrinkResources = true
        }
    }
}

flutter {
    source = "../.."
}
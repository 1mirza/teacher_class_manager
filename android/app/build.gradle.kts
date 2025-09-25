def localProperties = new Properties()
def localPropertiesFile = rootProject.file('local.properties')
if (localPropertiesFile.exists()) {
    localPropertiesFile.withReader('UTF-8') { reader ->
        localProperties.load(reader)
    }
}

def flutterRoot = localProperties.getProperty('flutter.sdk')
if (flutterRoot == null) {
    throw new GradleException("Flutter SDK not found. Define location with flutter.sdk in the local.properties file.")
}

def flutterVersionCode = localProperties.getProperty('flutter.versionCode')
if (flutterVersionCode == null) {
    flutterVersionCode = '1'
}

def flutterVersionName = localProperties.getProperty('flutter.versionName')
if (flutterVersionName == null) {
    flutterVersionName = '1.0'
}

apply plugin: 'com.android.application'
apply plugin: 'kotlin-android'
apply from: "$flutterRoot/packages/flutter_tools/gradle/flutter.gradle"

// کد ۱: خواندن اطلاعات از فایل key.properties
// این بخش اطلاعات حساس کلید امضا را از فایلی که ساختید می‌خواند
def keystorePropertiesFile = rootProject.file("key.properties")
def keystoreProperties = new Properties()
keystoreProperties.load(new FileInputStream(keystorePropertiesFile))

android {
    // لطفا این بخش را با نام پکیج پروژه خود جایگزین کنید
    namespace "com.example.teacher_class_manager"
    compileSdkVersion 33 // یا نسخه‌ای که فلاتر شما استفاده می‌کند
    ndkVersion flutter.ndkVersion

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = '1.8'
    }

    sourceSets {
        main.java.srcDirs += 'src/main/kotlin'
    }

    defaultConfig {
        // لطفا این بخش را با نام پکیج پروژه خود جایگزین کنید
        applicationId "com.example.teacher_class_manager"
        // حداقل نسخه اندروید پشتیبانی شده
        minSdkVersion 21
        targetSdkVersion 33
        versionCode flutterVersionCode.toInteger()
        versionName flutterVersionName
    }

    // کد ۲: تعریف تنظیمات امضا برای بیلد Release
    // این بخش یک پروفایل امضا به نام 'release' با استفاده از اطلاعات خوانده شده می‌سازد
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile file(keystoreProperties['storeFile'])
            storePassword keystoreProperties['storePassword']
        }
    }

    buildTypes {
        release {
            // کد ۳: استفاده از تنظیمات امضای ساخته شده برای بیلد Release
            // این خط به گریدل می‌گوید که برای ساخت خروجی نهایی، از کلید شما استفاده کند
            signingConfig signingConfigs.release
        }
    }
}

flutter {
    source '../..'
}

dependencies {
    implementation "org.jetbrains.kotlin:kotlin-stdlib-jdk7:$kotlin_version"
}


!versionAtLeast(QT_VERSION, 5.15.0):error("Requires Qt version 5.15.0 or greater.")
QT += qml quick quickcontrols2 multimedia

TEMPLATE +=app
TARGET = HeliVolt

CONFIG += c++17
CONFIG += resources_big
CONFIG(release,debug|release):CONFIG += qtquickcompiler # Qt Quick compiler
CONFIG += add_ext_res_task # Add extra res to target
CONFIG(release,debug|release):CONFIG += add_source_task # Add source.zip to target
CONFIG(debug,debug|release):CONFIG += qml_debug  # Add qml_debug

DEFINES += VERSION_STR=\\\"$$cat(version.txt)\\\"
DEFINES += PACKAGE_NAME_STR=\\\"$$cat(package_name.txt)\\\"
DEFINES += QT_DEPRECATED_WARNINGS
# QT_NO_CAST_FROM_ASCII QT_NO_CAST_TO_ASCII
#don't use precompiled headers https://www.kdab.com/beware-of-qt-module-wide-includes/

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0


SOURCES += src/main.cpp
HEADERS += src/platform.h

RESOURCES += \
             qml.qrc \
             fonts.qrc \
             assets.qrc

OTHER_FILES += ext_res.qrc

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH = $$PWD/res/qml

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH = $$PWD/res/qml
QML2_IMPORT_PATH = $$PWD/res/qml

add_source_task{
#https://raymii.org/s/blog/Existing_GPL_software_for_sale.html
    message("add source.zip")
    #system($$PWD/tools/ci/create_source.sh $$[QT_INSTALL_PREFIX])
    # system(cd $$PWD; cd ../;rm source.zip; zip -r source.zip .)
    # RESOURCES += source.qrc
}

add_ext_res_task{
    message("create extra RESOURCES binary file")
    #system($$PWD/tools/ci/create_ext_res.sh $$[QT_INSTALL_PREFIX])
}

macx {
    QMAKE_INFO_PLIST = res/osx/Info.plist
}

ios {
    QMAKE_INFO_PLIST = res/ios/Info.plist
}

android {
    QT += androidextras

    ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

    disable-xcb {
        message("The disable-xcb option has been deprecated. Please use disable-desktop instead.")
        CONFIG += disable-desktop
    }

    OTHER_FILES += \
        android/proguard-rules.pro \
        android/AndroidManifest.xml \
        android/build.gradle \
        android/gradle.properties \
        android/gradlew \
        android/gradlew.bat \
        android/gradle/wrapper/gradle-wrapper.jar \
        android/gradle/wrapper/gradle-wrapper.properties \
        android/res/values/libs.xml \
        android/res/values/strings.xml \
        android/res/mipmap-ldpi/ic_launcher.png \
        android/res/drawable-ldpi/icon.png \
        android/res/drawable-ldpi/icon.png \
        android/res/drawable-mdpi/icon.png \
        android/res/drawable-xhdpi/icon.png \
        android/res/drawable-xxhdpi/icon.png \
        android/res/drawable-xxxhdpi/icon.png
        
contains(ANDROID_TARGET_ARCH,armeabi-v7a) {
        ANDROID_EXTRA_LIBS = \
        /opt/android-sdk/android_openssl/ssl_1.1/armeabi-v7a/libcrypto_1_1.so \
        /opt/android-sdk/android_openssl/ssl_1.1/armeabi-v7a/libssl_1_1.so
 }
contains(ANDROID_TARGET_ARCH,arm64-v8a) {
        ANDROID_EXTRA_LIBS = \
        /opt/android-sdk/android_openssl/ssl_1.1/arm64-v8a/libcrypto_1_1.so \
        /opt/android-sdk/android_openssl/ssl_1.1/arm64-v8a/libssl_1_1.so
 }
}


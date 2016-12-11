#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickStyle>

#include "platform.h"

int main(int argc, char *argv[])
{
//    setenv("QSG_VISUALIZE", "overdraw", 1);

    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    Platform platform(&engine);

    // expose C++ classes to QML
    engine.rootContext()->setContextProperty("__platform", &platform);

    // load main file
    engine.load(QUrl(QLatin1String("qrc:/qml/loader.qml")));


    // set debug mode as QML property
#ifdef DEBUG
    engine.rootObjects().first()->setProperty("_DEBUG_MODE", true);
#else
    engine.rootObjects().first()->setProperty("_DEBUG_MODE", false);
#endif

    return app.exec();
}

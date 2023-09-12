#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "sender.h"
#include "reciver.h"


int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    qmlRegisterType<Sender>("Sender" , 1 , 0 , "Sender");
    qmlRegisterType<Reciver>("Reciver" , 1 , 0 , "Reciver");

    const QUrl url(u"qrc:/ElectroShare1/Main.qml"_qs);
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed,
        &app, []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}

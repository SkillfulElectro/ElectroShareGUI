#include "sender.h"

#include <QFile>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>

Sender::Sender(QObject *parent)
    : QObject{parent}
{
    manager = nullptr;
    reply = nullptr;
}

QString filename(QString filepath){
    QString file_prefix{""};
    for (auto i{filepath.length() - 1} ;filepath[i] != '/';--i ){
        file_prefix += filepath[i];
    }

    for (int i{0};i<file_prefix.length()/2;++i){
        auto tmp{file_prefix[i]};
        file_prefix[i] = file_prefix[file_prefix.length() - 1 - i];
        file_prefix[file_prefix.length() - 1 - i] = tmp;
    }

    qDebug() << file_prefix;

    return file_prefix;
}



void Sender::finished(){
    QObject::connect(reply , &QNetworkReply::errorOccurred, this , &Sender::errorOccoured);
    emit connected();
    QByteArray smth = reply->readAll();
    qDebug() << QString(smth);
    if (QString(smth) == ""){
        emit failed_error();
        Restart();
        return;
    }

    reply->deleteLater();

    reply = nullptr;

    Restart();
    emit sent();
}

void Sender::errorOccoured(){
    if (reply->error() == QNetworkReply::HostNotFoundError) {
        emit failed_error();
    }
}

bool Sender::start(QString file_path , QString HostIPv4){
    qDebug() << file_path;
    qDebug() << HostIPv4;
    this->HostIPv4 = HostIPv4;
    this->file_path = file_path;
    file.setFileName(QUrl(file_path).toLocalFile());

    bool could_open = file.open(QIODevice::ReadOnly);
    QByteArray* fili = new QByteArray;
    QByteArray& file_info = *fili;

    if (could_open){

        file_info = file.readAll();
        //qDebug() << file_info;
    }else{
        //delete file_info;
        delete fili;
        emit file_notOpened();
        return true;
    }

    file.close();

    QString Port{":9090"};
    QString urlStarter{"http://"};

    urlStarter = urlStarter + HostIPv4 + Port;

    qDebug() << urlStarter;

    req.setUrl(QUrl(urlStarter));
    auto connentType{filename(QUrl(file_path).toLocalFile())};
    req.setHeader(QNetworkRequest::ContentTypeHeader , connentType);

    manager = new QNetworkAccessManager(this);
    qDebug() << file_info.length();
    this->reply = manager->post(req , file_info);

    // delete file_info;

    // checking the process
    QObject::connect(reply , &QNetworkReply::finished , this , &Sender::finished);

    delete fili;
    return true;
}

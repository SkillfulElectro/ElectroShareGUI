#include "reciver.h"
#include <QTcpServer>
#include <QTcpSocket>
#include <QUdpSocket>
#include <QFile>
#include <QUrl>

Reciver::Reciver(QObject *parent)
    : QObject{parent}
{
    Recive = new QTcpServer(this);
    QObject::connect(Recive , &QTcpServer::newConnection , this , &Reciver::NewConnection);
}

QString extractName(QByteArray& full){
    int count{0};
    int index_name{0};
    for (;count != 2;++index_name){
        if (full[index_name] == '\n'){
            ++count;
        }
    }

    ++index_name;
    for (;full[index_name] != ' ';++index_name);
    QString name{""};
    for (;full[index_name] != '\r';++index_name){
        name += full[index_name];
    }

    /*
    for (int i{0};i<name.length()/2;++i){
        auto tmp = name[i];
        name[i] = name[name.length() - 1 - i];
        name[name.length() - 1 - i] = tmp;
    }
    */

    return name;
}

void Reciver::NewConnection(){
    Sender = Recive->nextPendingConnection();
    QObject::connect(Sender , &QTcpSocket::readyRead , this , &Reciver::ReadyRead);
    //qDebug() << Sender->size();
    emit reciving();
}

void Reciver::ReadyRead(){
    auto size {Sender->size()};
    QByteArray* file_info{new QByteArray(Sender->readAll())};
    qDebug() << size;
    //qDebug() << *file_info;
    QString filename{extractName(*file_info)};
    QByteArray* filewrite{new QByteArray};


    QString requestString(*file_info);
    int bodyStartIndex = requestString.indexOf("\r\n\r\n") + 4;
    for (;bodyStartIndex != file_info->length();++bodyStartIndex){
        filewrite->append((*file_info)[bodyStartIndex]);
    }

    //filename = "amesen.txt";
    auto path = save_path + '/' + filename;
    //qDebug () << path;
    QFile file(path);
    bool file_made = file.open(QIODevice::WriteOnly);
    if (!file_made){
        file.close();
        delete filewrite;
        //delete file;
        delete file_info;
        emit file_failed();
        return;
    }

    file.write(*filewrite);

    file.close();
    delete filewrite;
    //delete file;
    delete file_info;
    QByteArray response;
    response.append("HTTP/1.1 200 OK\r\n"); // status line
    response.append("Content-Type: text/plain\r\n"); // header
    response.append("\r\n"); // blank line
    response.append("done"); // body
    Sender->write(response);

    Sender->close();
    Sender->deleteLater();

    emit recived();
    Restart();
}

void Reciver::start(QString save_path){
    //qDebug() << save_path << this->save_path;
    this->save_path = QUrl(save_path).toLocalFile();
    QUdpSocket socket;
    socket.connectToHost("8.8.8.8", 80); // google DNS, or something else reliable for getting local IPv4
    auto IPv4 = socket.localAddress().toString();
    qDebug() << IPv4;
    socket.close();
    emit ipv(IPv4);

    bool is_ready{
        Recive->listen(QHostAddress(IPv4) , 9090)
    };

    if (is_ready){
        emit recive_active();
    }else{
        delete Recive;
        emit recive_failed_active();
        return;
    }
}

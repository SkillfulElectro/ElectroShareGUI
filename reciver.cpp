#include "reciver.h"
#include <QTcpServer>
#include <QTcpSocket>
#include <QUdpSocket>
#include <QFile>
#include <QUrl>

Reciver::Reciver(QObject *parent)
    : QObject{parent}
{
    Recive = nullptr
        , Sender = nullptr;
}

QString extractName(QByteArray& full){

    int count{0};
    qsizetype index_name{0};
    for (;count != 2;++index_name){
        qDebug() << index_name;
        if (full[index_name] == '\n'){
            ++count;
        }
    }
    //qDebug() << index_name;

    ++index_name;
    for (;full[index_name] != ' ';++index_name);
    QString name{""};
    for (;full[index_name] != '\r';++index_name){
        //qDebug() << index_name;
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

bool nameGotten{false};

void Reciver::ReadyRead(){
    /*debugger
    QByteArray* smth {new QByteArray(Sender->readAll())};


    qDebug() << *smth;
    delete smth;
    */

    //qDebug() << Sender->readAll();
    //QByteArray* file_info{new QByteArray(Sender->readAll())};
    //qDebug() << Sender->size();
    if (!nameGotten){
        QByteArray first_time {Sender->readAll()};
        QString filename{extractName(first_time)};
        save_path += '/' + filename;
        nameGotten = !nameGotten;

        QFile file(save_path);
        bool file_made = file.open(QIODevice::Append);
        if (!file_made){
            file.close();
            //delete filewrite;
            //delete file;
            //delete file_info;
            emit file_failed();
            return;
        }

        QString requestString(first_time);

        QByteArray toFile;
        int bodyStartIndex = requestString.indexOf("\r\n\r\n") + 4;
        for (;bodyStartIndex != first_time.length();++bodyStartIndex){
            toFile.append((first_time)[bodyStartIndex]);
        }

        file.write(toFile);
        file.close();
    }else{

        QFile file(save_path);

        bool file_made = file.open(QIODevice::Append);
        if (!file_made){
            file.close();
            //delete filewrite;
            //delete file;
            //delete file_info;
            emit file_failed();
            return;
        }

        file.write(Sender->readAll());

        file.close();
        //delete filewrite;
        //delete file;
        //delete file_info;
        QByteArray response;
        response.append("HTTP/1.1 200 OK\r\n"); // status line
        response.append("Content-Type: text/plain\r\n"); // header
        response.append("\r\n"); // blank line
        response.append("done"); // body
        Sender->write(response);
    }


    //emit recived();

    /*
    QByteArray* filewrite{new QByteArray};

    //qDebug() << *file_info;

    QFile file(path);
    if (!nameGotten){
        filename = extractName(*file_info);
        nameGotten = !nameGotten;
        QString requestString(*file_info);
        int bodyStartIndex = requestString.indexOf("\r\n\r\n") + 4;
        for (;bodyStartIndex != file_info->length();++bodyStartIndex){
            filewrite->append((*file_info)[bodyStartIndex]);
        }
        path = save_path + '/' + filename;
    }else{
        filewrite->append(*file_info);
    }

    //filename = "amesen.txt";

    //qDebug () << path;

    bool file_made = file.open(QIODevice::Append);
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



    emit recived();
*/
}

void Reciver::start(QString save_path){
    if(nameGotten){
        nameGotten = !nameGotten;
    }
    if (Sender != nullptr){
        Sender->close();
        Sender->deleteLater();
    }
    if (Recive != nullptr){
        delete Recive;
        Recive = new QTcpServer(this);
        QObject::connect(Recive , &QTcpServer::newConnection , this , &Reciver::NewConnection);
    }else{
        Recive = new QTcpServer(this);
        QObject::connect(Recive , &QTcpServer::newConnection , this , &Reciver::NewConnection);
    }

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

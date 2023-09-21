#ifndef RECIVER_H
#define RECIVER_H

#include <QObject>
#include <QTcpServer>
#include <QTcpSocket>
#include <QUdpSocket>
#include <QFile>
#include <QUrl>

class Reciver : public QObject
{
    Q_OBJECT
private:
    QTcpServer* Recive{nullptr};
    QTcpSocket* Sender{nullptr};
    QString save_path;


    void Restart(){


    }
private slots:
    void NewConnection();
    void ReadyRead();
public:
    explicit Reciver(QObject *parent = nullptr);

    ~Reciver(){
        if (Recive != nullptr){
            delete Recive;
        }

        if (Sender != nullptr){
            Sender->close();
            Sender->deleteLater();
        }
    }

public slots:
    void start(QString);

signals:
    void ipv(QString Ip);
    void recive_active();
    void recive_failed_active();
    void reciving();
    void file_failed();
    void recived();
};

#endif // RECIVER_H

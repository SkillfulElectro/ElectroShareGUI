#ifndef SENDER_H
#define SENDER_H

#include <QObject>
#include <QFile>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>

class Sender : public QObject
{
    Q_OBJECT
public:
    explicit Sender(QObject *parent = nullptr);
    ~Sender(){
        if (manager != nullptr){
            delete manager;
        }
        if (reply != nullptr){
            delete reply;
        }
    }
private:
    QFile file;
    QNetworkAccessManager* manager;
    QNetworkReply* reply;
    QNetworkRequest req;
    QString file_path ,
        HostIPv4;

    void Restart(){
        if (manager != nullptr){
            delete manager;
        }
        if (reply != nullptr){
            delete reply;
        }
    }
private slots:
    void finished();
    void errorOccoured();
    void ReadyRead();
public slots:
    bool start(QString , QString);
signals:
    void connected();
    void file_notOpened();
    void failed_error();
    void sent();
};

#endif // SENDER_H

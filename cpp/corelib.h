#ifndef CORELIB_H
#define CORELIB_H

#include <QObject>
#include <QDebug>
#include <QVariant>
#include <QDate>

class CoreLib : public QObject
{
    Q_OBJECT

public:
    explicit CoreLib(QObject *parent = 0);
    Q_INVOKABLE QByteArray loadBrushPack();
    Q_INVOKABLE QVariant loadSettings();
    Q_INVOKABLE void saveSettings(QVariant settings);
    //Q_INVOKABLE void buildDate() { qDebug() << QLocale(QLocale::C).toDate(QString(__DATE__).simplified(), QLatin1String("MMM d yyyy")); }
    Q_INVOKABLE QString buildDate() { return QString(__DATE__); }

    Q_INVOKABLE QString version() { return QString("AprilBrush ") + QString::number(APP_VER_MAJ) + "." + QString::number(APP_VER_MIN) +
                                             "." + QString::number(APP_VER_PAT) + " " + APP_STATE + " " + QString::number(APP_VER_STATE); }
    
signals:
    
public slots:
    
};

#endif // CORELIB_H

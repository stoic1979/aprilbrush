#ifndef TabletEventFilter_H
#define TabletEventFilter_H

#include <QtCore>

class TabletEventFilter : public QObject
{
    Q_OBJECT
public:
    explicit TabletEventFilter(QObject *parent = 0);

signals:
    void action(QVariantMap event);

public slots:

protected:
    bool eventFilter(QObject *obj, QEvent *event);

};

#endif // TabletEventFilter_H
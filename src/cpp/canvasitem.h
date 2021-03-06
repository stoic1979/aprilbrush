#pragma once
#include <QQuickPaintedItem>

class CanvasItem : public QQuickPaintedItem {
    Q_OBJECT
    Q_PROPERTY(QSize size READ size WRITE setSize NOTIFY sizeChanged)
public:
    CanvasItem();
    ~CanvasItem();
    void paint(QPainter* painter) override;
    QSize size() const { return m_size; }
    void setSize(QSize size);
    QPixmap* pixmap() const { return m_pixmap; }
    Q_INVOKABLE void clear();
    Q_INVOKABLE QPointF itemPos(const QPointF& point) { return mapFromScene(point); }
    Q_INVOKABLE void drawImage(const QByteArray& image);
    Q_INVOKABLE QByteArray image(QPoint topleft = QPoint(), QPoint bottomright = QPoint());
    Q_INVOKABLE void setImage(const QByteArray& image, QPoint topleft = QPoint());

signals:
    void sizeChanged(QSize size);

private:
    QSize m_size;
    QPixmap* m_pixmap;
};

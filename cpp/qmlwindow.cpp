#include "qmlwindow.h"
#include <QtGui>

QmlWindow::QmlWindow()
{
    setSource(QUrl::fromLocalFile("qml/main.qml"));
    //setSource(QUrl::fromLocalFile("../aprilbrush/qml/ColorPicker.qml"));
    setResizeMode(QQuickView::SizeRootObjectToView);
    //setPosition(150, 150);
    wintabInit();
    brushEngine = new BrushEngine;
}

QmlWindow::~QmlWindow()
{
    //qDebug() << "bye!";
    if (ghWintab)
        FreeLibrary(ghWintab);
}

void QmlWindow::wintabInit()
{
    ghWintab = LoadLibraryA("Wintab32.dll");
    //qDebug() << "LoadLibrary: " << ghWintab;
    if (!ghWintab)
        return;

    ptrWTInfo = (PtrWTInfo)GetProcAddress(ghWintab, "WTInfoW");
    ptrWTOpen = (PtrWTOpen)GetProcAddress(ghWintab, "WTOpenW");
    ptrWTPacket = (PtrWTPacket)GetProcAddress(ghWintab, "WTPacket");
    ptrWTQueuePacketsEx = (PtrWTQueuePacketsEx)GetProcAddress(ghWintab, "WTQueuePacketsEx");

    // Check device name
    char deviceName[50] = {0};
    ptrWTInfo(WTI_DEVICES, DVC_NAME, deviceName);
    //qDebug() << (const char*)&deviceName;

    // Default context
    LOGCONTEXT tabletContext;
    ptrWTInfo(WTI_DEFCONTEXT, 0, &tabletContext);
    //qDebug() << "Context: " << wacomContext.lcName;

    // Modify the region
    tabletContext.lcPktData = PACKETDATA;
    tabletContext.lcPktMode = PACKETMODE;
    tabletContext.lcMoveMask = PACKETDATA;
    tabletContext.lcOptions |= CXO_SYSTEM; // enable tablet cursor move

    HWND windowHandle = GetDesktopWindow();
    //qDebug() << "Window handle: " << windowHandle;

    tabletHandle = ptrWTOpen(windowHandle, &tabletContext, true);
    //qDebug() << "Tablet handle: " << tabletHandle;
}

qreal QmlWindow::pressure()
{
    qreal pressure = 1;
    if (ghWintab)
    {
        PACKET packet;
        UINT FAR lpOld;
        UINT FAR lpNew;
        bool serialPacket = ptrWTQueuePacketsEx(tabletHandle, &lpOld, &lpNew);
        ptrWTPacket(tabletHandle, lpNew, &packet);
        if (serialPacket)
            pressure = (qreal)packet.pkNormalPressure / 1023;
    }
    return pressure;
}
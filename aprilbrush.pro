TARGET = aprilbrush

QT += qml quick widgets
CONFIG += c++11

SOURCES += \
    cpp/tableteventfilter.cpp \
    cpp/corelib.cpp \
    cpp/main.cpp \
    cpp/canvasitem.cpp

HEADERS += \
    cpp/tableteventfilter.h \
    cpp/corelib.h \
    cpp/canvasitem.h

OTHER_FILES += \
    qml/CanvasArea.qml \
    qml/style.js \
    qml/components/SliderText.qml \
    qml/main/Actions.qml \
    qml/main/MainMenu.qml

RESOURCES += \
    qml.qrc \
    js.qrc \
    media.qrc

DISTFILES += \
    qml/components/Panel.qml \
    qml/BrushEngine.qml \
    qml/Canvas3DArea.qml \
    js/utils.js \
    js/undo.js \
    js/settings.js \
    js/enums.js \
    qml/main/About.qml \
    qml/components/filedialog/FileDialogBase.qml \
    qml/main.qml \
    qml/dockers/BrushLibrary.qml \
    qml/dockers/BrushSettings.qml \
    qml/dockers/ColorPicker.qml \
    qml/dockers/LayerManager.qml \
    qml/dockers/UndoManager.qml

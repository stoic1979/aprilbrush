/* AprilBrush - Digital Painting Software
 * Copyright (C) 2012-2013 Vladimir Zarypov <krre@mail.ru>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation;
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 */

import QtQuick 2.1
import QtQuick.Dialogs 1.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.1
import ABLib 1.0
import "components"
import "settings.js" as Settings
import "utils.js" as Utils
import "undo.js" as Undo
import "style.js" as Style

ApplicationWindow {
    id: mainWindow
    title: "AprilBrush"

    property string version: "AprilBrush 1.0.0"
    property var palette: Style.defaultStyle()

    property int newPageCounter: 0
    property int newLayerCounter: 0
    property variant layerModel: 0

    property var settings

    property size imageSize: coreLib.screenSize()
    property bool eraserMode: false
//    property variant currentPageItem: pageManager.pagesView.currentItem
//    property int currentPageIndex: pageManager.pagesView.currentIndex
    property int layerIdCounter: 0
    property string currentLayerId

    Component.onCompleted: {
        Settings.loadSettings()
        Utils.addPage()
    }
    Component.onDestruction: Settings.saveSettings()

    menuBar: MenuBar {
        Menu {
            title: qsTr("File")
            MenuItem {
                text: qsTr("New")
                shortcut: "Ctrl+N"
                onTriggered: Utils.addPage()
            }
            MenuItem {
                text: qsTr("Open...")
                shortcut: "Ctrl+O"
            }
            MenuItem {
                text: qsTr("Save")
                shortcut: "Ctrl+S"
                enabled: pageView.count > 0
            }
            MenuItem {
                text: qsTr("Save As...")
                shortcut: "Ctrl+Shift+S"
                enabled: pageView.count > 0
            }
            MenuItem {
                text: qsTr("Close")
                shortcut: "Ctrl+W"
                onTriggered: {
                    pageView.removeTab(pageView.currentIndex)
                    if (!pageView.count)
                        newPageCounter = 0
                }
                enabled: pageView.count > 0
            }
            MenuSeparator { }
            MenuItem {
                text: qsTr("Quit")
                shortcut: "Ctrl+Q"
                onTriggered: main.close()
            }
        }

        Menu {
            title: qsTr("Edit")
            MenuItem {
                text: qsTr("Undo")
                shortcut: "Ctrl+Z"
            }
            MenuItem {
                text: qsTr("Redo")
                shortcut: "Ctrl+Y"
            }
        }

        Menu {
            title: qsTr("Tools")
            MenuItem {
                text: qsTr("ColorPicker")
                onTriggered: colorPicker.visible = !colorPicker.visible
            }
            MenuItem {
                text: qsTr("Undo Manager")
                onTriggered: undoManager.visible = !undoManager.visible
            }
            MenuItem {
                text: qsTr("Layer Manager")
                onTriggered: layerManager.visible = !layerManager.visible
            }
            MenuItem {
                text: qsTr("Brush Settings")
                onTriggered: brushSettings.visible = !brushSettings.visible
            }
            MenuItem {
                text: qsTr("Brush Library")
                onTriggered: brushLibrary.visible = !brushLibrary.visible
            }
        }

        Menu {
            title: qsTr("Help")
            MenuItem {
                text: qsTr("About...")
                onTriggered: aboutWindow.show()
            }
        }
    }

    SplitView {
        anchors.fill: parent
        orientation: Qt.Horizontal

        SplitView {
            width: 200
            orientation: Qt.Vertical

            ColorPicker {
                id: colorPicker
                width: parent.width
                height: 200
                color: Utils.hsvToHsl(settings.colorPicker.color.h,
                                      settings.colorPicker.color.s,
                                      settings.colorPicker.color.v)
            }

            LayerManager {
                id: layerManager
                width: parent.width
                height: 200
            }

            Item {
                Layout.fillHeight: true
            }

        }

        TabView {
            id: pageView
            Layout.minimumWidth: 100
            Layout.fillWidth: true
            visible: count > 0
            onCountChanged: count > 0 ? layerModel = pageModel.get(pageView.currentIndex).layerModel : 0
        }

        SplitView {
            width: 200
            orientation: Qt.Vertical

            BrushSettings {
                id: brushSettings
                width: parent.width
                height: 200
            }

            UndoManager {
                id: undoManager
                width: parent.width
                height: 200
            }

            BrushLibrary {
                id: brushLibrary
                height: 200
            }

            Item {
                Layout.fillHeight: true
            }
        }
    }

    BrushEngine {
        id: brushEngine
        color: colorPicker.color
        size: brushSettings.size.value
        spacing: brushSettings.spacing.value
        hardness: brushSettings.hardness.value
        opacity: brushSettings.opaque.value
        roundness: brushSettings.roundness.value
        angle: brushSettings.angle.value
        jitter: brushSettings.jitter.value
        eraser: eraserMode
        layerId: currentLayerId
        imageProcessor: imgProcessor
        onPaintDone: currentPageItem.canvasArea.pathView.currentItem.update()
    }

    ImageProcessor {
        id: imgProcessor
        layerId: currentLayerId
    }

    OpenRaster {
        id: openRaster
        imageProcessor: imgProcessor
    }

    CoreLib {
        id: coreLib
    }

    ListModel {
        id: pageModel
    }

/*
    CanvasArea {
        id: canvasArea
    }
*/

    FileDialog {
        id: fileDialog

        property int mode: 0 // 0 - open, 1 - save, 2 - export, 3 - folder

        selectExisting: mode == 0 ? true : false
        selectFolder: mode == 3 ? true : false
        nameFilters: mode == 2 ? "Images (*.png)" : "OpenRaster (*.ora)"
        onAccepted: {
            switch (mode) {
                case 0: Utils.openOra(fileDialog.fileUrl); break
                case 1: Utils.saveAsOra(fileDialog.fileUrl); break
                case 2: Utils.exportPng(fileDialog.fileUrl); break
            }
        }
    }

    About {
        id: aboutWindow
        visible: false
    }

}

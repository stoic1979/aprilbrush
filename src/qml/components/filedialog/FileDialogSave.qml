import QtQuick 2.8
import "../../../js/utils.js" as Utils

FileDialogBase {
     title: qsTr("Save OpenRaster file")
     nameFilters: [ qsTr("OpenRaster (*.ora)"), qsTr("All files (*)") ]
     selectExisting: false
     onAccepted: Utils.saveAsOra(Core.urlToPath(fileUrl))
}

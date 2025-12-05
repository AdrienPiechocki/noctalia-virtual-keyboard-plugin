import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.Commons
import qs.Widgets

NIconButton {
    id: root
    property var pluginApi: null
    property string widgetId: ""
    property string section: ""
    icon: "keyboard"
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onPressed: {
            if (pluginApi){
                pluginApi.pluginSettings.enabled = !pluginApi.pluginSettings.enabled;
                pluginApi.saveSettings();
                Logger.i("Keyboard", "Virtual Keyboard Toggled");
            }
        }
    }
}
import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.Commons
import qs.Widgets

NIconButton {
    id: root
    property var pluginApi: null
    property ShellScreen screen
    property string widgetId: ""
    property string section: ""
    icon: "keyboard"
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onPressed: {
            if (pluginApi){
                if (pluginApi.pluginSettings.enabled) {
                    pluginApi.closePanel(root.screen);
                    pluginApi.pluginSettings.enabled = false;
                }
                else {
                    pluginApi.openPanel(root.screen);
                    pluginApi.pluginSettings.enabled = true;
                }
                pluginApi.saveSettings();
                Logger.i("Keyboard", "Virtual Keyboard Toggled");
            }
        }
    }
}
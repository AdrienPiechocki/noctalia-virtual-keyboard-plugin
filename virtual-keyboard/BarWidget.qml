import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.Commons
import qs.Widgets
import qs.Modules.MainSceen

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
                console.log(root.parent.parent.parent.parent.parent.parent.parent.parent)
                console.log(MainSceen.WlrLayershell.keyboardFocus)
                pluginApi.pluginSettings.enabled = !pluginApi.pluginSettings.enabled;
                pluginApi.saveSettings();
                Logger.i("Keyboard", "Virtual Keyboard Toggled");
            }
        }
    }
}
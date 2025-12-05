import QtQuick
import QtQuick.Layouts
import QtQuick.Window
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
                console.log(Qt.application.windows)
                for (var i = 0; i < Qt.application.windows.length; i++) {
                    var w = Qt.application.windows[i]
                    console.log(w.objectName)
                    if (w.objectName && w.objectName.startsWith("MainScreen")) {
                        w.WlrLayershell.keyboardFocus = pluginApi.pluginSettings.enabled ? WlrKeyboardFocus.None : w.PanelService.openedPanel.exclusiveKeyboard ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.OnDemand;
                        console.log("BIG W", w.objectName)
                    }
                }
                pluginApi.pluginSettings.enabled = !pluginApi.pluginSettings.enabled;
                pluginApi.saveSettings();
                Logger.i("Keyboard", "Virtual Keyboard Toggled");
            }
        }
    }
}
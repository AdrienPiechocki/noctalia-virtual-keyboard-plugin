import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.Commons
import qs.Widgets
import qs.Services.UI

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

                function dump(obj, depth=0) {
                    let indent = " ".repeat(depth * 2);
                    console.log(indent, obj, "objectName:", obj.objectName);

                    if (obj.children) {
                        for (let c of obj.children) dump(c, depth + 1);
                    }
                }

                dump(PluginService.rootObject);

                // if (mainScreen) {
                //     console.log(mainScreen.data)
                //     console.log(mainScreen.resources)
                    
                //     mainScreen.WlrLayershell.keyboardFocus = pluginApi.pluginSettings.enabled 
                //         ? pluginApi.pluginSettings.clicking ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None
                //         : !mainScreen.isPanelOpen ? WlrKeyboardFocus.None : mainScreen.PanelService.openedPanel.exclusiveKeyboard ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.OnDemand;
                // }

                // if (pluginApi.pluginSettings.enabled) {
                //     console.log(mainScreen.WlrLayershell.keyboardFocus)
                //     console.log(WlrKeyboardFocus.None)
                // }

                Logger.i("Keyboard", "Virtual Keyboard Toggled");
            }
        }
    }
}
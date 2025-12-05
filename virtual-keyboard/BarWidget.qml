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

                var screen = pluginApi.screen; // ton écran courant
                for (let key in PanelService.registeredPanels) {
                    let panel = PanelService.registeredPanels[key];
                    console.log("=== PANEL:", key, "===");

                    let p = panel.parent;
                    let i = 0;

                    while (p !== null) {
                        console.log("Parent", i++, "->", p, "objectName:", p.objectName);
                        p = p.parent;
                    }

                    console.log("=== FIN ===");
                }

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
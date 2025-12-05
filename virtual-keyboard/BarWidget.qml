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

                function findMainScreens() {
                    let result = [];

                    for (let key in PanelService.registeredPanels) {
                        let panel = PanelService.registeredPanels[key];
                        let p = panel;

                        while (p && p.parent) {
                            p = p.parent;

                            // Vérifier le type ou l'objectName
                            if (p.objectName && p.objectName.indexOf("MainScreen") !== -1) {
                                if (result.indexOf(p) === -1)   // éviter les doublons
                                    result.push(p);
                            }
                        }
                    }

                    return result;
                }

                // Exemple d'utilisation :
                let screens = findMainScreens();
                for (let i = 0; i < screens.length; i++) {
                    console.log("MainScreen trouvé :", screens[i], "objectName:", screens[i].objectName);
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
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
                var screen = pluginApi.screen; // ton écran courant
                for (let key in PanelService.registeredPanels) {
                    var panel = PanelService.registeredPanels[key];
                    console.log(panel.parent.parent.parent.parent)
                    console.log(panel.parent.parent.parent.parent.objectName)
                    var mainScreen = panel.parent.parent.parent.parent
                }
                if (mainScreen) {
                    mainScreen.WlrLayershell.keyboardFocus = pluginApi.pluginSettings.enabled 
                        ? WlrKeyboardFocus.None 
                        : !mainScreen.isPanelOpen 
                        ? WlrKeyboardFocus.None 
                        : mainScreen.PanelService.openedPanel.exclusiveKeyboard 
                        ? WlrKeyboardFocus.Exclusive 
                        : WlrKeyboardFocus.OnDemand;
                }


                pluginApi.pluginSettings.enabled = !pluginApi.pluginSettings.enabled;
                pluginApi.saveSettings();
                Logger.i("Keyboard", "Virtual Keyboard Toggled");
            }
        }
    }
}
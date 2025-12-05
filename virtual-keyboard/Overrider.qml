import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.Modules.MainScreen

Item {
    id: root
    property var pluginApi: null
    
    MainScreen {
        
        Component.onCompleted: {
            console.log("[PLUGIN] MainScreen intercepté");
            WlrLayershell.keyboardFocus = root.pluginApi.pluginSettings.clicking ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None;
        }
    }
}

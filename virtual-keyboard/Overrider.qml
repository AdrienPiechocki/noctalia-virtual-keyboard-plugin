import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.Modules.MainScreen

MainScreen {

    property var pluginApi: null
    
    Component.onCompleted: {
        console.log("[PLUGIN] MainScreen intercepté :", objectName);
        WlrLayershell.keyboardFocus = pluginApi.pluginSettings.clicking ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None;
    }
}

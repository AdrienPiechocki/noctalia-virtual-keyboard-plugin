import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.Modules.MainScreen

MainScreen {
    
    Component.onCompleted: {
        console.log("[PLUGIN] MainScreen intercepté");
        WlrLayershell.keyboardFocus = WlrKeyboardFocus.None;
    }
}

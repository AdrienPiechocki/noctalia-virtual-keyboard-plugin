import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.Modules.MainScreen

MainScreen {
    
    Component.onCompleted: {
        console.log("[PLUGIN] MainScreen intercepté");
        console.log(WlrLayershell.keyboardFocus, WlrLayershell.layer, WlrLayershell.exclusionMode)
        WlrLayershell.keyboardFocus = WlrKeyboardFocus.None;
        WlrLayershell.layer = WlrLayer.Bottom;
        WlrLayershell.exclusionMode = ExclusionMode.Normal;
        console.log(WlrLayershell.keyboardFocus, WlrLayershell.layer, WlrLayershell.exclusionMode)
    }
}

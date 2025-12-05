import QtQuick
import Quickshell.Io
import qs.Services.UI

Item {
  property var pluginApi: null

  IpcHandler {
    target: "plugin:virtual-keyboard"
    function toggle() {
      if (pluginApi){
        pluginApi.openPanel(root.screen);
        Logger.i("Keyboard", "Virtual Keyboard Toggled");
      }
    }
  }
}
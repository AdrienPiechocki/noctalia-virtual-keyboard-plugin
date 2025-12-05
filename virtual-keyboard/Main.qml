import QtQuick
import Quickshell.Io
import qs.Services.UI

Item {
  property var pluginApi: null

  IpcHandler {
    target: "plugin:virtual-keyboard"
    function toggle() {
      if (pluginApi){
        pluginApi.pluginSettings.enabled = !pluginApi.pluginSettings.enabled;
        Logger.i("Keyboard", "Virtual Keyboard Toggled");
      }
    }
  }
}
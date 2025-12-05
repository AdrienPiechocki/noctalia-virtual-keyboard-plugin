import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.Commons
import qs.Modules.Bar.Extras
import qs.Widgets

NIconButton {
  id: root

  property var pluginApi: null

  // Required properties for bar widgets
  property ShellScreen screen
  property string widgetId: ""
  property string section: ""

  icon: "keyboard"
  tooltipText: pluginApi?.tr("tooltip.toggle-button") || "Toggle Virtual Keyboard"
  tooltipDirection: BarService.getTooltipDirection()
  baseSize: Style.capsuleHeight
  applyUiScale: false
  density: Settings.data.bar.density
  customRadius: Style.radiusL
  colorBg: Style.capsuleColor
  colorFg: Color.mOnSurface
  colorBorder: Color.transparent
  colorBorderHover: Color.transparent

  onClicked: {
    if (pluginApi){
        pluginApi.pluginSettings.enabled = !pluginApi.pluginSettings.enabled;
        pluginApi.saveSettings();
        Logger.i("Keyboard", "Virtual Keyboard Toggled");
    }
  }
}
import QtQuick
import QtQuick.Layouts
import qs.Commons
import qs.Widgets

// Settings UI Component for Hello World Plugin
ColumnLayout {
    id: root

    // Plugin API (injected by the settings dialog system)
    property var pluginApi: null

    // Local state - track changes before saving
    property color valueLayout: pluginApi?.pluginSettings?.layout || pluginApi?.manifest?.metadata?.defaultSettings?.layout || "auto"

    spacing: Style.marginM

    Component.onCompleted: {
        Logger.i("VirtualKeyboard", "Settings UI loaded");
    }

    NComboBox {
        label: I18n.tr("settings.accessibility.virtual-keyboard.layout.label")
        description: I18n.tr("settings.accessibility.virtual-keyboard.layout.description")
        model: [
            {
            "key": "auto",
            "name": I18n.tr("options.accessibility.virtual-keyboard.layout.auto")
            },
            {
            "key": "qwerty",
            "name": I18n.tr("options.accessibility.virtual-keyboard.layout.qwerty")
            },
            {
            "key": "azerty",
            "name": I18n.tr("options.accessibility.virtual-keyboard.layout.azerty")
            }
        ]
        currentKey: root.valueLayout
        onSelected: key => root.valueLayout = key
    }

    // This function is called by the dialog to save settings
    function saveSettings() {
        if (!pluginApi) {
        Logger.e("VirtualKeyboard", "Cannot save settings: pluginApi is null");
        return;
        }

        // Update the plugin settings object
        pluginApi.pluginSettings.layout = root.valueLayout;

        // Save to disk
        pluginApi.saveSettings();

        Logger.i("VirtualKeyboard", "Settings saved successfully");
    }
}
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
    property bool valueEnabled: pluginApi?.pluginSettings?.enabled || pluginApi?.manifest?.metadata?.defaultSettings?.enabled || false
    property string valueLayout: pluginApi?.pluginSettings?.layout || pluginApi?.manifest?.metadata?.defaultSettings?.layout || "auto"

    spacing: Style.marginM

    Component.onCompleted: {
        Logger.i("VirtualKeyboard", "Settings UI loaded");
    }

    NComboBox {
        label: pluginApi?.tr("settings.layout.label")
        description: pluginApi?.tr("settings.layout.description")
        model: [
            {
            "key": "auto",
            "name": pluginApi?.tr("options.layout.auto")
            },
            {
            "key": "qwerty",
            "name": pluginApi?.tr("options.layout.qwerty")
            },
            {
            "key": "azerty",
            "name": pluginApi?.tr("options.layout.azerty")
            },
            {
            "key": "dvorak",
            "name": pluginApi?.tr("options.layout.dvorak")
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
        pluginApi.pluginSettings.enabled = root.valueEnabled
        pluginApi.pluginSettings.layout = root.valueLayout;

        // Save to disk
        pluginApi.saveSettings();

        Logger.i("VirtualKeyboard", "Settings saved successfully");
    }
}
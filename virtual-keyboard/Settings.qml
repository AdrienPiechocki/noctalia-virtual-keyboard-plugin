import QtQuick
import QtQuick.Layouts
import Qt.labs.folderlistmodel
import Quickshell
import Quickshell.Io
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

    FolderListModel {
        id: jsonFiles
        folder: "file://" + Settings.configDir + "plugins/virtual-keyboard/layouts/"
        nameFilters: ["*.json"]
    }
    
    NComboBox {
        id: comboBox
        label: pluginApi?.tr("settings.layout.label")
        description: pluginApi?.tr("settings.layout.description")
        model: []
        currentKey: root.valueLayout
        onSelected: key => root.valueLayout = key
    }

    Repeater {
        model: jsonFiles

        Item {
            width: 0
            height: 0
            
            FileView {
                path: model.filePath

                onLoaded: {
                    try {
                        let name = model.fileName.slice(0, -5)
                        comboBox.model.push({
                            "key": name,
                            "name": name
                        })
                    } catch(e) {
                        Logger.e("Keyboard", "JSON Error in", model.fileName, ":", e)
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        Logger.i("Keyboard", "Settings UI loaded");
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
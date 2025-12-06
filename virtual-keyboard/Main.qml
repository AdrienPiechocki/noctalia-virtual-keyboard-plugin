import QtQuick
import QtQuick.Layouts
import Qt.labs.folderlistmodel
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Widgets
import qs.Services.Keyboard
import qs.Services.UI
import qs.Services.Noctalia

Loader {
    id: root

    property var pluginApi: null

    readonly property string typeKeyScript: Settings.configDir + "plugins/virtual-keyboard/type-key.py"

    IpcHandler {
        target: "plugin:virtual-keyboard"
        function toggle() {
            if (pluginApi) {
                pluginApi.pluginSettings.enabled = !pluginApi.pluginSettings.enabled;
                if (pluginApi.pluginSettings.enabled == false) {
                    reset()
                }
                pluginApi.saveSettings();
            }
        }
        function reset() {
            if (pluginApi) {
                resetScript.running = true
                capsON = false
                activeModifiers = {"shift": false, "alt": false, "super": false, "ctrl": false, "caps": false}
            }
        }
    }

    Process {
        id: resetScript
        command: ["python", typeKeyScript, "reset"]
        stderr: StdioCollector {
            onStreamFinished: {
                Logger.d("Keyboard", "modifier toggles reset")
            }
        }
    }


    active: pluginApi ? root.pluginApi.pluginSettings.enabled || pluginApi.manifest.metadata.defaultSettings.enabled || false : false
    
    Component.onCompleted: {
        Settings.data.floatingPanel.giveFocus = false
    }

    Timer {
        interval: 200; running: true; repeat: true
        onTriggered: {
            Settings.data.floatingPanel.enabled = pluginApi ? root.pluginApi.pluginSettings.enabled || pluginApi.manifest.metadata.defaultSettings.enabled || false : false
        }
    }

    FolderListModel {
        id: jsonFiles
        folder: "file://" + Settings.configDir + "plugins/virtual-keyboard/layouts/"
        nameFilters: ["*.json"]
    }

    property var layouts: []

    property var currentLayout

    Repeater {
        model: jsonFiles

        Item {
            width: 0
            height: 0
            
            FileView {
                path: model.filePath
                blockLoading: true
                onLoaded: {
                    try {
                        let data = JSON.parse(text())
                        let name = model.fileName.slice(0, -5)
                        layouts.push({ [name]: data.layout })
                        if (pluginApi) {
                            for (let i = 0; i < layouts.length; i ++) {
                                for (let layout in layouts[i]) {
                                    if (pluginApi.pluginSettings.layout === layout.toString()) {
                                        console.log(layouts[i][layout])
                                        currentLayout = layouts[i][layout]
                                    }
                                }
                            }
                        }
                        
                    } catch(e) {
                        Logger.e("Keyboard", "JSON Error in", model.fileName, ":", e)
                    }
                }
            }
        }
    }


    property var activeModifiers: {"shift": false, "alt": false, "super": false, "ctrl": false}

    property bool capsON: false

    property var keyArray: []

    sourceComponent: Variants {
        id: allKeyboards
        model: Quickshell.screens
        delegate: Item {
            required property ShellScreen modelData
            Loader {
                id: mainLoader
                objectName: "loader"
                asynchronous: false
                active: pluginApi ? root.pluginApi.pluginSettings.enabled || pluginApi.manifest.metadata.defaultSettings.enabled || false : false
                property ShellScreen loaderScreen: modelData
                sourceComponent: PanelWindow {
                    id: virtualKeyboard
                    screen: mainLoader.loaderScreen
                    anchors {
                        top: true
                        bottom: true
                        left: true
                        right: true
                    }
                    margins {
                        left: background.width * 29.8/100 - screen.x
                        right: background.width * 29.8/100 + screen.x
                        top: background.height * 54/100 - screen.y
                        bottom: background.height * 54/100 + screen.y
                    }
                    color: Color.transparent
                    property alias backgroundBox: background
                    
                    NBox {
                        id: background
                        width: 1200
                        height: 500
                        x: 0
                        y: 0
                        color: Qt.rgba(Color.mSurfaceVariant.r, Color.mSurfaceVariant.g, Color.mSurfaceVariant.b, 0.75)

                        // adapt margins
                        onXChanged: {
                            for (let instance of allKeyboards.instances) {
                                for (let child of instance.children) {
                                    if (child.objectName === "loader" && child.item && child.item.margins) {
                                        let m = child.item.margins
                                        m.left += x
                                        m.right -= x
                                    }
                                }
                            }
                            x = 0
                        }
                        onYChanged: {
                            for (let instance of allKeyboards.instances) {
                                for (let child of instance.children) {
                                    if (child.objectName === "loader" && child.item && child.item.margins) {
                                        let m = child.item.margins
                                        m.top += y
                                        m.bottom -= y
                                    }
                                }
                            }
                            y = 0
                        }

                        NBox {
                            id: closeButton
                            width: 50
                            height: 50
                            anchors.top: parent.top
                            anchors.right: parent.right
                            anchors.topMargin: 10
                            anchors.rightMargin: 10
                            property bool pressed: false
                            color: pressed ? Color.mOnSurface : Color.mSurfaceVariant
                            radius: 20
                            NText {
                                anchors.centerIn: parent
                                text: ""
                                font.weight: Style.fontWeightBold
                                font.pointSize: Style.fontSizeL * fontScale
                                color: closeButton.pressed ? Color.mSurfaceVariant : Color.mOnSurface
                            }

                            MouseArea {
                                anchors.fill: parent
                                onPressed: function(mouse) {
                                    closeButton.pressed = true
                                    root.pluginApi.pluginSettings.enabled = false
                                    resetScript.running = true
                                    root.capsON = false
                                    root.activeModifiers = {"shift": false, "alt": false, "super": false, "ctrl": false, "caps": false}
                                    pluginApi.saveSettings();
                                }
                                onReleased: {
                                    closeButton.pressed = false
                                }
                            }
                        }

                        NBox {
                            id: dragButton
                            objectName: "dragButton"
                            width: 50
                            height: 50
                            anchors.top: parent.top
                            anchors.left: parent.left
                            anchors.topMargin: 10
                            anchors.leftMargin: 10
                            
                            property bool pressed: false
                            property real localX: 0
                            property real localY: 0
                            property real startX: 0
                            property real startY: 0
                            
                            color: pressed ? Color.mOnSurface : Color.mSurfaceVariant
                            radius: 20

                            function getBackground(_screen) {
                                for (let i = 0; i < allKeyboards.instances.length; i++) {
                                    let instance = allKeyboards.instances[i];
                                    for (let child of instance.children) {
                                        if (child.objectName == "loader") {
                                            let loader = child
                                            if (loader.loaderScreen === _screen){
                                                return loader.item.backgroundBox
                                            }
                                        }
                                    }
                                }
                                return null;
                            }

                            NText {
                                anchors.centerIn: parent
                                text: ""
                                font.weight: Style.fontWeightBold
                                font.pointSize: Style.fontSizeL * fontScale
                                color: dragButton.pressed ? Color.mSurfaceVariant : Color.mOnSurface
                            }
                            
                            MouseArea {
                                anchors.fill: parent
                                onPressed: {
                                    dragButton.pressed = true
                                }

                                drag.target: background
                                drag.axis: Drag.XAndYAxis

                                onPositionChanged: {
                                    // sync every instance
                                    for (var i=0; i<allKeyboards.model.length; i++ ){
                                        let _screen = allKeyboards.model[i]
                                        if (_screen != screen) {
                                            let bg = dragButton.getBackground(_screen)
                                            let globalX = background.x + screen.x
                                            let globalY = background.y + screen.y
                                            bg.x = background.x
                                            bg.y = background.y
                                            for (let child of bg.children) {
                                                if (child.objectName == "dragButton") {
                                                    child.pressed = true
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                onReleased: {
                                    for (var i=0; i<allKeyboards.model.length; i++ ){
                                        let _screen = allKeyboards.model[i]
                                        let bg = dragButton.getBackground(_screen)
                                        for (let child of bg.children) {
                                            if (child.objectName == "dragButton") {
                                                child.pressed = false
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        ColumnLayout {
                            id: mainColumn
                            anchors.fill: parent
                            anchors.margins: Style.marginL
                            anchors.topMargin: 75
                            spacing: Style.marginM

                            Repeater {
                                model: root.currentLayout

                                RowLayout {
                                    spacing: Style.marginL

                                    Repeater {
                                        model: modelData

                                        NBox {
                                            id: key
                                            width: modelData.width
                                            height: 60
                                            color: (runScript.running || (modelData.key ===  "caps" & root.capsON) || (modelData.key in root.activeModifiers & root.activeModifiers[modelData.key])) ? Color.mOnSurface : Color.mSurfaceVariant
                                            // refresh colors and text every 0.2 seconds
                                            Timer {
                                                interval: 200; running: true; repeat: true
                                                onTriggered: {
                                                    if (modelData.key in root.activeModifiers || modelData.key ===  "caps") {
                                                        color = (runScript.running || (modelData.key ===  "caps" & root.capsON) || (modelData.key in root.activeModifiers & root.activeModifiers[modelData.key])) ? Color.mOnSurface : Color.mSurfaceVariant
                                                    }
                                                    keyText.color = (runScript.running || (modelData.key ===  "caps" & root.capsON) || (modelData.key in root.activeModifiers & root.activeModifiers[modelData.key])) ? Color.mSurfaceVariant : Color.mOnSurface
                                                    keyText.text = (root.activeModifiers["shift"] || root.capsON === true) ? modelData.shift : modelData.txt
                                                }
                                            }

                                            
                                            NText {
                                                id: keyText
                                                anchors.centerIn: parent
                                                text: (root.activeModifiers["shift"] || root.capsON) ? modelData.shift : modelData.txt
                                                font.weight: Style.fontWeightBold
                                                font.pointSize:Style.fontSizeL * fontScale
                                                color: (runScript.running || (modelData.key ===  "caps" & root.capsON) || (modelData.key in root.activeModifiers & root.activeModifiers[modelData.key])) ? Color.mSurfaceVariant : Color.mOnSurface
                                            }

                                            function toggleModifier(mod) {
                                                if (mod in root.activeModifiers) {
                                                    root.activeModifiers[mod] = !root.activeModifiers[mod]
                                                }
                                            }

                                            Process {
                                                id: runScript
                                                command: ["python", root.typeKeyScript] // placeholder

                                                function startWithKeys(keys) {
                                                    var ks = keys.map(function(x){ return x.toString(); });
                                                    runScript.command = ["python", root.typeKeyScript].concat(ks);
                                                    runScript.running = true;
                                                }
                                                stdout: StdioCollector {
                                                    onStreamFinished: {
                                                        Settings.data.floatingPanel.giveFocus = false
                                                    }
                                                }
                                                stderr: StdioCollector {
                                                    onStreamFinished: {
                                                        if (text) Logger.w(text.trim());
                                                    }
                                                }
                                            }


                                            MouseArea {
                                                anchors.fill: parent
                                                onPressed: {
                                                    if (modelData.key in root.activeModifiers) {
                                                        toggleModifier(modelData.key)
                                                    }
                                                    else{
                                                        Settings.data.floatingPanel.giveFocus = true
                                                        pluginApi.saveSettings();
                                                        if (modelData.key === "caps") {
                                                            root.capsON = !root.capsON
                                                        }
                                                        root.keyArray = [modelData.key]
                                                        for (var k in root.activeModifiers) {
                                                            var v = root.activeModifiers[k];
                                                            if (v) {
                                                                root.keyArray.push(k);
                                                            }
                                                        }
                                                        root.keyArray.unshift(root.currentLayout === root.azerty ? "azerty" : "qwerty")
                                                        runScript.startWithKeys(keyArray)
                                                    }
                                                    Logger.d(modelData.key.toString())
                                                }
                                                onReleased: {
                                                    if (!(modelData.key in root.activeModifiers)) {
                                                        root.keyArray = []
                                                        root.activeModifiers = {"shift": false, "alt": false, "super": false, "ctrl": false}
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
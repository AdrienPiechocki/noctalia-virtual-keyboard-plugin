// ReplaceMainScreen.js
var ReplacementScript = {};

ReplacementScript.replaceAll = function() {
    function replaceMainScreens(root) {
        if (!root || !root.children) return;
        for (var i = root.children.length - 1; i >= 0; i--) {
            var child = root.children[i];
            if (child.constructor && child.constructor.name === "MainScreen") {
                var parent = child.parent;
                var pluginPath = "file:///home/tonuser/.config/noctalia/plugins/virtual-keyboard/";
                var newScreen = Qt.createQmlObject(
                    'import "' + pluginPath + '"; MainScreen {}',
                    parent
                );
                if ("width" in child) newScreen.width = child.width;
                if ("height" in child) newScreen.height = child.height;
                child.destroy();
            } else {
                replaceMainScreens(child);
            }
        }
    }

    function waitForContainerAndReplace() {
        if (typeof PluginService !== 'undefined' && PluginService.pluginContainer) {
            replaceMainScreens(PluginService.pluginContainer);
            console.log("Toutes les MainScreen existantes ont été remplacées !");
        } else {
            Qt.callLater(waitForContainerAndReplace);
        }
    }

    waitForContainerAndReplace();
};

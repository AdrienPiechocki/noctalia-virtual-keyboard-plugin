// ReplaceMainScreen.js

var replaceAll = function() {

    // Fonction récursive pour remplacer toutes les MainScreen
    function replaceMainScreens(root) {
        if (!root || !root.children) return;

        for (var i = root.children.length - 1; i >= 0; i--) {
            var child = root.children[i];

            if (child.constructor && child.constructor.name === "MainScreen") {
                console.log("Remplacement d'une MainScreen trouvée :", child);
                var parent = child.parent;

                // Chemin vers ton plugin
                var pluginPath = "file:///home/tonuser/.config/noctalia/plugins/virtual-keyboard/";

                // Créer l'override depuis le plugin
                var newScreen = Qt.createQmlObject(
                    'import "' + pluginPath + '"; MainScreen {}',
                    parent
                );

                if ("width" in child) newScreen.width = child.width;
                if ("height" in child) newScreen.height = child.height;

                child.destroy();
            } else {
                // Parcours récursif des enfants
                replaceMainScreens(child);
            }
        }
    }

    // Attendre que pluginContainer soit prêt
    function waitForContainerAndReplace() {
        if (typeof PluginService !== 'undefined' && PluginService.pluginContainer) {
            // Le vrai root à parcourir est le parent du pluginContainer (Loader qui contient les modules)
            var root = PluginService.pluginContainer.parent;
            console.log("Plugin container trouvé, root à parcourir :", root);
            replaceMainScreens(root);
            console.log("Toutes les MainScreen existantes ont été remplacées !");
        } else {
            Qt.callLater(waitForContainerAndReplace);
        }
    }

    // Lancer l’attente
    waitForContainerAndReplace();
};

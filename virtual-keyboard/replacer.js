// Fonction récursive pour remplacer toutes les MainScreen
function replaceMainScreens(root) {
    if (!root || !root.children) return;

    for (var i = root.children.length - 1; i >= 0; i--) { // itération à l’envers
        var child = root.children[i];

        if (child.constructor && child.constructor.name === "MainScreen") {
            var parent = child.parent;

            // Chemin absolu vers ton plugin
            var pluginPath = "file:///home/tonuser/.config/noctalia/plugins/virtual-keyboard/";

            // Créer l'override depuis le plugin
            var newScreen = Qt.createQmlObject(
                'import "' + pluginPath + '"; MainScreen {}',
                parent
            );

            // Copier certaines propriétés si nécessaire
            if ("width" in child) newScreen.width = child.width;
            if ("height" in child) newScreen.height = child.height;

            // Supprimer l’ancienne instance
            child.destroy();
        } else {
            // Parcours récursif pour les enfants
            replaceMainScreens(child);
        }
    }
}

// Attendre que PluginService.pluginContainer soit prêt
function waitForContainerAndReplace() {
    if (typeof PluginService !== 'undefined' && PluginService.pluginContainer) {
        replaceMainScreens(PluginService.pluginContainer);
        console.log("Toutes les MainScreen existantes ont été remplacées !");
    } else {
        // Réessayer après un court délai
        Qt.callLater(waitForContainerAndReplace);
    }
}

// Lancer la vérification
waitForContainerAndReplace();

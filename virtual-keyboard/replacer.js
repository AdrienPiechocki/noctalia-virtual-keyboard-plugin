// Remplace toutes les MainScreen existantes dans un root donné
function replaceMainScreens(root) {
    if (!root || !root.children) return;

    for (var i = root.children.length - 1; i >= 0; i--) { // itération à l’envers
        var child = root.children[i];

        if (child.constructor && child.constructor.name === "MainScreen") {
            var parent = child.parent;

            // Créer l'override depuis le plugin
            var newScreen = Qt.createQmlObject(
                'import "' + Qt.resolvedUrl(".") + '"; MainScreen {}',
                parent
            );

            // Copier certaines propriétés si besoin
            if ("width" in child) newScreen.width = child.width;
            if ("height" in child) newScreen.height = child.height;

            // Supprimer l’ancienne instance
            child.destroy();
        } else {
            // Parcours récursif pour enfants
            replaceMainScreens(child);
        }
    }
}

// Fonction pour exécuter après que PluginService soit prêt
function replaceAll() {
    var root = null;

    if (typeof PluginService !== 'undefined' && PluginService.pluginContainer) {
        root = PluginService.pluginContainer;
    }

    if (root) {
        replaceMainScreens(root);
        console.log("Toutes les MainScreen existantes ont été remplacées !");
    } else {
        console.log("Impossible de trouver le root pour remplacer MainScreen");
    }
}
/*  */
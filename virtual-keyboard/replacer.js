// Fonction récursive pour remplacer toutes les MainScreen
function replaceMainScreens(root) {
    if (!root || !root.children) return;

    for (var i = root.children.length - 1; i >= 0; i--) { // itération à l’envers
        var child = root.children[i];

        if (child.constructor && child.constructor.name === "MainScreen") {
            var parent = child.parent;

            // Créer l'override depuis le plugin
            var newScreen = Qt.createQmlObject(
                'import "file:///home/adrien/.config/noctalia/plugins/virtual-keyboard/"; MainScreen {}',
                parent
            );

            // Copier certaines propriétés si besoin
            if ("width" in child) newScreen.width = child.width;
            if ("height" in child) newScreen.height = child.height;

            // Supprimer l’ancienne instance
            child.destroy();
        } else {
            // Parcours récursif
            replaceMainScreens(child);
        }
    }
}

// Exécution après le chargement du shell
Qt.callLater(function() {
    // Remplacer par le container du plugin si accessible
    var root = null;
    if (typeof shellRoot !== 'undefined') {
        root = shellRoot;
    } else if (Qt.application) {
        root = Qt.application;
    }

    if (root) {
        replaceMainScreens(root);
        console.log("Toutes les MainScreen existantes ont été remplacées !");
    } else {
        console.log("Impossible de trouver le root pour remplacer MainScreen");
    }
});

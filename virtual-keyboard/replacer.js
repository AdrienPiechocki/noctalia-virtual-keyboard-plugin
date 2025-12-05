// ReplaceMainScreen.js

var replaceAll = function() {

    // Fonction récursive pour parcourir tous les enfants et remplacer les MainScreen
    function replaceMainScreens(root) {
        if (!root || !root.children) return;

        for (var i = root.children.length - 1; i >= 0; i--) {
            var child = root.children[i];

            console.log("Enfant trouvé :", child.constructor ? child.constructor.name : child);

            if (child.constructor && child.constructor.name === "MainScreen") {
                console.log("Remplacement d'une MainScreen :", child);
                var parent = child.parent;

                // Chemin absolu vers ton plugin
                var pluginPath = "file:///home/tonuser/.config/noctalia/plugins/virtual-keyboard/";

                // Créer l'override
                var newScreen = Qt.createQmlObject(
                    'import "' + pluginPath + '"; MainScreen {}',
                    parent
                );

                // Copier certaines propriétés si besoin
                if ("width" in child) newScreen.width = child.width;
                if ("height" in child) newScreen.height = child.height;

                // Supprimer l’ancienne instance
                child.destroy();
            } else {
                // Récursion sur les enfants
                replaceMainScreens(child);
            }
        }
    }

    // Attendre que pluginContainer soit prêt
    function waitForContainerAndReplace() {
        if (typeof PluginService !== 'undefined' && PluginService.pluginContainer) {
            // Le vrai root à parcourir est le parent du pluginContainer
            var root = PluginService.pluginContainer.parent;
            console.log("Plugin container trouvé, root à parcourir :", root);
            replaceMainScreens(root);
            console.log("Toutes les MainScreen existantes ont été remplacées !");
        } else {
            // Réessayer après un court délai
            Qt.callLater(waitForContainerAndReplace);
        }
    }

    // Lancer l’attente
    waitForContainerAndReplace();
};

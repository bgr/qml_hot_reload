import QtQuick 2.5

Loader {
    id: _root
    property bool shouldLoad: true
    property string component: "NOT SET"

    function _(componentName) {
        var stack = (new Error()).stack.split("\n");
        var regex = /.*@(.+):./;
        var loaderPath = regex.exec(stack[1])[1];
        var dirPath = loaderPath.substring(0, loaderPath.lastIndexOf('/') + 1);
        var componentPath = dirPath + componentName + ".qml";
        return componentPath;
    }

    sourceComponent: {
        if (!shouldLoad) return null;

        if (_root.component == "NOT SET") {
            throw new Error("You need to set 'component' property");
        }

        var comp = Qt.createComponent(_root.component);
        if (comp.status === Component.Ready) {
            return comp;
        } else if (comp.status === Component.Error) {
            console.error("Error creating component:", comp.errorString());
            return null;
        }
    }

    Component.onCompleted: {
        // hot-reloading was not enabled, just do nothing
        try { hotReloadNotifier; } catch(_) { return; }
        hotReloadNotifier.fileChanged.connect(reloadHandler);
    }

    Component.onDestruction: {
        // hot-reloading was not enabled, or app is quitting and it's unset
        try { hotReloadNotifier;  } catch(_) { return; }
        if (!hotReloadNotifier || !hotReloadNotifier.fileChanged) return;

        hotReloadNotifier.fileChanged.disconnect(reloadHandler);
    }

    function reloadHandler(modifiedFilePath) {
        // sometimes accessing 'component' throws "TypeError: Cannot read
        // property of null", probably because the component had just been
        // destroyed, so just do nothing
        try { component; } catch(_) { return; }

        if (component == modifiedFilePath) {
            console.debug("Hot-reloading", modifiedFilePath);
            shouldLoad = false;
            _reloadTimer.restart();
        }
    }


    Timer {
        id: _reloadTimer
        interval: 1
        running: false
        repeat: false
        onTriggered: {
            shouldLoad = true;
        }
    }
}

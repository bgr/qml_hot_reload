import QtQuick 2.5
import HotReload 1.0

// editing this file doesn't trigger reload since parent 
// ListView's loaders aren't HotLoaders

HotLoader {
    id: _root
    component: _("TodoItemDelegate")

    signal checkRequested
    signal removeRequested

    property string todoText: ""
    property bool todoIsCompleted: false

    Connections {
        target: item
        onCheckClicked: checkRequested()
        onRemoveClicked: removeRequested()
    }
}

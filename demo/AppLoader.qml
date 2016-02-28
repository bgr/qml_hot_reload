import QtQuick 2.5
import HotReload 1.0

HotLoader {
    // name of the qml file without the extension (you could also use a
    // relative path without extension, e.g. "path/to/App")
    component: _("App")

    // state stays in the loader
    property int __ticker: 0
}

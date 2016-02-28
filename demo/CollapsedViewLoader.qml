import QtQuick 2.5
import HotReload 1.0

HotLoader {
    component: _("CollapsedView")

    // state stays in the loader
    property int __index: 0
    property int __unreadMessages: 0
}

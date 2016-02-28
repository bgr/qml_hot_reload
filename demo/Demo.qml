import QtQuick 2.5
import HotReload 1.0

// having the app itself reside in a HotLoader allows us to hot-reload the app
HotLoader {
    width: 400
    height: 600

    component: _("AppLoader")
}

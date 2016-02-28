import QtQuick 2.5

Item {
    id: _app

    Text {
        text: "Seconds elapsed: " + __ticker
        font.pixelSize: 20
    }

    ListView {
        id: _listView
        anchors.fill: parent
        anchors.margins: 50
        clip: true

        spacing: 1

        model: 30
        delegate: CollapsedViewLoader {
            width: _listView.width
            height: 60
            __index: index
            __unreadMessages: __index + __ticker
        }
    }

    Rectangle {
        anchors.fill: _listView
        border.color: "blue"
        color: "transparent"
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: __ticker++;
    }
}

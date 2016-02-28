import QtQuick 2.5


Rectangle {
    color: "lightGray"
    border.color: "gray"
    border.width: 1

    Text {
        anchors.left: parent.left
        anchors.margins: 10
        anchors.verticalCenter: parent.verticalCenter
        text: "Item #" + (__index + 1)
    }

    //Component.onCompleted: console.log("Loaded CollapsedView", __index)

    Text {
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 10

        font.pixelSize: 18
        text: __unreadMessages
        color: "gray"
    }
}

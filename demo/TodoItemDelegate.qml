import QtQuick 2.5
import QtQuick.Layouts 1.2
import QtQuick.Controls 1.4

Rectangle {
    id: _root
    radius: 5
    color: "lightGray"

    signal checkClicked
    signal removeClicked

    MouseArea {
        id: _mouseArea
        anchors.fill: parent
        hoverEnabled: true
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: 10

        CheckBox {
            anchors.verticalCenter: parent.verticalCenter
            checked: todoIsCompleted
            onClicked: _root.checkClicked()
        }

        Text {
            Layout.fillWidth: true
            anchors.verticalCenter: parent.verticalCenter
            text: todoText
            font.pixelSize: 15
            font.strikeout: todoIsCompleted
            font.weight: todoIsCompleted ? Font.Normal : Font.Bold
            elide: Text.ElideRight
        }

        Text {
            text: "X"
            color: "red"
            font.pixelSize: 13
            anchors.verticalCenter: parent.verticalCenter
            visible: _mouseArea.containsMouse

            MouseArea {
                anchors.fill: parent
                anchors.margins: -5
                cursorShape: Qt.PointingHandCursor
                onClicked: removeClicked()
            }
        }
    }
}

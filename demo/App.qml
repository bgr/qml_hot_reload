import QtQuick 2.5
import QtQuick.Layouts 1.2
import QtQuick.Controls 1.4
import "util.js" as Util

Rectangle {
    id: _root
    color: "gray"

    signal todoItemAddRequested(string text)
    signal todoItemCheckRequested(int index)
    signal todoItemRemoveRequested(int index)
    signal removeCompletedRequested()

    function _tryAdd() {
        var text = _textField.text.trim();
        if (text == "") return;
        todoItemAddRequested(text);
        _textField.text = "";
    }

    readonly property var _arrayModel: Util.toArray(_listModel)
    readonly property var _completedModel: _arrayModel
        .filter(function(el) { return el.isCompleted; })

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20

        RowLayout {
            spacing: 10

            TextField {
                id: _textField
                Layout.fillWidth: true
                text: ""
                font.pixelSize: 20

                onAccepted: _tryAdd()
            }

            Button {
                text: "Add"
                onClicked: _tryAdd()
            }
        }

        Text {
            text: ("Completed " + _completedModel.length +
                   " of " + _arrayModel.length + " items")
            font.pixelSize: 14
        }

        ListView {
            id: _listView
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            spacing: 2
            model: _listModel

            delegate: TodoItemDelegateLoader {
                width: _listView.width
                height: 30
                todoText: text
                todoIsCompleted: isCompleted

                onCheckRequested: todoItemCheckRequested(index)
                onRemoveRequested: todoItemRemoveRequested(index)
            }
        }

        Button {
            text: "Clear completed"
            enabled: _completedModel.length > 0
            onClicked: removeCompletedRequested()
        }
    }
}

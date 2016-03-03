import QtQuick 2.5
import HotReload 1.0

// editing this file resets the state, so the state should
// ideally be separate from the view hierarchy but that's
// for another project

HotLoader {
    component: _("App")

    // state stays outside

    ListModel { id: _listModel }

    Connections {
        target: item
        onTodoItemAddRequested: {
            _listModel.insert(0, {
                text: text,
                isCompleted: false
            })
        }
        onTodoItemCheckRequested: {
            var modelItem = _listModel.get(index);
            modelItem.isCompleted = !modelItem.isCompleted;
        }
        onTodoItemRemoveRequested: {
            _listModel.remove(index);
        }
        onRemoveCompletedRequested: {
            for (var i=_listModel.count-1; i >= 0; i--) {
                if (_listModel.get(i).isCompleted) {
                    _listModel.remove(i);
                }
            }
        }
    }

}

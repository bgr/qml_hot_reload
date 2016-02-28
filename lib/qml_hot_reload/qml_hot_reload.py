import os
import pathlib
from watchdog.observers import Observer
from watchdog.events import PatternMatchingEventHandler
from PyQt5.QtCore import QObject, pyqtSignal, pyqtSlot


class HotReloadNotifier(QObject):

    fileChanged = pyqtSignal(str)

    def __init__(self, watch_path_root, qml_engine, parent=None):
        super().__init__(parent)
        event_handler = _QmlModifiedEventHandler(self)
        self._root = watch_path_root
        self._engine = qml_engine
        self.observer = Observer()
        self.observer.schedule(event_handler, watch_path_root, recursive=True)
        self.observer.start()

    def _handle_event(self, event):
        path = os.path.join(self._root, event.src_path)
        uri = pathlib.Path(path).as_uri()
        self.fileChanged.emit(uri)
        self._engine.clearComponentCache()

    @pyqtSlot()
    def stop(self):
        self.observer.stop()
        self.observer.join()


class _QmlModifiedEventHandler(PatternMatchingEventHandler):
    def __init__(self, notifier):
        super().__init__(patterns=["*.qml"], case_sensitive=False)
        self._notifier = notifier

    def on_modified(self, event):
        self._notifier._handle_event(event)

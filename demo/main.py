import os
import sys
import signal
from PyQt5.QtGui import QGuiApplication
from PyQt5.QtCore import QUrl
from PyQt5.QtQuick import QQuickView

demo_dir_path = os.path.dirname(os.path.realpath(__file__))
parent_dir_path = os.path.dirname(demo_dir_path)
lib_dir_path = os.path.join(parent_dir_path, 'lib')

# hack the imports for hassle-free demo
sys.path.insert(0, os.path.join(lib_dir_path, 'qml_hot_reload'))

from qml_hot_reload import HotReloadNotifier


def run():
    signal.signal(signal.SIGINT, signal.SIG_DFL)

    app = QGuiApplication(sys.argv)

    view = QQuickView()
    view.setTitle('Hot reloading demo')

    qml_engine = view.rootContext().engine()
    qml_engine.addImportPath(lib_dir_path)

    notifier = HotReloadNotifier(demo_dir_path, qml_engine, parent=app)
    view.rootContext().setContextProperty('hotReloadNotifier', notifier)

    qml_url = QUrl.fromLocalFile(os.path.join(demo_dir_path, 'Demo.qml'))
    view.setSource(qml_url)

    view.show()
    exit_code = app.exec_()

    # notifier.stop()  # seems like this is not needed
    sys.exit(exit_code)


if __name__ == '__main__':
    run()

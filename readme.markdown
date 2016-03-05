What is this?
=============

This is a proof of concept for having the running QML update as soon as you
edit any .qml file that's currently being displayed, a.k.a. hot reloading.

Here's a screen recording of me writing QML code for a simple ToDo app:

[![QML hot reloading demo](http://img.youtube.com/vi/n3LohbTbfJ4/0.jpg)](http://www.youtube.com/watch?v=n3LohbTbfJ4)

The original recording was 55 minutes long, with only one restart near the
beginning. The resulting code is included in this repo.


How is this done?
=================

There are two parts to the whole story. One is a Python utility
`HotReloadNotifier` that listens to changes to .qml files in some directory and
its subdirectories, and fires a signal whenever a file is changed, and also
clears the QML engine's component cache.

The other is a QML component `HotLoader` that inherits QML's `Loader` and
listens to the signals fired from the Python side, and if the signal argument
matches the path of the component it's assigned, it unloads the component and
loads it again immediately (actually on the next event loop iteration, to make
sure that Python invokes the clearing of the component cache when all have been
unloaded, otherwise the clearing does nothing).

See the included example files on how it's used. `main.py` is what ties the two
parts together.

How do I run the example demo?
==============================

Run `python main.py`. It requires that you have PyQt5 set up, an have installed
the Python dependencies listed in `requirements.txt`. It was written with PyQt5
and Python 3 in mind, but should be easily reworked to work with Python 2, and
I suppose that PyQt4 exposes `clearComponentCache` and that it works the same.


Does this really work in practice, can I use it?
================================================

It hasn't seen any real-world usage. The downside of all this is that it's not
plug-and-play - you have to implement your whole QML code using the provided
`HotLoader`. But even if you're starting from scratch, wrapping everything in
those `HotLoader`s seems cumbersome (although not necessarily a bad practice).

There are also cases where hot reloading doesn't work. The simplest one is if
you have a structure like this:

    SomethingInheritingHotLoader.qml > MyComponent.qml > SubComponent.qml

where changes to SubComponent.qml won't trigger hot reload. This part seems
solvable though - what I'm more concerned about is - when using QML components
that use regular `Loader`s under the hood, like `ListView`, it might be the
case those will act as a hot-reload chain-stopper.

There's also a problem of state-keeping. If you want to have the item state
survive a hot-reload, it can't reside in it. But pulling it out into the parent
isn't a solution - if you edit the parent's source it'll be destroyed. Ideally,
the state tree would be separate from the item tree, but I'm getting ahead of
the matter now.

Isn't there a better / less intrusive way?
==========================================

The only way I could see it being done so that it's transparent from the QML's
point of view is traversing the tree of live QML items from Python / C++ side,
having the source file path exposed on those objects (in order to be able to
match them to the edited .qml file), and reloading them, preferably with some
way to preserve their state. I've looked into this but just briefly, it seemed
like there are enough missing pieces that I didn't want to go further down that
path. If you think it's feasible let me know.

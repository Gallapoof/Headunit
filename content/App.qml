import QtQuick
import aa

Window {
    visible: true
    minimumHeight: 480
    minimumWidth: 800
    title: "Headunit"

    HomeScreen {
        width: Window.width
        height: Window.height
    }

    AAListener {

    }
}
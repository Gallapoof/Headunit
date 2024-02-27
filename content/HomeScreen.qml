import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Timeline 1.0

Item {
    id: homeScreen
    width: 1920
    height: 1080
    property alias mainMenu: mainMenu

    Column {
        id: column
        width: parent.width
        height: parent.height

        Rectangle {
            id: rectangle1
            width: parent.width
            height: parent.height / 2
        }

        component MenuModel : ListModel {
            ListElement {
                name: "Settings"
                image: "logo"
                loaderSource: "SettingsApp.qml"
            }
            ListElement {
                name: "Settings"
                image: "logo"
                loaderSource: "file"
            }
            ListElement {
                name: "Settings"
                image: "logo"
                loaderSource: "file"
            }
        }

        Rectangle {
            width: parent.width
            height: parent.height / 3
            ListView {
                id: mainMenu
                width: parent.width
                height: parent.height
                highlightFollowsCurrentItem: true
                snapMode: ListView.SnapToItem
                spacing: 5
                orientation: ListView.Horizontal
                model: MenuModel {}
                delegate: Rectangle {
                    id: rectangle
                    width: mainMenu.width / 4.2
                    height: mainMenu.height
                    radius: 10
                    border.width: 2
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            console.log("Changed")
                            mainMenu.currentIndex = index
                            loader.source = loaderSource
                            loader.active = true
                            openAnimation.start()
                        }
                    }
                    Text {
                        text: name
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        anchors.rightMargin: 10
                        anchors.bottomMargin: 50
                        font.pointSize: 25
                        font.styleName: "Bold"
                    }
                }
            }
        }
    }

    Timeline {
        id: timeline
        animations: [
            TimelineAnimation {
                id: openAnimation
                running: false
                loops: 1
                duration: 500
                to: 500
                from: 0
            }
        ]
        startFrame: 0
        endFrame: 1000
        enabled: true

        KeyframeGroup {
            target: loader
            property: "scale"
            Keyframe {
                value: 0
                frame: 0
            }

            Keyframe {
                value: 1
                frame: 500
            }
        }

        KeyframeGroup {
            target: column
            property: "y"
            Keyframe {
                value: 0
                frame: 0
            }

            Keyframe {
                value: homeScreen.height
                frame: 300
            }
        }
    }

    Loader {
        id: loader
        anchors.fill: parent
        scale: 1
        z: 1
        active: false
    }
}

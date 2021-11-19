import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtWebSockets 1.1

Rectangle {
    id: gameView
    color: "grey"

    property alias rtt: rtt

    onVisibleChanged: {
        if (visible) {
            forceActiveFocus()
        }
    }

    Keys.onPressed: {
        playerController.keysOnPressed(event)
    }

    Rectangle {
        // game area - not related to size of window, locked at 640x480
        width: 640
        height: 480
        anchors {
            centerIn: parent
        }

        Repeater {
            id: otherUsers
            model: ListModel { }

            delegate: Rectangle {
                color: "blue"
                height: 20
                width: 20
                x: model.x
                y: model.y
            }
        }

        Rectangle {
            id: player
            width: 20; height: 20
            color: "red"

            Behavior on x {
                NumberAnimation {
                    duration: 50
                    easing.type: Easing.Linear
                }
            }

            Behavior on y {
                NumberAnimation {
                    duration: 50
                    easing.type: Easing.Linear
                }
            }

            PlayerController {
                id: playerController
            }
        }

        Text {
            id: rtt
            text: ""
            anchors {
                right: parent.right
            }

            property real commandSent: 0

            function update() {
                if (commandSent !== 0) {
                    text = "RTT: " + (Date.now() - commandSent)
                }
            }
        }
    }

    function update() {
        player.x = root.allUsers[root.id].x
        player.y = root.allUsers[root.id].y

        otherUsers.model.clear()
        let users = Object.keys(root.allUsers)
        for (let user of users) {
            if (user !== root.id) {
                otherUsers.model.append(
                            root.allUsers[user]
                            )
            }
        }
        rtt.update()
    }
}

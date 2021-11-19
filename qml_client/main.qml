import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtWebSockets 1.1

Window {
    id: root
    visible: true
    width: 640
    height: 480
    title: qsTr("QML Client")

    property var allUsers: ({})
    property string id

    WebSocket {
        id:socket
        active: false

        onTextMessageReceived: function(message){
            console.log("Recieved:", message)
            let messageObject = JSON.parse(message)
            switch (messageObject.type) {
                case "init":
                    root.id = messageObject.message.you
                    root.allUsers = messageObject.message.allUsers
                    gameView.update()
                    break
                case "update":
                    root.allUsers = messageObject.message
                    gameView.update()
                    break
            }
        }

        onStatusChanged: {
            if (socket.status == WebSocket.Error) {
                console.log("Websocket Error: " + socket.errorString)
                stack.currentIndex = 0
                active = false
            } else if (socket.status == WebSocket.Open) {
                console.log("Websocket Open")
                stack.currentIndex = 1
            } else if (socket.status == WebSocket.Closed) {
                console.log("Websocket Closed")
                stack.currentIndex = 0
                active = false
            }
        }
    }

    StackLayout {
        id: stack
        anchors {
            fill: parent
        }

        Rectangle {
            id: login
            color: "lightcyan"

            ColumnLayout {
                anchors {
                    centerIn: parent
                }

                TextField {
                    id: text
                    selectByMouse: true
                    text: "ws://0.0.0.0:80"

                    Component.onCompleted: {
                        forceActiveFocus()
                    }

                    onEditingFinished: connect.clicked()
                }

                Button {
                    id: connect
                    text: "Connect"
                    Layout.alignment: Qt.AlignHCenter

                    onClicked: {
                        socket.url = text.text
                        socket.active = true
                    }
                }
            }
        }

        GameView {
            id: gameView
        }
    }
}

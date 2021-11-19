import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

QtObject {
    id: playerController

    // Timer choke to only send play action requests 1x/frame at 60fps
    property Timer timer: Timer {
        interval: 16 // 60fps

        onTriggered:  {
            let message = {
                type: "playerAction",
                message: playerController.playerAction
            }
            socket.sendTextMessage(JSON.stringify(message))
            resetPlayerAction()
            gameView.rtt.commandSent = Date.now()
        }
    }

    property var playerAction: ({
                                 left: 0,
                                 right: 0,
                                 forward: 0,
                                 back: 0,
                             })

    function resetPlayerAction(){
        playerAction.left = 0
        playerAction.right = 0
        playerAction.forward = 0
        playerAction.back = 0
    }

    function keysOnPressed(event) {
        if (event.key === Qt.Key_Left || event.key === Qt.Key_D) {
            console.log("turn left")
            playerAction.left += 5
        }
        if (event.key === Qt.Key_Right || event.key === Qt.Key_A) {
            console.log("turn right")
            playerAction.right += 5
        }
        if (event.key === Qt.Key_Up || event.key === Qt.Key_W) {
            console.log("move forward")
            playerAction.forward += 5
        }
        if (event.key === Qt.Key_Down || event.key === Qt.Key_S) {
            console.log("move back")
            playerAction.back += 5
        }

        event.accepted = true

        if (timer.running === false) {
            timer.start()
        }
    }
}

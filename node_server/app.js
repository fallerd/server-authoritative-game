const WebSocket = require('ws')
const uuid = require('uuid')

var connected_clients = {}

const wss = new WebSocket.Server({ port: 80 })
console.log("Server started")

/*
 * method: broadcast
 * @data: data being sent
 * @sender: which client/ws/socket is sending, and will be skipped. Set sender undefined/null to broadcast to all
 */
wss.broadcast = function (data, sender) {
  // console.log("broadcasting " + data)
  wss.clients.forEach(function (client) {
    if (client !== sender) {
      client.send(data)
    }
  })
}

wss.on('connection', function connection(ws, request) {
  initializeClient(ws)
})

/*
 * method: initializeClient
 * @ws: websocket connection to initialize
 */
function initializeClient(ws) {
  ws.client_id = uuid.v4();
  connected_clients[ws.client_id] = {
    "x": 0,
    "y": 0
  }
  let init = {
    "you": ws.client_id,
    "allUsers": connected_clients
  }
  ws.send(addTypeWrapper(init, "init"))
  wss.broadcast(addTypeWrapper(connected_clients, "update"), ws.client_id) // update all other clients after new client added

  ws.on('message', function incoming(message) {
    // console.log('Received: %s', message, ws.client_id)
    let messageObject = JSON.parse(message)
    switch (messageObject.type) {
      case "playerAction":
        playerAction(ws.client_id, messageObject.message)
        break
    }
  })

  ws.on('close', function () {
    console.log('client dropped:', ws.client_id)
    delete connected_clients[ws.client_id]
    wss.broadcast(addTypeWrapper(connected_clients, "update"), null)
  })
}

/*
 * method: addTypeWrapper
 * @message: message to be wrapped
 * @type: type of message to be set in wrapper
 */
function addTypeWrapper(message, type) {
  return JSON.stringify({
    "type": type,
    "message": message
  })
}

/*
 * method: playerAction
 * @client_id: id of client that initiated action
 * @player_action: action requested by client
 */
function playerAction(client_id, player_action) {
  console.log("Client: " + client_id + "\n    Requests action: " + JSON.stringify(player_action))

  connected_clients[client_id].x += (player_action.right - player_action.left)
  connected_clients[client_id].y += (player_action.back - player_action.forward)

  wss.broadcast(addTypeWrapper(connected_clients, "update"), null)
}

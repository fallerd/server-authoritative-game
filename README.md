# Server-authoritative Game Example/Test

This is a simple test bed for a server-authoritative multiplayer game, where all commands are sent from player clients to be validated/calculated on the server. Node.js server with QML clients, connected via WebSockets.

## To run server

```
cd node_server
npm install
node app.js
```

## To build/run clients

Build `qml_client/qml_client.pro` with Qt >=5.12.x. Client includes ability to set server address.

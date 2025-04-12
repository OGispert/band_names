import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerState { online, offline, connecting }

class SocketService with ChangeNotifier {
  var _serverState = ServerState.connecting;
  late IO.Socket _socket;

  ServerState get serverState => _serverState;
  IO.Socket get socket => _socket;

  SocketService() {
    initConfig();
  }

  void initConfig() {
    // Dart client
    _socket = IO.io('http://localhost:3001', {
      'transports': ['websocket'],
      'autoConnect': true,
    });

    _socket.onConnect((_) {
      _serverState = ServerState.online;
      notifyListeners();
    });

    _socket.onDisconnect((_) {
      _serverState = ServerState.offline;
      notifyListeners();
    });

    // socket.on('new-message', (payload) {
    //   print('New Message: $payload');
    // });
  }
}

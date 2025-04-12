import 'package:band_names/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ServerStatus extends StatelessWidget {
  const ServerStatus({super.key});

  @override
  Widget build(BuildContext context) {
    final serverStatus = Provider.of<SocketService>(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text(serverStatus.serverState.toString())],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        elevation: 4,
        mini: true,
        child: Icon(Icons.message),
        onPressed: () {
          serverStatus.socket.emit('new-message', {
            'message': 'Hello from Flutter',
          });
        },
      ),
    );
  }
}

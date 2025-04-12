import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:band_names/models/band.dart';
import 'package:band_names/services/socket_service.dart';
import 'package:pie_chart/pie_chart.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Band> bands = [];

  final editingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final socketService = Provider.of<SocketService>(context, listen: false);

    socketService.socket.on('allbands', _handleActiveBands);
  }

  @override
  void dispose() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.off('allbands');
    editingController.dispose();
    super.dispose();
  }

  _handleActiveBands(dynamic payload) {
    setState(() {
      bands = (payload as List).map((band) => Band.fromMap(band)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);
    final isConnected = socketService.serverState == ServerState.online;

    return Scaffold(
      appBar: AppBar(
        title: Text('Band Names'),
        actions: [
          Container(
            padding: EdgeInsets.only(right: 16),
            child: Icon(
              isConnected ? Icons.cloud_done_outlined : Icons.cloud_off,
              color: isConnected ? Colors.blue : Colors.red,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _graphWidget(),
          Expanded(
            child: ListView.builder(
              itemCount: bands.length,
              itemBuilder:
                  (context, index) => _bandTile(bands[index], socketService),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        elevation: 4,
        mini: true,
        onPressed: addNewBand,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _bandTile(Band band, SocketService service) {
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.endToStart,
      background: Container(
        padding: EdgeInsets.only(right: 8),
        color: Colors.red,
        alignment: Alignment.centerRight,
        child: Text(
          'Delete',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      onDismissed: (direction) {
        service.socket.emit('deleteband', {'id': band.id});
      },
      child: ListTile(
        leading: CircleAvatar(child: Text(band.name.substring(0, 2))),
        title: Text(band.name, style: TextStyle(fontSize: 18)),
        trailing: Text('${band.votes}', style: TextStyle(fontSize: 18)),
        onTap: () {
          service.socket.emit('band-vote', {'id': band.id});
        },
      ),
    );
  }

  void addNewBand() {
    if (Platform.isAndroid) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add a new band'),
            content: TextField(
              controller: editingController,
              decoration: InputDecoration(labelText: 'Band name'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => addBandToList(editingController.text),
                child: const Text('Add'),
              ),
            ],
          );
        },
      );
      return;
    }

    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Add a new band'),
          content: Padding(
            padding: EdgeInsets.only(top: 16),
            child: CupertinoTextField(
              controller: editingController,
              placeholder: 'Band name',
            ),
          ),
          actions: [
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel'),
            ),
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () => addBandToList(editingController.text),
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void addBandToList(String bandName) {
    if (bandName.isEmpty || bandName.trim().length <= 1) {
      return;
    }

    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.emit('addband', {'name': bandName});

    editingController.clear();

    Navigator.pop(context);
  }

  Widget _graphWidget() {
    Map<String, double> dataMap = {"": 0};

    for (Band band in bands) {
      dataMap.remove("");
      dataMap.putIfAbsent(band.name, () => band.votes.toDouble());
    }

    return Container(
      width: double.infinity,
      height: 200,
      child: PieChart(dataMap: dataMap),
    );
  }
}

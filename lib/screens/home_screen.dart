import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:band_names/models/band.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Band> bands = [
    Band(id: '1', name: 'Metallica', votes: 5),
    Band(id: '2', name: 'Pantera', votes: 2),
    Band(id: '3', name: 'Sepultura', votes: 3),
    Band(id: '4', name: 'Slipknot', votes: 1),
  ];

  final editingController = TextEditingController();

  @override
  void dispose() {
    editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Band Names')),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (context, index) => _bandTile(bands[index]),
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

  ListTile _bandTile(Band band) {
    return ListTile(
      leading: CircleAvatar(child: Text(band.name.substring(0, 2))),
      title: Text(band.name, style: TextStyle(fontSize: 18)),
      trailing: Text('${band.votes}', style: TextStyle(fontSize: 18)),
      onTap: () {},
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

    editingController.clear();

    Navigator.pop(context);
  }
}

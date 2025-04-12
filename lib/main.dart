import 'package:band_names/screens/home_screen.dart';
import 'package:band_names/screens/server_status.dart';
import 'package:band_names/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => SocketService())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(colorSchemeSeed: Color.fromARGB(255, 9, 181, 9)),
        initialRoute: 'home',
        routes: {'home': (_) => HomeScreen(), 'server': (_) => ServerStatus()},
      ),
    );
  }
}

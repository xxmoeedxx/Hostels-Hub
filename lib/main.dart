import 'package:authui/pages/welcome.dart';
import 'package:flutter/material.dart';
//import 'pages/welcome.dart';
import 'pages/map.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hostels Hub',
      debugShowCheckedModeBanner: false,
      home: WelcomePage(),
    );
  }
}

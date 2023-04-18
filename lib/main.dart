import 'package:authui/pages/hostel_list.dart';
import 'package:authui/pages/map.dart';
import 'package:authui/pages/welcome.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
      home: _auth.currentUser == null ? WelcomePage() : HostelListPage()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  User? user = _auth.currentUser;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hostels Hub',
      debugShowCheckedModeBanner: false,
      home: WelcomePage(),
    );
  }
}

//import 'package:authui/pages/welcome.dart';
import 'package:authui/pages/welcome.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
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

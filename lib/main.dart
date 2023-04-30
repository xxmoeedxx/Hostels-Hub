import 'package:db_project/pages/hostel_list.dart';
import 'package:db_project/pages/welcome.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:db_project/services/user_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  User? user = _auth.currentUser;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserProvider(),
      child: MaterialApp(
        title: 'Hostels Hub',
        debugShowCheckedModeBanner: false,
        home: user == null ? WelcomePage() : HostelListPage(),
      ),
    );
  }
}

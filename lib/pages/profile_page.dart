import 'package:db_project/pages/bottom_bar.dart';
import 'package:db_project/pages/welcome.dart';
import 'package:db_project/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:db_project/services/user_provider.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: const Color.fromARGB(255, 7, 6, 68),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  AnimatedContainer(
                    height: MediaQuery.of(context).size.height * 0.25,
                    duration: Duration.zero,
                    child: ScaleTransition(
                      scale: _animation,
                      child: const CircleAvatar(
                        radius: 60,
                        backgroundColor: Color.fromARGB(255, 7, 6, 68),
                        child: CircleAvatar(
                          radius: 55,
                          backgroundImage:
                              NetworkImage('https://i.pravatar.cc/150?img=3'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 7, 6, 68),
                    borderRadius: BorderRadius.circular(20), // Rounded borders
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        Provider.of<UserProvider>(context).currentUser?.name ??
                            '-',
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // White text color
                        ),
                      ),
                      const SizedBox(height: 20),
                      ListTile(
                        leading: const Icon(Icons.phone,
                            color: Colors.white), // White icon color
                        title: Text(
                          Provider.of<UserProvider>(context)
                                  .currentUser
                                  ?.contact ??
                              '-',
                          style: const TextStyle(
                              color: Colors.white), // White text color
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.15),
                      TextButton(
                        onPressed: () async {
                          // perform logout action here
                          final FirebaseAuth _auth = FirebaseAuth.instance;
                          await _auth.signOut();
                          // ignore: use_build_context_synchronously
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WelcomePage()), (root) {
                            return false;
                          });
                        },
                        child: const Text(
                          'Logout',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AnimatedBottomBar(),
    );
  }
}

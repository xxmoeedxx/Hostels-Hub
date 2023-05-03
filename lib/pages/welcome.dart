// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:ui';

import 'package:db_project/pages/hostel_list.dart';
import 'package:db_project/pages/login.dart';
import 'package:db_project/pages/map.dart';
import 'package:db_project/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:db_project/components/my_button.dart';
import 'package:db_project/components/my_textfield.dart';
import 'package:db_project/components/square_tile.dart';
import 'package:db_project/pages/signup.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

Future<bool> checkIfEmailExists(String Email) async {
  var result = await _auth.fetchSignInMethodsForEmail(Email);
  return result.isNotEmpty;
}

final GoogleSignIn _googleSignIn = GoogleSignIn();
final DatabaseService _db = DatabaseService();
Future<UserCredential> signInWithGoogle() async {
  // Attempt to sign in with Google account.
  await _googleSignIn.signOut();
  final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount!.authentication;
  final AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );
  // Authenticate with Firebase using the credential.
  final UserCredential authResult =
      await _auth.signInWithCredential(credential);
  final User? user = authResult.user;
  if (user != null) {
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);
    // Get the user data.
    final User currentUser = _auth.currentUser!;
    assert(user.uid == currentUser.uid);
    print('signInWithGoogle succeeded: $user');
  }
  return authResult;
}

// ignore: must_be_immutable
class WelcomePage extends StatelessWidget {
  WelcomePage({super.key});

  // text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  final double _sigmaX = 5; // from 0-10
  final double _sigmaY = 5; // from 0-10
  final double _opacity = 0.2;
  final _formKey = GlobalKey<FormState>();

  // sign user in method
  void signUserIn() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  ('assets/images/pic3.png'),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  fit: BoxFit.cover,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      color: Colors.white,
                      onPressed: () {},
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.09),
                    const Text("Welcome to\nHostels Hub",
                        style: TextStyle(
                            color: Color.fromARGB(255, 252, 252, 252),
                            fontSize: 45,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    ClipRect(
                      child: BackdropFilter(
                        filter:
                            ImageFilter.blur(sigmaX: _sigmaX, sigmaY: _sigmaY),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(0, 0, 0, 1)
                                  .withOpacity(_opacity),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                          width: MediaQuery.of(context).size.width * 0.92,
                          height: MediaQuery.of(context).size.height * 0.49,
                          child: Form(
                            key: _formKey,
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // username textfield
                                  MyTextField(
                                    controller: usernameController,
                                    hintText: 'Email',
                                    obscureText: false,
                                  ),

                                  const SizedBox(height: 10),

                                  // sign in button
                                  MyButton(
                                    onTap: (() async {
                                      if (_formKey.currentState!.validate()) {
                                        bool emailExists =
                                            await checkIfEmailExists(
                                                usernameController.text);
                                        if (emailExists) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => LoginPage(
                                                  email:
                                                      usernameController.text),
                                            ),
                                          );
                                        } else {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => Signup(
                                                  email:
                                                      usernameController.text),
                                            ),
                                          );
                                        }
                                      } else {
                                        //print('not valid');
                                      }
                                    }),
                                  ),

                                  const SizedBox(height: 10),

                                  // or continue with
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Divider(
                                          thickness: 0.5,
                                          color: Colors.grey[400],
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: Text(
                                          'Or',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16),
                                        ),
                                      ),
                                      Expanded(
                                        child: Divider(
                                          thickness: 0.5,
                                          color: Colors.grey[400],
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 10),

                                  // google + apple sign in buttons
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // google button
                                        SquareTile(
                                          onTap: () async {
                                            try {
                                              await signInWithGoogle();
                                              final userDoc = await _db.getUser(
                                                  _auth.currentUser!.uid);
                                              if (userDoc == null) {
                                                _db.createUser(
                                                    name: _auth.currentUser!
                                                        .displayName!,
                                                    uid: _auth.currentUser!.uid,
                                                    contact: _auth.currentUser!
                                                            .phoneNumber ??
                                                        "--",
                                                    profilePicture: _auth
                                                        .currentUser!
                                                        .photoURL!);
                                              } else {}
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          HostelListPage()));
                                            } catch (e) {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      AlertDialog(
                                                        title:
                                                            const Text('Error'),
                                                        content: const Text(
                                                            'An error occurred. Please try again later.'),
                                                        actions: [
                                                          TextButton(
                                                              onPressed: () =>
                                                                  Navigator.pop(
                                                                      context),
                                                              child: const Text(
                                                                  'OK'))
                                                        ],
                                                      ));
                                            }
                                          },
                                          imagePath: 'assets/images/google.png',
                                          title: 'Continue with Google',
                                        ),

                                        SizedBox(height: 10),
                                      ],
                                    ),
                                  ),

                                  //const SizedBox(height: 10),

                                  // not a member? register now
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ignore_for_file: prefer_const_constructors

import 'dart:ui';
import 'package:db_project/components/my_button.dart';
import 'package:db_project/components/my_textfield.dart';
import 'package:db_project/pages/hostel_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:db_project/services/user_provider.dart';

import '../services/database_service.dart';
import 'forgotPassword.dart';

// ignore: must_be_immutable
class LoginPage extends StatelessWidget {
  //LoginPage({super.key});
  LoginPage({Key? key, required this.email}) : super(key: key);
  final String email;
  // text editing controllers
  final passwordController = TextEditingController();
  final double _sigmaX = 5; // from 0-10
  final double _sigmaY = 5; // from 0-10
  final double _opacity = 0.2;
  final _formKey = GlobalKey<FormState>();
  final DatabaseService _db = DatabaseService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
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
                  SizedBox(height: MediaQuery.of(context).size.height * 0.07),
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    color: Colors.white,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.17),
                  const Text("Log in",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.015),
                  ClipRect(
                    child: BackdropFilter(
                      filter:
                          ImageFilter.blur(sigmaX: _sigmaX, sigmaY: _sigmaY),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 1.0),
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(0, 0, 0, 1)
                                .withOpacity(_opacity),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(30))),
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.height * 0.45,
                        child: Form(
                          key: _formKey,
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25.0),
                                  child: Row(children: [
                                    const CircleAvatar(
                                      radius: 30,
                                      backgroundImage: NetworkImage(
                                          'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png'),
                                    ),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.05),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      // ignore: prefer_const_literals_to_create_immutables
                                      children: [
                                        Text(email,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.035))
                                      ],
                                    )
                                  ]),
                                ),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.03),
                                MyPasswordTextField(
                                  controller: passwordController,
                                  hintText: 'Password',
                                ),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.03),
                                MyButtonAgree(
                                    text: "Continue",
                                    onTap: () async {
                                      try {
                                        UserCredential userCredential =
                                            await FirebaseAuth.instance
                                                .signInWithEmailAndPassword(
                                          email: email,
                                          password: passwordController.text,
                                        );

                                        UserProvider userProvider =
                                            // ignore: use_build_context_synchronously
                                            Provider.of<UserProvider>(context,
                                                listen: false);
                                        Future<Users?> userFuture =
                                            _db.getUserInfo(
                                                userCredential.user!.uid);
                                        Users? user = await userFuture;
                                        userProvider.setCurrentUser(user!);

                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  HostelListPage()),
                                          (route) => false,
                                        );
                                      } on FirebaseAuthException catch (e) {
                                        if (e.code == 'wrong-password') {
                                          showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                    title: const Text(
                                                        'Invalid Password'),
                                                    content: const Text(
                                                        'The password you entered is incorrect.'),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  context),
                                                          child:
                                                              const Text('OK'))
                                                    ],
                                                  ));
                                        }
                                      } catch (e) {
                                        print(e.toString());
                                        showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                                  title: const Text('Error'),
                                                  content: const Text(
                                                      'An error occurred. Please try again later.'),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context),
                                                        child: const Text('OK'))
                                                  ],
                                                ));
                                      }
                                    }),
                                const SizedBox(height: 20),
                                // const Text('Forgot Password?',
                                //     style: TextStyle(
                                //         color:
                                //             Color.fromARGB(255, 71, 233, 133),
                                //         fontWeight: FontWeight.bold,
                                //         fontSize: 20),
                                //     textAlign: TextAlign.start),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ForgetPasswordPage()));
                                  },
                                  child: Text(
                                    'Forget Password',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: Color(0xFF00E676),
                                        fontSize: 22),
                                  ),
                                  style: ButtonStyle(),
                                ),
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
    );
  }
}

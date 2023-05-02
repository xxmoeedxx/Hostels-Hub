import 'dart:io';

import 'package:db_project/pages/bottom_bar.dart';
import 'package:db_project/pages/welcome.dart';
import 'package:db_project/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  bool _isEditingName = false;
  bool _isEditingContact = false;
  @override
  void initState() {
    super.initState();
    _nameController.text =
        Provider.of<UserProvider>(context, listen: false).currentUser?.name ??
            '-';
    _contactController.text = Provider.of<UserProvider>(context, listen: false)
            .currentUser
            ?.contact ??
        '-';
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
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CircleAvatar(
                            radius: 90,
                            backgroundColor: Color.fromARGB(255, 7, 6, 68),
                            child: CircleAvatar(
                              radius: MediaQuery.of(context).size.height * 0.12,
                              backgroundImage: NetworkImage(
                                '${Provider.of<UserProvider>(context).currentUser?.profilePicture}'
                                '?timestamp=${DateTime.now().millisecondsSinceEpoch}',
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 60,
                            child: GestureDetector(
                              onTap: () async {
                                final pickedFile = await ImagePicker().getImage(
                                  source: ImageSource.gallery,
                                  imageQuality: 50,
                                );

                                if (pickedFile != null) {
                                  // Upload the new profile picture
                                  final downloadUrl =
                                      await Provider.of<UserProvider>(context,
                                              listen: false)
                                          .updateProfilePicture(
                                              File(pickedFile.path));
                                  setState(() {});
                                }
                              },
                              child: CircleAvatar(
                                backgroundColor: Colors.blue,
                                radius: 20,
                                child: Icon(Icons.edit, color: Colors.black),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 7, 6, 68),
                    borderRadius: BorderRadius.circular(20), // Rounded borders
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: TextFormField(
                              textAlign: TextAlign.center,
                              controller: _nameController,
                              readOnly: !_isEditingName,
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.09,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              decoration: const InputDecoration(
                                hintText: 'Enter your name',
                                hintStyle: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a name';
                                }
                                return null;
                              },
                            ),
                          ),
                          IconButton(
                            icon: _isEditingName
                                ? const Icon(Icons.done)
                                : const Icon(Icons.edit),
                            color: Colors.white,
                            onPressed: () {
                              setState(() {
                                _isEditingName = !_isEditingName;
                                if (!_isEditingName) {
                                  // Save the updated name when the user is done editing
                                  Provider.of<UserProvider>(context,
                                          listen: false)
                                      .updateUserName(_nameController.text);
                                }
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.phone, color: Colors.white),
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                if (!_isEditingContact) {
                                  return; // Do nothing if not editing
                                }
                              },
                              child: TextFormField(
                                textAlign: TextAlign.start,
                                controller: _contactController,
                                readOnly: !_isEditingContact,
                                style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                decoration: const InputDecoration(
                                  hintText: 'Enter Phone Number',
                                  hintStyle: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter phone number';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          IconButton(
                            icon: _isEditingContact
                                ? const Icon(Icons.done)
                                : const Icon(Icons.edit),
                            color: Colors.white,
                            onPressed: () {
                              setState(() {
                                _isEditingContact = !_isEditingContact;
                                if (!_isEditingContact) {
                                  // Save the updated name when the user is done editing
                                  Provider.of<UserProvider>(context,
                                          listen: false)
                                      .updateContact(_contactController.text);
                                }
                              });
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.10),
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

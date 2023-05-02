import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:db_project/services/database_service.dart';

final DatabaseService _db = DatabaseService();

class UserProvider with ChangeNotifier {
  Users? _currentUser;

  Users? get currentUser => _currentUser;
  void updateUserName(String name) {
    // Update the user's name in the database
    _db.updateUser(
        uid: currentUser!.uid,
        name: name,
        contact: currentUser!.contact,
        profilePicture: currentUser!.profilePicture);

    // Update the current user object in the provider
    setCurrentUser(_currentUser!);
    // Notify listeners that the user object has been updated
  }

  void updateContact(String contact) {
    // Update the user's name in the database
    _db.updateUser(
        uid: currentUser!.uid,
        name: currentUser!.name,
        contact: contact,
        profilePicture: currentUser!.profilePicture);

    // Update the current user object in the provider
    setCurrentUser(_currentUser!);
    // Notify listeners that the user object has been updated
  }

  Future<String?> uploadProfilePicture(File file) async {
    try {
      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_pictures/${currentUser!.uid}.jpg');
      UploadTask uploadTask = storageRef.putFile(file);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> updateProfilePicture(File imageFile) async {
    try {
      String? imageUrl = await uploadProfilePicture(imageFile);
      await _db.updateUser(
          uid: currentUser!.uid,
          name: currentUser!.name,
          contact: currentUser!.contact,
          profilePicture: imageUrl!);

      // Update the user provider with the new user data
      setCurrentUser(_currentUser!);
    } catch (e) {
      print('Failed to update profile picture: $e');
    }
  }

  void setCurrentUser(Users user) {
    _currentUser = user;
    notifyListeners();
  }
}

import 'package:firebase_auth/firebase_auth.dart';

// Initialize Firebase
// void initFirebase() async {
//   await Firebase.initializeApp();
// }

// Sign in with email and password
// void signInWithEmail(String email, String password) async {
//   try {
//     UserCredential userCredential =
//         await FirebaseAuth.instance.signInWithEmailAndPassword(
//       email: email,
//       password: password,
//     );
//     User user = userCredential.user;
//     print('Signed in as ${user.email}');
//   } catch (e) {
//     print('Error: $e');
//   }
// }

// Sign out
void signOut() async {
  await FirebaseAuth.instance.signOut();
  print('Signed out');
}

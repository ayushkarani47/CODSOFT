import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  //create instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //get current user
  User? getCurrentUser() => _auth.currentUser;

  //login
  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

          //create user in firestore
           await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
            'uid':userCredential.user!.uid,
            'email':userCredential.user!.email,
          });
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  //register/sign up
  Future<UserCredential> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      //create user in firestore
      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
            'uid':userCredential.user!.uid,
            'email':userCredential.user!.email,
          });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  //log out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  //error
}

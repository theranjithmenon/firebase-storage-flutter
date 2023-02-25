import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuth extends ChangeNotifier {
  GoogleSignIn googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

  Future googleLogIn() async {
    final googleUser = await googleSignIn.signIn();
    final googleAuth = await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken
    );
    await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future logout() async{
    await googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
  }
}

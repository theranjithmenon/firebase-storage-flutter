import 'package:firebase/googleSignIn.dart';
import 'package:flutter/material.dart';

class LogInScreen extends StatelessWidget {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: MaterialButton(
          onPressed: () {
            GoogleAuth().googleLogIn();
          },
          child: const Text('Continue with Google!'),
        ),
      ),
    );
  }
}

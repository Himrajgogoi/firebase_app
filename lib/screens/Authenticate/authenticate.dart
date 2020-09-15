import 'package:firebase_app/screens/Authenticate/register.dart';
import 'package:firebase_app/screens/Authenticate/sign_in.dart';
import "package:flutter/material.dart";

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool signedIn = true;

  void toggleSignedIn() {
    setState(() {
      signedIn = !signedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(signedIn){
      return SignIn(toggle: toggleSignedIn);
    }
    else{
      return Register(toggle: toggleSignedIn);
    }
  }
}

import 'package:firebase_app/model/user.dart';
import 'package:firebase_app/screens/Authenticate/authenticate.dart';
import 'package:firebase_app/screens/Home/home.dart';
import 'package:flutter/material.dart';
import "package:provider/provider.dart";

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User_>(context);
    if(user == null) {
      return Authenticate();
    }
    else{
      return Home();
    }
  }
}

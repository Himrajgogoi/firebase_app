import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import "package:provider/provider.dart";
import 'package:firebase_app/model/user.dart';
import 'package:firebase_app/screens/error.dart';
import 'package:firebase_app/screens/wrapper.dart';
import 'package:firebase_app/services/auth.dart';
import 'package:firebase_app/shared/loading.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  Future<FirebaseApp> _initialize = Firebase.initializeApp();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User_>.value(
      value: AuthService().user,
      child: MaterialApp(
        home: FutureBuilder(
          future: _initialize,
          builder: (context, snapshot) {
            if(snapshot.hasError){
              return Error();
            }
            if(snapshot.connectionState == ConnectionState.done){
              return Wrapper();
            }
            return Loading();
          },
        ),
      ),
    );

  }
}

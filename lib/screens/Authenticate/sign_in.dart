import 'package:firebase_app/services/auth.dart';
import 'package:firebase_app/shared/loading.dart';
import "package:flutter/material.dart";
import "package:firebase_app/shared/textdecoration.dart";

class SignIn extends StatefulWidget {
  final Function toggle;
  SignIn({this.toggle});
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _key = GlobalKey<FormState>();
  bool success = false;
  String error=" ";

  String email=" ";
  String password=" ";
  @override
  Widget build(BuildContext context) {
    return success == true? Loading(): Scaffold(
      backgroundColor: Colors.blue[900],
        body:Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
          child: Form(
            key: _key,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: Text("Welcome.", style: TextStyle(
                      fontSize: 50.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    )),
                  ),

                  SizedBox(height:20.0),
                  TextFormField(
                    decoration: textDecoration.copyWith(hintText: "Email"),
                    onChanged: (val){
                      setState(() {
                        email = val;
                      });
                    },
                    validator: (val)=> val.isEmpty? "Enter a valid email": null,
                  ),
                  SizedBox(height:20.0),
                  TextFormField(
                    obscureText: true,
                    decoration: textDecoration.copyWith(hintText: "Password"),
                    onChanged: (val){
                      setState(() {
                        password = val;
                      });
                    },
                    validator: (val)=> val.length <6? "Password greater than 6 characters": null,
                  ),
                  SizedBox(height:20.0),
                  FlatButton(
                    color: Colors.orange,
                    onPressed: () async {
                      if(_key.currentState.validate()){

                          setState(() {
                            success = true;
                          });
                        dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                        if(result == null) {
                          setState(() {
                            error = "Enter a valid email";
                            success = false;
                          });
                        }
                      }
                    },
                    child: Text("Sign In", style:TextStyle(
                      color: Colors.white
                    )),
                  ),
                  SizedBox(height:12.0),
                  Text("$error",
                    style: TextStyle(
                        color: Colors.red
                    ),),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Don't have an account?",style: TextStyle(
                        color: Colors.white
                      ),),
                      InkWell(
                          onTap: (){
                            widget.toggle();
                          },
                          child: Text("  Register",style: TextStyle(
                              color: Colors.yellow
                          ),)),
                    ],
                  )

                ],
              ),
            ),
          ),
        )
    );
  }
}

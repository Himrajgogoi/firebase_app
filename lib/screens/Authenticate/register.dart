import 'package:firebase_app/services/auth.dart';
import 'package:firebase_app/shared/loading.dart';
import "package:flutter/material.dart";
import "package:firebase_app/shared/textdecoration.dart";

class Register extends StatefulWidget {

  final Function toggle;
  Register({this.toggle});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _key = GlobalKey<FormState>();
  bool success = false;
  String error=" ";

  String email=" ";
  String password=" ";
  String name = " ";
  String phone = " ";

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
                    child: Text("Join the Family", style: TextStyle(
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                    )),
                  ),
                  Text("and stay updated.", style: TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                  )),
                  SizedBox(height:20.0),
                  TextFormField(
                    decoration: textDecoration.copyWith(hintText: "Name"),
                    onChanged: (val){
                      setState(() {
                        name = val;
                      });
                    },
                    validator: (val)=> val.isEmpty? "Enter a valid name": null,
                  ),
                  SizedBox(height:20.0),
                  TextFormField(
                    decoration: textDecoration.copyWith(hintText: "Phone"),
                    onChanged: (val){
                      setState(() {
                        phone = val;
                      });
                    },
                    validator: (val)=> val.length <10? "Enter a valid number": null,
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
                    color: Colors.blueAccent,
                    onPressed: () async {
                      if(_key.currentState.validate()){
                        setState(() {
                          success = true;
                        });
                        dynamic result = await _auth.registerWithEmailAndPassword(email, password, name, phone);
                        if(result == null){
                          setState(() {
                            error = "Enter a valid email";
                            success = false;
                          });
                        }
                      }
                    },
                    child: Text("Register", style:TextStyle(
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
                      Text("Have an account?", style: TextStyle(
                        color: Colors.white
                      ),),
                      InkWell(
                          onTap: (){
                            widget.toggle();
                          },
                          child: Text("  Sign In", style: TextStyle(
                          color: Colors.yellowAccent
                      ),),)
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

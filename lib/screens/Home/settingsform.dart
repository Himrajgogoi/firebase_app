import 'package:firebase_app/model/user.dart';
import 'package:firebase_app/services/database.dart';
import 'package:firebase_app/shared/loading.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import "package:firebase_app/shared/textdecoration.dart";

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {

  final _key = GlobalKey<FormState>();
  String _currentName;
  String _currentEmail;
  String _currentPhone;

  bool success = false;
  String error = "";

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User_>(context);

    return StreamBuilder<userData>(
      stream: DatabaseService(uid: user.id).UserData,
      builder: (context, snapshot){
        if(snapshot.hasData){
          userData data = snapshot.data;
          return Container(
           padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 6.0),
            child: Form(
              key: _key,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(height:20.0),
                    TextFormField(
                      initialValue: data.name,
                      decoration: textDecoration.copyWith(hintText: "Name"),
                      onChanged: (val){
                        setState(() {
                          _currentName = val;
                        });
                      },
                      validator: (val)=> val.isEmpty? "Enter a valid name": null,
                    ),
                    SizedBox(height:20.0),
                    TextFormField(
                      initialValue: data.phone,
                      decoration: textDecoration.copyWith(hintText: "Phone"),
                      onChanged: (val){
                        setState(() {
                          _currentPhone = val;
                        });
                      },
                      validator: (val)=> val.length <10? "Enter a valid number": null,
                    ),
                    SizedBox(height:20.0),
                    TextFormField(
                      initialValue: data.email,
                      decoration: textDecoration.copyWith(hintText: "Email"),
                      onChanged: (val){
                        setState(() {
                          _currentEmail = val;
                        });
                      },
                      validator: (val)=> val.isEmpty? "Enter a valid email": null,
                    ),
                    SizedBox(height:20.0),
                    FlatButton(
                      color: Colors.redAccent,
                      onPressed: () async {
                        if(_key.currentState.validate()){
                          await DatabaseService(uid: user.id).updateData(
                              _currentName?? data.name
                              , _currentEmail?? data.email
                              , _currentPhone?? data.phone,
                          null);
                        }
                        Navigator.pop(context);

                      },
                      child: Text("Update", style:TextStyle(
                          color: Colors.white
                      )),
                    ),
                    SizedBox(height:12.0),
                    FlatButton(
                      color: Colors.blue,
                      onPressed: () async {
                          await DatabaseService(uid: user.id).deleteData();
                        Navigator.pop(context);

                      },
                      child: Text("Delete details", style:TextStyle(
                          color: Colors.white
                      )),
                    ),
                    SizedBox(height:12.0),
                    Text("$error",
                      style: TextStyle(
                          color: Colors.red
                      ),)
                  ],
                )
              ),
            ),
          );
        }
        else{
          return Loading();
        }
      },
    );
  }
}

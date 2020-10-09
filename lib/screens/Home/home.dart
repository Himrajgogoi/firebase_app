import "dart:math";
import 'dart:io';
import 'package:firebase_app/model/display.dart';
import 'package:firebase_app/model/user.dart';
import 'package:firebase_app/screens/Home/Feed.dart';
import 'package:firebase_app/screens/Home/account.dart';
import 'package:firebase_app/screens/selectprofilepic.dart';
import 'package:firebase_app/services/auth.dart';
import 'package:firebase_app/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import "package:firebase_app/screens/Home/userlist.dart";
import "package:firebase_app/screens/Home/settingsform.dart";
import "package:image_picker/image_picker.dart";
import "package:firebase_storage/firebase_storage.dart";

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

   final AuthService _auth = AuthService();

  String screen = "home";

  void update(){
    showModalBottomSheet(context: context, builder: (context){
      return Container(
          color: Colors.green,
          child: Profile()
      );
    });
  }

   void account(){
     showModalBottomSheet(context: context, builder: (context){
       return Container(
           color: Colors.green,
           child: Account()
       );
     });
   }

   /*final FirebaseMessaging _messaging = FirebaseMessaging();

   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _messaging.getToken().then((token){
      print(token);
    });
  }*/

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User_>(context);
    return StreamProvider<List<userInfo>>.value(
      value: DatabaseService().info,
      child: Scaffold(
            backgroundColor: Colors.blue[50],
            appBar: AppBar(
              backgroundColor: Colors.blue[900],
              title: Text("Home",
              style: TextStyle(
                color: Colors.white
              ),),
              actions: <Widget>[
                FlatButton(
                  onPressed: () async {
                    await _auth.signOut();
                  },
                  child: Text("Logout")
                ),
                FlatButton.icon(
                    onPressed: () {
                      update();
                    },
                  icon: Icon(
                    Icons.settings
                  ),
                  label: Text("settings")

                ),

              ],
            ),
        body: screen == "home"?UserList(): Feed(),
        bottomSheet: BottomAppBar(
          color: Colors.blue[900],
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                InkWell(
                  onTap: (){
                    setState(() {
                      screen = "home";
                    });
                  },
                  child: Icon(
                    Icons.home,
                    color: Colors.white,
                    size: 30.0,
                  ),
                ),
                InkWell(
                  onTap: (){
                    setState(() {
                      screen = "feed";
                    });
                  },
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size:30.0
                  ),
                ),
                InkWell(
                  onTap: (){
                    account();
                  },
                  child: Icon(
                    Icons.account_circle,
                    color: Colors.white,
                    size: 30.0
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }

}

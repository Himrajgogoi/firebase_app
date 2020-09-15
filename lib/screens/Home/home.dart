
import 'dart:io';
import 'package:firebase_app/model/display.dart';
import 'package:firebase_app/services/auth.dart';
import 'package:firebase_app/services/database.dart';
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


  void update(){
    showModalBottomSheet(context: context, builder: (context){
      return Container(
        color: Colors.green,
        child: SettingsForm()
      );
    });
  }

  File sampleImage;

  Future getImage() async {
     var tempImage = await ImagePicker().getImage(source: ImageSource.gallery);

     setState(() {
       sampleImage = File(tempImage.path);
     });
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<userInfo>>.value(
      value: DatabaseService().info,
      child: Scaffold(
            backgroundColor: Colors.purple[50],
            appBar: AppBar(
              backgroundColor: Colors.purple[500],
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
        body: Center(
          child: sampleImage == null? Text("first choose an image"): enableUpload(),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          child: Icon(
              Icons.add
          ),
          onPressed: (){
            getImage();
          },
        ),
          ),
    );
  }

  Widget enableUpload() {
    return Container(
      padding: EdgeInsets.only(top: 20.0),
      child: Column(
        children: <Widget>[
          Image.file(sampleImage, height:300.0, width: 300.0),
          RaisedButton(
            child: Text("upload"),
            onPressed: ()  {
              final StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child("myimage.jpg");
              final StorageUploadTask task = firebaseStorageRef.putFile(sampleImage);
            },
          )
        ],
      ),
    );
  }

}

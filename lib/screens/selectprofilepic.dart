import "dart:io";
import "dart:math";
import 'package:firebase_app/model/user.dart';
import 'package:firebase_app/services/database.dart';
import 'package:firebase_app/shared/loading.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import "package:firebase_app/shared/textdecoration.dart";
import "package:firebase_storage/firebase_storage.dart";
import "package:image_picker/image_picker.dart";

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File newProfilePic;
  String url;
  String uploaded = "";

  Future getImage() async {
    var tempImage = await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      newProfilePic = File(tempImage.path);
    });
  }

  uploadImage(uid) async {
    var time = DateTime.now().millisecondsSinceEpoch;


   final StorageReference storeRef =await FirebaseStorage.instance.ref().child("profilepics/$uid.jpg");
  StorageUploadTask task = storeRef.putFile(newProfilePic);

    task.onComplete.then((value) async => {
    await storeRef.getDownloadURL().then((value) =>{
    print(value),
    setState((){
    uploaded = "true";
    url = value.toString();
    })
    }).catchError((e){
    setState(() {
    uploaded = "false";
    });
    })
    })
    .catchError((e)=>{
    setState(() {
    uploaded = "false";
    })
    });




  }


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
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                  child: CircleAvatar(
                    radius: 50.0,
                    backgroundColor: Colors.white,
                    backgroundImage:data.profilepic != null? NetworkImage(data.profilepic): NetworkImage("https://images.pexels.com/photos/1089842/pexels-photo-1089842.jpeg?auto=compress&cs=tinysrgb&h=650&w=940"),

                  ),
                ),
                newProfilePic != null?
                Image.file(newProfilePic, height:300.0, width: 300.0): Container(),
                FlatButton(
                  color: Colors.white,
                  onPressed: (){
                    if(newProfilePic == null){
                      getImage();
                    }
                    else{
                      uploadImage(user.id);
                    }
                  },
                  child: newProfilePic == null? Text("chooseImage"): Text("uploadImage"),
                ),
                uploaded == "true"? Text("uploaded!"): Container(),
                uploaded == "false"? Text("upload failed!"): Container(),
                Container(
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
                                  url?? data.profilepic);
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
                ),
              ],
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

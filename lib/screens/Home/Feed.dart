import "package:flutter/material.dart";
import "dart:math";
import 'dart:io';
import 'package:firebase_app/model/display.dart';
import 'package:firebase_app/model/user.dart';
import 'package:firebase_app/screens/selectprofilepic.dart';
import 'package:firebase_app/services/auth.dart';
import 'package:firebase_app/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import "package:image_picker/image_picker.dart";
import "package:firebase_storage/firebase_storage.dart";

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {

  final AuthService _auth = AuthService();

  String error;
  String feed;
  String status= " ";
  void update(){
    showModalBottomSheet(context: context, builder: (context){
      return Container(
          color: Colors.green,
          child: Profile()
      );
    });
  }

  File sampleImage;

  Future getImage() async {
    var tempImage = await ImagePicker().getImage(source: ImageSource.gallery, imageQuality: 70);

    setState(() {
      sampleImage = File(tempImage.path);
    });
  }
  void _enableUpload(uid, list) async{
    setState(() {
      status = "Uploading...";
    });
    if(list.length <4){
      var now = DateTime.now().millisecondsSinceEpoch.toString();
      print(now);
      final StorageReference firebaseStorageRef =await  FirebaseStorage.instance.ref().child("uploads/$uid/$uid$now.jpg");
      final StorageUploadTask task =await firebaseStorageRef.putFile(sampleImage);

      task.onComplete.then((val) async {
        firebaseStorageRef.getDownloadURL().then((value) async =>{
          setState((){
            status = "Uploaded";
            feed = value.toString();
          }),
          await DatabaseService(uid: uid).updateFeed(feed)
        }).catchError((e){
          setState(() {
            status = "An error occured";
          });
        });
      });
    }
    else{
      setState(() {
        status = "You reached your max limit on uploads. Delete a few uploads";
      });
    }

  }

  void deletePic() async {
    final StorageReference ref = await FirebaseStorage.instance.getReferenceFromUrl(feed);
    await ref.delete();
  }



  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User_>(context);
    return StreamBuilder<userData>(
      stream: DatabaseService(uid: user.id).UserData,
      builder: (context, snapshot) {
        userData data = snapshot.data;
        return Scaffold(
          body: sampleImage == null? Center(
            child: FlatButton(
              color: Colors.blue,
              onPressed: (){
                getImage();
              },
              child: Text("select", style: TextStyle(color: Colors.white),),
            )
          ): Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(10, 20, 10, 20)
                ,child: Image.file(sampleImage, height: 300.0, width: 300.0),
              ),
              FlatButton(
                color: Colors.blue,
                child: Text("upload", style: TextStyle(color: Colors.white)),
                onPressed: (){
                  _enableUpload(user.id, data.feeds);
                },
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                child: Text("$status"),
              )
            ],
          ),

        );
      }
    );
  }
}

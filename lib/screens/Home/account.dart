import 'package:firebase_app/model/user.dart';
import 'package:firebase_app/services/database.dart';
import 'package:firebase_app/shared/loading.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import "package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart";

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {

  String loader="false";
  String message;

  Future deletePic(String url, uid) async {
    setState(() {
      loader = "true";
    });
    StorageReference storeRef =await FirebaseStorage.instance.getReferenceFromUrl(url);
    storeRef.delete().then((value) async{
      setState((){
        loader = "false";
        message = "deleted!";
      });
      await DatabaseService(uid: uid).deleteFeed(url);
      Navigator.pop(context);
    })
    .catchError((e)=>{
      setState((){
        loader = "false";
        message = "an error occured";
      })
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User_>(context);
    return StreamBuilder<userData>(
      stream: DatabaseService(uid: user.id).UserData,
      builder: (context, snapshot) {
        if(snapshot.hasData){
          userData data = snapshot.data;
          return Scaffold(
            backgroundColor: Colors.grey,
            appBar: AppBar(
              elevation: 0.0,

              title: Text("Your Uploads"),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
              child: StaggeredGridView.countBuilder(crossAxisCount: 5,
                itemCount: data.feeds.length,
                itemBuilder: (BuildContext context, int index)=>  InkWell(
                  onLongPress: (){
                    showDialog(context: context,
                    builder: (BuildContext context){
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 265.0, horizontal: 30.0),
                        color: Colors.white,
                        child:loader == "false"?Container(
                          child:message == null? Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(5.0, 15.0, 10.0, 5.0),
                                child: Text("Delete?", style: TextStyle(fontSize: 20.0)),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(5.0, 15.0, 10.0, 5.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    FlatButton(
                                      onPressed: ()async{
                                       await deletePic(data.feeds[index], user.id);
                                      },
                                      color: Colors.red,
                                      child: Text("delete", style: TextStyle(
                                        color: Colors.white
                                      ),),
                                    ),
                                    FlatButton(
                                      onPressed: (){
                                        Navigator.pop(context);
                                      },
                                      color: Colors.blue,
                                      child: Text("cancel", style: TextStyle(
                                          color: Colors.white
                                      ),),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ): Padding(
                            padding: const EdgeInsets.fromLTRB(5.0, 15.0, 10.0, 8.0),
                            child: Text("$message", style: TextStyle(fontSize: 20.0)),
                          ),
                        ): Loading(),
                      );
                    });
                  },
                    child: Image.network(data.feeds[index])),
                staggeredTileBuilder: (int index)=>
                new StaggeredTile.count(2, index.isEven? 2:2),
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,),
            )
          );

        }
        else{
          return Center(
            child: Loading()
          );
        }

      }
    );
  }
}

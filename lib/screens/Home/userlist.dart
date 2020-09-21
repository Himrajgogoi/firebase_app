import 'package:firebase_app/model/display.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  List<String> feed = [];
  String success = "false";

  _buildList(userInfo item) {
    if(item.feeds.isNotEmpty){
  return Column(
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("Submitted by-"),
            Text("${item.name}",
            style: TextStyle(fontSize: 18.0)),
          ],
        )
      ),
      for(var pic in item.feeds) Container(
          margin: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
          child: Image.network(pic))

    ],
  );}
    else{
      return SizedBox(height: 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final users = Provider.of<List<userInfo>>(context) ?? [];

  return ListView.builder(itemCount: users.length,itemBuilder: (context, index){
    return _buildList(users[index]);
  },);
  }
}
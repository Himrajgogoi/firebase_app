import 'package:firebase_app/model/display.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {



  _buildList(userInfo item){
    return Card(
      margin: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
      child: ListTile(
        leading: Icon(
          Icons.person
        ),
        title: Text("${item.name}"),
        subtitle: Text("${item.email} &  ${item.phone}"),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    final users = Provider.of<List<userInfo>>(context)?? [];

    return ListView.builder(itemCount: users.length,
    itemBuilder: (context, index){
      return _buildList(users[index]);
    },);
  }
}

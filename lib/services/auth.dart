import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:firebase_app/model/user.dart";

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference userCollection = FirebaseFirestore.instance.collection("userInfo");


  User_ _userFromFirebaseUser(User user){
    return user != null? User_(id: user.uid) : null;
  }
  
  Stream<User_> get user {
    return _auth.authStateChanges()
        .map(_userFromFirebaseUser);
  }
  
  Future registerWithEmailAndPassword(String email, String password, String name, String phone) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = result.user;

      await DatabaseService(uid: user.uid).updateData(name, email, phone);
      return _userFromFirebaseUser(user);
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }
  
  Future signInWithEmailAndPassword(String email, String password) async {
    String exists = " ";
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      await userCollection.doc(user.uid).get().then((val){
        if(val.exists) {
          exists = "yes";
        }
        else{
          exists = "no";
        }});
      if(exists == "yes"){
        return _userFromFirebaseUser(user);
      }
      else if(exists == "no"){
        await DatabaseService(uid: user.uid).updateData("new member", email, "N/A");
        return _userFromFirebaseUser(user);
      }

    }
    catch(e){
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try{
      return await _auth.signOut();
    }
    catch(e){
      print(e.toString());
      return null;
    }

  }

}


import 'package:firebase_app/model/user.dart';
import "package:firebase_app/model/display.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_app/services/auth.dart";

class DatabaseService {

  final AuthService auth = AuthService();

  final String uid;
  DatabaseService({this.uid});
  String error;

  //creating a collection
  final CollectionReference userCollection = FirebaseFirestore.instance
      .collection("userInfo");

  //creating data
  Future createData(String name, String email, String phone, String pic) async {
    return await userCollection.doc(uid).set({
      "name": name,
      "email": email,
      "phone": phone,
      "profilepic": pic,
      "feeds": []
    });
  }
  Future updateData(String name, String email, String phone, String pic) async {
    return await userCollection.doc(uid).update({
      "name": name,
      "email": email,
      "phone": phone,
      "profilepic": pic,
    });
  }

  Future updateFeed(String pic) async {
        return await userCollection.doc(uid).update({
          "feeds": FieldValue.arrayUnion([pic]),
        });


  }
  Future deleteFeed(String pic) async {
    return await userCollection.doc(uid).update({
      "feeds": FieldValue.arrayRemove([pic]),
    });
  }

  //deleting data
  Future deleteData() async {
    await userCollection.doc(uid).delete();
    return await auth.signOut();
  }


  List<userInfo> _userDataSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return userInfo(
          name: doc.data()["name"] ?? "new member",
          email: doc.data()["email"] ?? "not given",
          phone: doc.data()["phone"] ?? "not provided",
        profilepic:  doc.data()["profilepic"]?? "not provided",
        feeds: doc.data()["feeds"]?? []
      );
    }).toList();
  }

  Stream<List<userInfo>> get info {
    return userCollection.snapshots()
        .map(_userDataSnapshot);
  }

  userData _userSnapshot(DocumentSnapshot snapshot) {
    return userData(
      id: uid,
      name: snapshot.data()["name"],
      email: snapshot.data()["email"],
      phone: snapshot.data()["phone"],
      profilepic: snapshot.data()["profilepic"],
        feeds: snapshot.data()["feeds"] ?? []
    );
  }

  Stream<userData> get  UserData {
    return userCollection.doc(uid).snapshots()
        .map(_userSnapshot);

  }

}

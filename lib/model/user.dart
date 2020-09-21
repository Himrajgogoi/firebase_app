class User_ {
  final String id;
  User_({this.id});
}

class userData {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String profilepic;
  List<dynamic> feeds=[];
  userData({this.id, this.name, this.email, this.phone, this.profilepic, this.feeds});
}
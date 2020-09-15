import 'package:flutter/material.dart';
import "package:flutter_spinkit/flutter_spinkit.dart";

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SpinKitHourGlass(
          size: 50.0,
          color: Colors.deepPurple,
        )
      ),
    );
  }
}

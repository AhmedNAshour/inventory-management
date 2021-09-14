import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:inventory/constants.dart';
class Loading extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: Colors.white,
      child: Center(
        child: SpinKitThreeBounce(
          color: kPrimaryColor,
          size: size.height*0.1
        ),
      ),
    );
  }
}
class NoMoreUsers extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: size.height * 0.2),
      child: Text(
        'You have no employees to fire',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 25,
          color: kPrimaryColor,
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }
}


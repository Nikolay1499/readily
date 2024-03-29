import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:readily/password.dart';
import 'package:readily/start.dart';

SharedPreferences prefs;
class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
{

  startTime() async {
    var _duration = new Duration(seconds: 0);
    return new Timer(_duration, checkFirstSeen);
  }


  Future checkFirstSeen() async {
    prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);
    if (_seen)
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(
          builder: (context) => StartScreen(),
        ),
      );
    else
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(
          builder: (context) => PasswordScreen(),
        ),
      );
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      /*backgroundColor: Colors.white,
      body: new Container(
        color: Colors.cyan,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children:[
            Transform.translate(
              offset: Offset(-15, 0),
              child: new Image.asset('assets/book.png'),
            ),
            Transform.translate(
              offset: Offset(0, 15),
              child:new SpinKitThreeBounce(
                color: Colors.white,
                size: 50.0,
              ),
            ),
          ]),
      ),*/
    );
  }

}
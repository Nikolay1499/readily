import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
{

  startTime() async {
    var _duration = new Duration(seconds: 4);
    return new Timer(_duration, checkFirstSeen);
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed('/CountDownTimer');
  }


  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //prefs.setBool('seen', false);
    bool _seen = (prefs.getBool('seen') ?? false);
    if (_seen)
      Navigator.of(context).pushReplacementNamed('/CountDownTimer');
    else
      Navigator.of(context).pushReplacementNamed('/PasswordScreen');
}

  @override
  void initState() {
    super.initState();
    startTime();
    //checkFirstSeen();
  }
  @override
  Widget build(BuildContext context) {
  return new Scaffold(
    backgroundColor: Colors.white,
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
    ),
  );
  }

}
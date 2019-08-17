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
    var _duration = new Duration(seconds: 7);
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
  }
  @override
  Widget build(BuildContext context) {
  return new Scaffold(
    backgroundColor: Colors.white,
    body: new Center(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children:[
          new Image.asset('assets/splash.gif'),
          Transform.translate(
            offset: Offset(0, 30),
            child:new SpinKitThreeBounce(
              color: Colors.blue,
              size: 75.0,
            ),
          ),
        ]),
    ),
  );
  }

}
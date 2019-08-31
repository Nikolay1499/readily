import 'package:flutter/material.dart';
import 'login.dart';
import 'splash.dart';
import 'counter.dart';

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.cyan,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Надчети се",
                style: TextStyle(fontSize: 50)),
              SizedBox(height: 100),
              RaisedButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                color: Colors.tealAccent,
                onPressed: () {
                  prefs.setString("Name", null);
                  prefs.getString('Name') != null ? 
                    Navigator.pushReplacement(
                        context, 
                        MaterialPageRoute(
                          builder: (context) => CountDownTimer(),
                        ),
                    )
                  :
                    signInWithGoogle().whenComplete(() {
                      prefs.setString("Name", name);
                      prefs.setString("Email", email);
                      prefs.setString("URL", imageUrl);
                      Navigator.pushReplacement(
                        context, 
                        MaterialPageRoute(
                          builder: (context) => CountDownTimer(),
                        ),
                      );
                    });
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Container(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          'Старт',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    ),
                  ),
                ), 

            ],
          ),
        ),
      ),
    );
  }
}

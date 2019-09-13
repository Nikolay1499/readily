import 'package:flutter/material.dart';
import 'package:readily/login.dart';
import 'package:readily/size.dart';
import 'package:readily/splash.dart';
import 'package:readily/counter.dart';
import 'package:readily/display.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:readily/firestore.dart';

String selectedType;

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  
List<String> _accountType = <String>[
    '1 клас',
    '2 клас',
    '3 клас',
    '4 клас'
  ];

  Future<void> _ackAlert(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Проблем',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 50,
            ),
          ),
          content: Text('Моля изберете клас преди да продължите!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 35,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('ОК',
                style: TextStyle(
                  fontSize: 40,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void loginRemember()
  {
    name = prefs.getString('Name');
    email = prefs.getString('Name');
    Navigator.pushReplacement(
        context, 
        MaterialPageRoute(
          builder: (context) => CountDownTimer(),
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Container(
        color: Colors.cyan,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: SizeConfig.blockSizeVertical * 50,
                width: SizeConfig.blockSizeHorizontal * 75,
                child: Image(
                  image: AssetImage("assets/logo.png"),
                ),
              ),
              SizedBox(height: SizeConfig.blockSizeVertical * 5,),
              Column(
                children: [
                  Text("Моля изберете клас:",
                  textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: SizeConfig.safeBlockHorizontal * 12,
                      color: Colors.white,
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(0, -7),
                    child: Container(
                      //color: Colors.white,
                      child: DropdownButton(
                        items: _accountType
                            .map((value) => DropdownMenuItem(
                                  child: Text(
                                    value,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: SizeConfig.safeBlockHorizontal * 8,
                                      color: Colors.red,
                                    ),
                                  ),
                                  value: value,
                                ))
                            .toList(),
                        onChanged: (selectedAccountType) {
                          setState(() {
                            selectedType = selectedAccountType;
                          });
                        },
                        value: selectedType,
                        isExpanded: false,
                        hint: Transform.translate(
                          offset: Offset(20, 0),
                          child: Text(
                            'Клас',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: SizeConfig.safeBlockHorizontal * 8,
                              color: Colors.white
                            ),
                          ),
                        ), 
                        
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: SizeConfig.blockSizeVertical * 5,),
              RaisedButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                color: Colors.cyanAccent,
                onPressed: () {
                  checkInternet().then((intenet) {
                    if (intenet != null && intenet) {
                      if(selectedType == null)
                      _ackAlert(context);
                    else
                    {
                      prefs.setString("Name", null);
                      prefs.getString('Name') != null ? 
                        loginRemember()
                      :
                        signInWithGoogle().whenComplete(() {
                          if(imageUrl != null)
                          {
                            prefs.setString("Name", name);
                            prefs.setString("Email", email);
                            prefs.setString("URL", imageUrl);
                            final DocumentReference documentReference =
                              Firestore.instance.collection("leaderboard").document(email);
                            documentReference.snapshots().listen((datasnapshot) {
                              if (!datasnapshot.exists)
                                createRecord(selectedType);
                            });
                            Navigator.pushReplacement(
                              context, 
                              MaterialPageRoute(
                                builder: (context) => CountDownTimer(),
                              ),
                            );
                          }
                          
                        });
                      }
                    }
                    else
                      noInternetPanel(context);
                  });
                    
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                  child: Container(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Text(
                          'Старт',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 10,
                            color: Colors.white,
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

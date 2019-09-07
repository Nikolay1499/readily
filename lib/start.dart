import 'package:flutter/material.dart';
import 'login.dart';
import 'splash.dart';
import 'counter.dart';
import 'display.dart';

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
              Transform.translate(
                child: Transform.scale(
                  child: Image(
                    image: AssetImage("assets/book.png"),
                  ),
                  scale: 1.2,
                ),
                offset: Offset(-8, 30),
              ),
              Text("Надчети се",
                style: TextStyle(
                  fontSize: 80,
                  color: Colors.yellow[700],
                ),
              ),
              Column(
                children: [
                  Text("Моля изберете клас:",
                  textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 38,
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
                                      fontSize: 35,
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
                          offset: Offset(25, 0),
                          child: Text(
                            'Клас',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.white
                            ),
                          ),
                        ), 
                        
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
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
                      }
                    }
                    else
                      noInternetPanel(context);
                  });
                    
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Container(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Text(
                          'Старт',
                          style: TextStyle(
                            fontSize: 40,
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

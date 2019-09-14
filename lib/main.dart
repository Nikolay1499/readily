import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:readily/counter.dart';
import 'package:readily/size.dart';
import 'package:readily/splash.dart';
import 'package:readily/camera.dart';
import 'package:readily/leaderboard.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:readily/login.dart';
import 'package:readily/start.dart';

CameraDescription firstCamera;

Future<void> main() async {
  final cameras = await availableCameras();
  firstCamera = cameras[0];
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    )); 
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Readily',
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        accentColor: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}

class DrawerWidget extends StatefulWidget
{
  final String activePage;
  DrawerWidget({Key key, @required this.activePage,}) : super(key: key);

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}
class _DrawerWidgetState extends State<DrawerWidget>
{
  Route currentRoute;
  bool tappedFirst = false;
  bool tappedSecond = false;
  bool tappedThird = false;
  bool tappedFourth = false;

  @override
  void initState()
  {
    super.initState();
  }

  Future<void> _privacy(BuildContext context) {
    String text = 'Приложението "Надчети се" е предвидено за Основно училище "Христо Ботев" село Брестовица ' 
                + 'с цел използване от техните ученици. ' 
                + 'Информираме ви, че приложението събира информация за потребителите си! ' 
                + 'Личната информация е: вашите имена, имейл и клас на ученика. Друга информация са вашите резултати! '
                + 'Събраната информация не се разпространява и единственото и приложение е за изготвяне '
                + 'на класациите на потребителите! При желание за премахване на данните ви от системата моля пишете на '
                + 'имейлът посочен в страницата на приложението в Google Play!';
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: AutoSizeText('Поверителност на данните и условия',
            maxLines: 2,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 50,
            ),
          ),
          content: SingleChildScrollView(
            child: new ConstrainedBox(
                constraints: BoxConstraints(),
                  child: Text(text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 35,
                    ),
                  ),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: AutoSizeText('Приемам условията',
                maxLines: 1,
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
  Widget build(BuildContext context)
  {
    return SizedBox(
      width: 150,
      child: Drawer(
        child: Column(
          children: [
            new Container(
              width: 150,
              child: new DrawerHeader(
                child: Column(
                  children: [
                    Container(
                      width: 90.0,
                      height: 90.0,
                      decoration: BoxDecoration(
                        color: Colors.yellow[700],
                        shape: BoxShape.circle,
                      ),
                      child: GestureDetector(
                        onTap: () => _privacy(context),
                        child: Center(
                          child: Transform.translate(
                            offset: Offset(0, 10),
                            child: AutoSizeText(name[0],
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 80)
                            ),
                          ),
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset: Offset(0, 10),
                      child: AutoSizeText(name,
                        maxLines: 1, 
                        style: TextStyle(fontSize: 35), 
                      ),
                    ),
                  ])),
              color: Colors.cyan,),
            GestureDetector(
              onTapDown: (TapDownDetails details) {
                setState(() {
                  tappedFirst = true;  
                });
              },
              onTapUp: (TapUpDetails details) {
                setState(() {
                  tappedFirst = false;  
                });
              },
              onTapCancel: () {
                setState(() {
                  tappedFirst = false;  
                });
              },
              onTap: () {
                final newRouteName = "/CountDownTimer";
                if (widget.activePage != newRouteName)
                {
                  setState(() {
                    tappedFirst = true;  
                  });
                  Navigator.pushReplacement(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => CountDownTimer(),
                    ),
                  );
                }
              },
              child: Container(
                color: tappedFirst ? Colors.cyanAccent : 
                  (widget.activePage == "/CountDownTimer" ? Colors.grey[300]  : Colors.white),
                child: ListTile(
                  contentPadding: EdgeInsets.only(left: 12, right: 0),
                  leading: Icon(Icons.timer),
                  title: Transform.translate(
                    offset: Offset(-15, 0),
                    child: AutoSizeText("Засечи",
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 28,
                      ),
                    ),
                  ), 
                ),
              ),
            ),
            GestureDetector(
              onTapDown: (TapDownDetails details) {
                setState(() {
                  tappedSecond = true;  
                });
              },
              onTapUp: (TapUpDetails details) {
                setState(() {
                  tappedSecond = false;  
                });
              },
              onTapCancel: () {
                setState(() {
                  tappedSecond = false;  
                });
              },
              onTap: () {
                final newRouteName = "/CameraScreen";
                if (widget.activePage != newRouteName)
                {
                  setState(() {
                    tappedSecond = true;  
                  });
                  Navigator.pushReplacement(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => CameraScreen(camera: firstCamera,),
                    ),
                  );
                }
              },
              child: Container(
                color: tappedSecond ? Colors.cyanAccent :
                  (widget.activePage == "/CameraScreen" ? Colors.grey[300] : Colors.white),
                child: ListTile(
                  contentPadding: EdgeInsets.only(left: 12, right: 0),
                  leading: Icon(Icons.camera_alt),
                  title: Transform.translate(
                    offset: Offset(-15, 0),
                    child: AutoSizeText("Снимай",
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 28,
                      ),
                    ),
                  ), 
                  
                ),
              ),
            ),
            GestureDetector(
              onTapDown: (TapDownDetails details) {
                setState(() {
                  tappedThird = true;  
                });
              },
              onTapUp: (TapUpDetails details) {
                setState(() {
                  tappedThird = false;  
                });
              },
              onTapCancel: () {
                setState(() {
                  tappedThird = false;  
                });
              },
              onTap: () {
                final newRouteName = "/LeaderboardScreen";
                if (widget.activePage != newRouteName)
                {
                  setState(() {
                    tappedThird = true;  
                  });
                  Navigator.pushReplacement(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => LeaderboardScreen(),
                    ),
                  );
                }
              },
              child: Container(
                color: tappedThird ? Colors.cyanAccent : 
                  (widget.activePage == "/LeaderboardScreen" ? Colors.grey[300]  : Colors.white),
                child: ListTile(
                  contentPadding: EdgeInsets.only(left: 12, right: 0),
                  leading: Icon(Icons.star),
                  title: Transform.translate(
                    offset: Offset(-15, 0),
                    child: AutoSizeText("Класация",
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 28,
                      ),
                    ),
                  ), 
                  
                ),
              ),  
            ),
            new Expanded(
              child: new Align(
                alignment: Alignment.bottomCenter,
                child:
                  GestureDetector(
                    onTapDown: (TapDownDetails details) {
                      setState(() {
                        tappedFourth = true;  
                      });
                    },
                    onTapUp: (TapUpDetails details) {
                      setState(() {
                        tappedFourth = false;  
                      });
                    },
                    onTapCancel: () {
                      setState(() {
                        tappedFourth = false;  
                      });
                    },
                    onTap: () {
                      final newRouteName = "/StartScreen";
                      if (widget.activePage != newRouteName)
                      {
                        setState(() {
                          tappedFourth = true;  
                        });
                        signOutGoogle();
                        Navigator.pushReplacement(
                          context, 
                          MaterialPageRoute(
                            builder: (context) => StartScreen(),
                          ),
                        );
                      }
                    },
                    child: Container(
                      color: tappedFourth ? Colors.cyanAccent : 
                        (widget.activePage == "/StartScreen" ? Colors.grey[300]  : Colors.white),
                      child: ListTile(
                        contentPadding: EdgeInsets.only(left: 12, right: 0),
                        leading: Icon(Icons.reply),
                        title: Transform.translate(
                          offset: Offset(-10, 0),
                          child: AutoSizeText("Изход",
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 28,
                            ),
                          ),
                        ), 
                      ),
                    ),  
                  ),
              ),
            ),
          ],
        ),
      ));
  }
}


import 'package:flutter/material.dart';
import 'counter.dart';
import 'splash.dart';
import 'camera.dart';
import 'password.dart';
import 'leaderboard.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Pattaya',
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        accentColor: Colors.red,
      ),
      home: SplashScreen(),
      routes: <String, WidgetBuilder>{
      '/CountDownTimer': (BuildContext context) => new CountDownTimer(),
      '/CameraScreen' : (BuildContext context) => new CameraScreen(),
      '/LeaderboardScreen' : (BuildContext context) => new LeaderboardScreen(),
      '/PasswordScreen' : (BuildContext context) => new PasswordScreen(),
    },
    );
  }
}

class SlideRightRoute extends PageRouteBuilder {
  final Widget page;
  SlideRightRoute({this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
        );
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

  @override
  void initState()
  {
    super.initState();
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
                    new Container(
                      width: 90.0,
                      height: 90.0,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text("Н", 
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 40))),
                    ),
                    Transform.translate(
                      offset: Offset(0, 15),
                      child: Text("Николай", style: TextStyle(fontSize: 20))),
                  ])),
              color: Colors.tealAccent,),
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
                if (ModalRoute.of(context).settings.name != newRouteName)
                {
                  setState(() {
                    tappedFirst = true;  
                  });
                  Navigator.of(context).pushReplacementNamed(newRouteName);
                }
              },
              child: Container(
                color: tappedFirst ? Colors.cyanAccent : 
                  (widget.activePage == "/CountDownTimer" ? Colors.grey : Colors.white),
                child: ListTile(
                  leading: Icon(Icons.timer),
                  title: Text("Засечи"),
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
                if (ModalRoute.of(context).settings.name != newRouteName)
                {
                  setState(() {
                    tappedSecond = true;  
                  });
                  Navigator.of(context).pushReplacementNamed(newRouteName);
                }
              },
              child: Container(
                color: tappedSecond ? Colors.cyanAccent :
                  (widget.activePage == "/CameraScreen" ? Colors.grey : Colors.white),
                child: ListTile(
                  leading: Icon(Icons.camera_alt),
                  title: Text("Снимай"),
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
                if (ModalRoute.of(context).settings.name != newRouteName)
                {
                  setState(() {
                    tappedThird = true;  
                  });
                  Navigator.of(context).pushReplacementNamed(newRouteName);
                }
              },
              child: Container(
                color: tappedThird ? Colors.cyanAccent : 
                  (widget.activePage == "/LeaderboardScreen" ? Colors.grey : Colors.white),
                child: ListTile(
                  leading: Icon(Icons.star),
                  title: Text("Класация"),
                ),
              ),  
            ),
          ],
        ),
      ));
  }
}


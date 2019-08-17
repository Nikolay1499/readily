import 'package:flutter/material.dart';
import 'main.dart';


class LeaderboardScreen extends StatefulWidget {
  @override
  _LeaderboardScreenState createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State
{
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer:  DrawerWidget(activePage: "/LeaderboardScreen",),
      body: Center(
        child: Text("Ето ти класация", style: TextStyle(fontSize: 25)),
      ),
    );
  }
}
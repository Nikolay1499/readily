import 'package:flutter/material.dart';
import 'main.dart';


class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State
{
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer:  DrawerWidget(activePage: "/CameraScreen",),
      body: Center(
        child: Text("Представи си, че има камера тук", style: TextStyle(fontSize: 25)),
      ),
    );
  }
}
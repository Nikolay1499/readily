import 'package:flutter/material.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'camera.dart';
import 'main.dart';
import 'dart:math' as math;

class WordsScreen extends StatefulWidget {

  final VisionText readText;
  final List<String> existingList;
  WordsScreen({Key key, @required this.readText, 
                      @required this.existingList}) : super(key: key);

  @override
  _WordsScreenState createState() => _WordsScreenState();
}

class _WordsScreenState extends State<WordsScreen>
{ 
  List<String> list = List<String>();
  int first, second;
  @override
  void initState()
  {
    super.initState();
    first = -1;
    second = -1;
    list = widget.existingList;
    if(widget.readText != null)
      for (TextBlock block in widget.readText.blocks)
        for (TextLine line in block.lines)
          for (TextElement word in line.elements)
            if(word.text != null)
            {
              print(word.text);
              list.add(word.text);
            }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
        Transform.rotate(
          angle: 2 * math.pi,
          child: Container(
            alignment: Alignment.center,
            child: (ListView(
              padding: const EdgeInsets.all(40.0),
              children: [
                for(int i = 0; i < list.length; i++)
                  GestureDetector(
                    child: Container(
                      color: (i == first || i == second) 
                        ? Colors.red : Colors.grey,
                      padding: const EdgeInsets.all(40.0),
                      alignment: Alignment.center,
                      child: Text(list[i], style: TextStyle(fontSize: 30)),
                    ),
                    onTap: (){
                      if(first == -1)
                        setState(() {
                          first = i;
                        }); 
                      else if(second == -1 && i != first)
                        setState(() {
                          second = i;
                        }); 
                      else
                      {
                        if(i == first)
                          setState(() {
                            first = -1;
                          });
                        else if(i == second)
                          setState(() {
                            second = -1;
                          });
                        else if(second == -1 && i == first)
                          setState(() {
                            first = -1;
                          });
                        else
                          setState(() {
                            second = i;
                          });
                      }
                    },
                  ),
                Text((second != -1 && first != -1) 
                  ? ((second - first).abs() + 1).toString() : "", 
                  style: TextStyle(fontSize: 30)),
              ],
            ))
          ),
        ),
        
      floatingActionButton: 
        FloatingActionButton(
          child: Icon(Icons.add_a_photo, size: 20,),
          onPressed: () {
            Navigator.pushReplacement(
              context, 
              MaterialPageRoute(
                builder: (context) => 
                  CameraScreen(camera: firstCamera, existingList: list),
              ),
            );
          },
        ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
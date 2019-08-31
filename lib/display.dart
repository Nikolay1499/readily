import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'camera.dart';
import 'main.dart';
import 'words.dart';
import 'package:http/http.dart' as http;
import 'models.dart';
import 'key.dart';




class DisplayPictureScreen extends StatefulWidget {

  final File imagePath;
  final List<String> existingList;
  const DisplayPictureScreen({Key key, @required this.imagePath, 
      this.existingList}) : super(key: key);
  @override
  _DisplayPictureScreenState createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {

  //Used for onDevice OCR
  /*Future readText() async {
    FirebaseVisionImage ourImage = FirebaseVisionImage.fromFile(widget.imagePath);
    TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();
    VisionText readText = await recognizeText.processImage(ourImage);

    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(
        builder: (context) => 
          WordsScreen(readText: readText, 
          existingList: widget.existingList == null ? [] : widget.existingList,),
      ),
    );
    
  }*/

  Future readText() async
  {
    String base64Image = base64Encode(widget.imagePath.readAsBytesSync());
    String body = """{
      'requests': [
        {
          'image': {
            'content' : '$base64Image'
          },
          'features': [
            {
              'type': 'DOCUMENT_TEXT_DETECTION'
            }
          ]
        }
      ]
    }""";

    http.Response res = await http
      .post(
        APIKey.getKey(),
        body: body
      );

 
    final jsonResponse = json.decode(res.body);
    Responses responses = new Responses.fromJson(jsonResponse);
    print(responses.responses[0].textAnnotations[0].description);

    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(
        builder: (context) => 
          WordsScreen(readText: responses.responses[0].textAnnotations[0].description, 
          existingList: widget.existingList == null ? [] : widget.existingList,),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: 
        Transform.translate(
          offset: Offset(0, 19),
          child: Container(
            height: 550,
            child : Image.file(widget.imagePath),
          ),
        ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Transform.translate(
        offset: Offset(0, -15),
        child:
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton(
                child: Icon(Icons.check),
                onPressed: readText,
                heroTag: "textTag",
              ),
              SizedBox(width: 100),
              FloatingActionButton(
                heroTag: "back",
                child: Icon(Icons.clear),
                onPressed: () {
                  Navigator.pushReplacement(
                  context, 
                  MaterialPageRoute(
                    builder: (context) => 
                      CameraScreen(camera: firstCamera, existingList: widget.existingList),
                  ),
                );
                },
              ),
            ],
          ),
      ),
    );
  }
}
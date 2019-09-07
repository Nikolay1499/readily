import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'camera.dart';
import 'main.dart';
import 'words.dart';
import 'package:http/http.dart' as http;
import 'models.dart';
import 'key.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:connectivity/connectivity.dart';

  Future<bool> checkInternet() async
  {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    else
      return false;
  }

  Future<void> noInternetPanel(BuildContext context) {
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
          content: Text('Няма връзка с интернет. Моля свържете се ' 
                      + 'с WiFi или мобилен интернет и опитайте отново!',
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
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }


class DisplayPictureScreen extends StatefulWidget {

  final File imagePath;
  final List<String> existingList;
  const DisplayPictureScreen({Key key, @required this.imagePath, 
      this.existingList}) : super(key: key);
  @override
  _DisplayPictureScreenState createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {

  bool isWaiting = false;




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

  //Use this request to use the cloud to non-Latin characters
  Future readText() async
  {

    setState(() {
     isWaiting = true; 
    });

    var timer = Timer(Duration(seconds: 10), () {
      _ackAlert(context);
    });

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

    if(responses != null)
    {
      timer.cancel();
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(
          builder: (context) => 
            WordsScreen(readText: responses.responses[0].textAnnotations[0].description, 
            existingList: widget.existingList == null ? [] : widget.existingList,),
        ),
      );
    }
  }


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
          content: Text('Не беше намерен текст в тази снимка! Моля снимайте отново!',
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
        );
      },
    );
  }

    

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer:  DrawerWidget(activePage: "/DisplayScreen",),
      backgroundColor: Colors.cyan,
      body: 
        !isWaiting ?
          Transform.translate(
            offset: Offset(0, 19),
            child: Container(
              height: 550,
              child : Image.file(widget.imagePath),
            ),
          )
        :
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Изчакайте",
                  style: TextStyle(
                    fontSize: 50, 
                    color: Colors.white
                  ),
                ),
                Transform.translate(
                  offset: Offset(0, 20),
                  child: SpinKitPouringHourglass(
                    color: Colors.white, 
                    size: 200),
                ),
              ],
            ),
          ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Transform.translate(
        offset: Offset(0, -15),
        child:
        !isWaiting ?
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton(
                child: Icon(Icons.check),
                onPressed: () {
                  checkInternet().then((intenet) {
                    if (intenet != null && intenet) {
                      readText();
                    }
                    else
                      noInternetPanel(context);
                  });
                },
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
          )
        :
          null,
      ),
    );
  }
}

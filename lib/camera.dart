import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:readily/display.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:readily/size.dart';
import 'package:readily/words.dart';
import 'package:readily/main.dart';
import 'package:readily/counter.dart';

class CameraScreen extends StatefulWidget {
  final CameraDescription camera;
  final List<String> existingList;
  const CameraScreen({
    Key key,
    @required this.camera,
    this.existingList,
  }) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    if(controller.isAnimating)
      controller.stop();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
  
    return WillPopScope(
      onWillPop: () {
        return Navigator.pushReplacement(
          context, 
          MaterialPageRoute(
            builder: (context) => 
              CountDownTimer(),
          ),
        );
      },
      child: Scaffold(
        backgroundColor: Colors.cyan,
        drawer: DrawerWidget(activePage: "/CameraScreen",),
        body: Transform.translate(
          offset: Offset(0, 24),
          child: Container(
            height: SizeConfig.blockSizeVertical * 80,
            child: FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return CameraPreview(_controller);
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ), 
        ),         
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Transform.translate(
          offset: Offset(0, -15),
          child: widget.existingList == null ?
            FloatingActionButton(
              child: Icon(Icons.camera_alt),
              onPressed: () async {
                try {
                  await _initializeControllerFuture;
                  final path = join(
                    (await getTemporaryDirectory()).path,
                    '${DateTime.now()}.png',
                  );
                  await _controller.takePicture(path);
                  Navigator.pushReplacement(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => 
                        DisplayPictureScreen(imagePath: File(path)),
                    ),
                  );
                } catch (e) {
                  print(e);
                }
              },
            )
            :
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  child: Icon(Icons.camera_alt),
                  onPressed: () async {
                    try {
                      await _initializeControllerFuture;
                      final path = join(
                        (await getTemporaryDirectory()).path,
                        '${DateTime.now()}.png',
                      );
                      await _controller.takePicture(path);
                      Navigator.pushReplacement(
                        context, 
                        MaterialPageRoute(
                          builder: (context) => 
                                DisplayPictureScreen(imagePath: File(path), 
                                  existingList: widget.existingList),
                        ),
                      );
                    } catch (e) {
                      print(e);
                    }
                  },
                  heroTag: "photo",
                ),
                SizedBox(width: width / 3.6),
                FloatingActionButton(
                  heroTag: "back",
                  child: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => 
                          WordsScreen(readText: null, 
                            existingList: widget.existingList),
                      ),
                    );
                  },
                ),
              ],
            ),
        ),
        
      ),
    );
  }
}
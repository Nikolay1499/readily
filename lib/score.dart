import 'package:auto_size_text/auto_size_text.dart';
import 'package:readily/counter.dart';
import 'package:readily/leaderboard.dart';
import 'package:flutter/material.dart';
import 'package:readily/firestore.dart';
import 'package:readily/main.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:readily/camera.dart';

class ScoreScreen extends StatefulWidget {

  final int score;
  final String text;
  ScoreScreen({Key key, @required this.score, @required this.text}) 
        : super(key: key);

  @override
  _ScoreScreenState createState() => _ScoreScreenState();
}

class _ScoreScreenState extends State<ScoreScreen>
{
  int score;
  String text = "Резултат";
  @override
  void initState()
  {
    super.initState();
    addToArrayRecord(widget.score);
  }
  



  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    print(height.toString() + " " + width.toString());
    return WillPopScope(
      onWillPop: () {
        return Navigator.pushReplacement(
          context, 
          MaterialPageRoute(
            builder: (context) => 
              CameraScreen(camera: firstCamera),
          ),
        );
      },
      child: Scaffold(
        backgroundColor: Colors.cyan,
        drawer: DrawerWidget(activePage: "/ScoreScreen"),
        body: Stack(
        children: [
          Positioned(
            left: width / 7.2,
            right: width / 7.2,
            top: width / 13.84,
            bottom: width / 13.84,
            child: Container(
              alignment: Alignment(0.0, height / (height * 10)),
              decoration: BoxDecoration(
                color: Colors.yellow[700],
                shape: BoxShape.circle,
              ),
              child: AutoSizeText(
                widget.score.toString(),
                textAlign: TextAlign.center,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 200,
                  color: Colors.white,
                ),
            ),
            ),
          ),
          Positioned(
            top: height / 5.77,
            bottom: 0,
            left: 0,
            right: 0,
            child: AutoSizeText(
              widget.text,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 90,
                color: Colors.white,
              ),
            ),
          ),
          widget.text == "Нов рекорд:" ?
          FlareActor("assets/confetti.flr", animation : "boom"):
          FlareActor("assets/stars.flr", animation : "estrellas"),
          Positioned(
            top: height * 57 / 80,
            left: width / 4,
            right: width / 4,
            bottom: height * 16 / 80,
            child: RaisedButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
              color: Colors.yellow[700],
              onPressed: (){
                Navigator.pushReplacement(
                  context, 
                  MaterialPageRoute(
                    builder: (context) => 
                      CountDownTimer(),
                  ),
                );
              },
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, (width / 69.2), 0, (width / 72)),
                child: Container(
                  child: Padding(
                    padding: EdgeInsets.only(left: (width / 36), right: (width / 36)),
                    child: AutoSizeText(
                      'Отново',
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 40,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: height * 65 / 80,
            left: width / 4,
            right: width / 4,
            bottom: height * 8 / 80,
            child: RaisedButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
              color: Colors.yellow[700],
              onPressed: (){
                Navigator.pushReplacement(
                  context, 
                  MaterialPageRoute(
                    builder: (context) => 
                      LeaderboardScreen(),
                  ),
                );
              },
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, (width / 36), 0, (width / 72)),
                child: Container(
                  child: Padding(
                    padding: EdgeInsets.only(left: (width / 36), right: (width / 36)),
                    child: AutoSizeText(
                      'Класация',
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 40,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),        
        ],
      ),
      ),
    );
  }

}
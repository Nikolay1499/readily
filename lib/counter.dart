import 'package:coutner/camera.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'dart:math' as math;
import 'package:vibration/vibration.dart';
import 'start.dart';

AnimationController controller;

class CountDownTimer extends StatefulWidget {
  @override
  _CountDownTimerState createState() => _CountDownTimerState();
}

class _CountDownTimerState extends State<CountDownTimer> 
    with TickerProviderStateMixin {
  bool paused = false;
  String get timerString {
    Duration duration = controller.isAnimating || paused ?
       controller.duration * controller.value : controller.duration;
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }


  @override
  void initState() {
    super.initState();
    print(selectedType);
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 60),
    );
    controller.addStatusListener((status) 
    {
      if(status == AnimationStatus.dismissed)
      {
        if (Vibration.hasVibrator() != null)
          Vibration.vibrate(duration: 1000);
        paused = true;
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(
            builder: (context) => CameraScreen(camera: firstCamera),
          ),
        );
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      drawer: DrawerWidget(activePage: "/CountDownTimer",),
      backgroundColor: Colors.cyan,
      body: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.bottomCenter,
                  child:
                  Container(
                    decoration: BoxDecoration(
                      gradient: new LinearGradient(
                        begin: FractionalOffset.topCenter,
                        end: FractionalOffset.bottomCenter,
                        colors: [Colors.cyan, Colors.white,],
                        stops: [0.0, 1.0],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Align(
                          alignment: FractionalOffset.center,
                          child: AspectRatio(
                            aspectRatio: 1.0,
                            child: Stack(
                              children: <Widget>[
                                Positioned.fill(
                                  left: 15,
                                  right: 15,
                                  top: 15,
                                  bottom: 15,
                                  child: CustomPaint(
                                      painter: CustomTimerPainter(
                                        animation: controller,
                                        backgroundColor: Colors.white,
                                        color: controller.isAnimating || paused 
                                        ? Colors.cyan : Colors.white,
                                      )),
                                ),
                                Align(
                                  alignment: FractionalOffset.center,
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Transform.translate(
                                        offset: Offset(0, 15),
                                        child: Text(
                                          "Оставащо време",
                                          style: TextStyle(
                                            fontSize: 50,
                                            color: Colors.white),
                                        ),
                                      ),
                                      
                                      Transform.translate(
                                        offset: Offset(0, -10),
                                        child: Text(
                                          timerString,
                                          style: TextStyle(
                                            //fontFamily: 'LcDova',
                                            fontFamily: 'Readily',
                                            fontSize: 80.0,
                                            color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      AnimatedBuilder(
                          animation: controller,
                          builder: (context, child) {
                            return FloatingActionButton.extended(
                              backgroundColor: Colors.cyan,
                              onPressed: () {
                                if (controller.isAnimating)
                                {
                                  controller.stop();
                                  setState((){paused = true;});
                                }
                                else 
                                {
                                  controller.reverse(
                                      from: controller.value == 0.0
                                          ? 1.0
                                          : controller.value);
                                  setState((){paused = false;});
                                }
                              },
                              icon: 
                                Icon(controller.isAnimating ? 
                                  (!paused ? Icons.pause
                                  : Icons.play_arrow) : Icons.play_arrow),
                              label: Text(controller.isAnimating ? 
                                (!paused ? "Пауза" : "Старт") : "Старт", 
                                  style: TextStyle(fontSize: 30),));
                          }),
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }
}

class CustomTimerPainter extends CustomPainter {
  CustomTimerPainter({
    this.animation,
    this.backgroundColor,
    this.color,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Color backgroundColor, color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
    paint.color = color;
    double progress = (1.0 - animation.value) * 2 * math.pi;
    canvas.drawArc(Offset.zero & size, math.pi * 1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(CustomTimerPainter old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}
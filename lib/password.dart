import 'package:auto_size_text/auto_size_text.dart';
import 'package:readily/start.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class PasswordScreen extends StatefulWidget {
  @override
  _PasswordScreenState createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen>
{
  final myController = TextEditingController();
  bool wrongPass = false;

  Future confirmPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('seen', true);
    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(
        builder: (context) => 
          StartScreen(),
      ),
    );
}

  void checkPassword()
  {
    if(myController.text == "1234")
      confirmPassword();
    else
      setState(() {
        wrongPass = true;
      });
      
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: height,
        decoration: BoxDecoration(
          gradient: new LinearGradient(
            begin: FractionalOffset.topCenter,
            end: FractionalOffset.bottomCenter,
            colors: [Colors.cyan, Colors.white,],
            stops: [0.0, 1.0],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AutoSizeText("Моля въведете идентификационния код",
              maxLines: 2,
              style: TextStyle(
                fontSize: 60,
                height: 0.80,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: height / 23,),
            Container(
              color: Colors.cyan[100],
              width: width * 0.92,
              height: height / 11.5,
              child: TextField(
                style: TextStyle(
                  fontSize: 52,
                ),
                controller: myController,
                decoration: InputDecoration.collapsed(
                  hintText: "",
                ),
                
              ),
            ),
            AutoSizeText(wrongPass ? "Невалиден код": "",
              maxLines: 1,
              style: TextStyle(
                color: Colors.red,
                fontSize: 40,
              ),
            ),
            SizedBox(height: height / 27.68,),
            RaisedButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
              color: Colors.cyan[500],
              onPressed: checkPassword,
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, (width / 69.2), 0, (width / 72)),
                child: Container(
                  child: Padding(
                    padding: EdgeInsets.only(left: (width / 36), right: (width / 36)),
                      child: Transform.translate(
                        offset: Offset(0, height / 180),
                        child: AutoSizeText(
                          'Изпрати',
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 40,
                            color: Colors.white,
                          ),
                        ),
                        ),
                    )
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

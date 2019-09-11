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
  return new Scaffold(
    resizeToAvoidBottomInset: false,
    body: Container(
      height: MediaQuery.of(context).size.height,
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
          Text("Моля въведете идентификационния код",
            style: TextStyle(
              fontSize: 60,
              height: 0.80,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30,),
          Container(
            color: Colors.cyan[100],
            width: 330,
            height: 60,
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
          Text(wrongPass ? "Невалиден код": "",
            style: TextStyle(
              color: Colors.red,
              fontSize: 40,
            ),
          ),
          SizedBox(height: 25,),
          RaisedButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            color: Colors.cyan[500],
            onPressed: checkPassword,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
              child: Container(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Text(
                      'Изпрати',
                      style: TextStyle(
                        fontSize: 40,
                        color: Colors.white,
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

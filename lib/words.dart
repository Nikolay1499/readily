import 'package:readily/score.dart';
import 'package:flutter/material.dart';
import 'package:readily/camera.dart';
import 'package:readily/firestore.dart';
import 'package:readily/main.dart';

class WordsScreen extends StatefulWidget {

  final String readText;
  final List<String> existingList;
  WordsScreen({Key key, @required this.readText, 
                      @required this.existingList}) : super(key: key);

  @override
  _WordsScreenState createState() => _WordsScreenState();
}

class _WordsScreenState extends State<WordsScreen>
{ 
  List<String> list = List<String>();
  String text = "Резултат";
  int first, second;
  @override
  void initState()
  {
    super.initState();
    first = -1;
    second = -1;
    list = widget.existingList;
    if(widget.readText != null)
    {
      final newRows = widget.readText.split("\n");
      for(var row in newRows)
      {
        final newWords = row.split(" ");
        for(var word in newWords)
          if(word != null && word != "")
          {
            list.add(word);
          }
      }
    }
  }

  Widget wordList(int i)
  {
    return GestureDetector(
      child: Container(
        height: 45,
        color: (i == first || i == second) 
          ? Colors.yellow[700] : Colors.cyan[200],
        child: Text(
          list[i] + " ",
          textDirection: TextDirection.ltr,
          style: TextStyle(
            fontSize: 30.0,
            fontFamily: 'Comfortaa',
          ),
        ),
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
    );          
  }

  Future<void> setCurrentScore() async {
    var value = await getCurrentScore();
    if(value < wordCount())
      setText();
    else
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(
          builder: (context) => 
            ScoreScreen(score: wordCount(), text: text,),
        ),
      );
  }

  void setText()
  {
    setState(() {
     text = "Нов рекорд:";
    });
    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(
        builder: (context) => 
          ScoreScreen(score: wordCount(), text: text,),
      ),
    );
  }


  int wordCount()
  {
    int count = 0;
    if(first <= second)
      for(int i = first; i <= second; i++)
      {
        //print(list[i]);
        if(list[i].substring(list[i].length - 1) != "–" 
                && list[i].substring(list[i].length - 1) != "-")
          count++;
      }
    else
      for(int i = second; i <= first; i++)
        if(list[i].substring(list[i].length - 1) != "–" 
                && list[i].substring(list[i].length - 1) != "-")
          count++;
    return count;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Navigator.pushReplacement(
          context, 
          MaterialPageRoute(
            builder: (context) => 
              CameraScreen(camera: firstCamera, existingList: widget.existingList),
          ),
        );
      },
      child: Scaffold(
        drawer: DrawerWidget(activePage: "/WordsScreen",),
        backgroundColor: Colors.cyan,
        body: Transform.translate(
          offset: Offset(0, 0),
          child: new Container(
            color: Colors.cyan[200],
            margin: const EdgeInsets.only(top: 50.0, bottom : 80, left: 10, right: 10),
            child: new SingleChildScrollView(
              child: new ConstrainedBox(
                constraints: BoxConstraints(),
                  child: Wrap(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 0.0, bottom : 15),
                        alignment: Alignment.center,
                        color: Colors.cyan,
                        child: Text(
                          "Изберете  първата" + "\n" + "и последната" 
                                    + "\n" + "прочетена дума",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            height: 0.90,
                            fontSize: 65,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      for(int i = 0; i < list.length; i++)
                        wordList(i),
                    ],
                  ),
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton:
          (second != -1 && first != -1)?
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton(
                heroTag: "addPhoto",
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
              SizedBox(width: 100,),
              FloatingActionButton(
                heroTag: "getResult",
                child: Icon(Icons.public, size: 20,),
                onPressed: () {
                  setCurrentScore();
                  
                },
              ),
            ],
          )
          :
          FloatingActionButton(
            heroTag: "addPhoto",
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
      ),
    );
  }

  @override
    void dispose() {
      super.dispose();
    }


  
}
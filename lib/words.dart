import 'package:flutter/material.dart';
import 'camera.dart';
import 'main.dart';
import 'firestore.dart';

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
          if(word != null || word != "")
          {
            list.add(word);
          }
      }
    }
  }

  Widget wordList(int i)
  { 
    print(list[i] == "");
    return GestureDetector(
      child: Container(
        height: 40,
        color: (i == first || i == second) 
          ? Colors.red : Colors.grey,
        alignment: Alignment.center,
        child: Text(list[i], 
          style: TextStyle(
            fontSize: 18,
            fontFamily: "Roboro"
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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidget(activePage: "/WordsScreen",),
      backgroundColor: Colors.cyan,
      body:
        Transform.translate(
          offset: Offset(0, 25),
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(left: 120.0, right: 120),
            child: (Wrap(
              children: [
                for(int i = 0; i < list.length; i++)
                  wordList(i),
                Text((second != -1 && first != -1) 
                  ? ((second - first).abs() + 1).toString() : "", 
                  style: TextStyle(fontSize: 30,)),
              ],
            ))
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
                addToArrayRecord((second - first).abs() + 1);
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
    );
  }

  @override
    void dispose() {
      super.dispose();
    }


  
}
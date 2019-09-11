import 'package:flutter/material.dart';
import 'package:coutner/record.dart';
import 'package:coutner/leaderboard.dart';

class PersonalScreen extends StatefulWidget {
  final int place;
  final int grade;
  final Record record;
  const PersonalScreen({
    Key key,
    @required this.place,
    @required this.grade,
    @required this.record,
  }) : super(key: key);

  @override
  _PersonalScreenState createState() => _PersonalScreenState();
}

class _PersonalScreenState extends State<PersonalScreen> {
  String student = "1 клас";
  
  DateTime date;
  Record record;

  @override
  void initState()
  {
    super.initState();
    record = widget.record;
  }

  



  Widget buildList(BuildContext context) {
    List<int> scores = record.score;
    scores.sort();
    Iterable inReverse = scores.reversed;
    scores = inReverse.toList();

    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.only(top: 20.0),
      children: [
        for(int i = 0; i < scores.length; i++)
          Padding(
            key: ValueKey(record.name),
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              child: ListTile(
                leading: Transform.translate(
                  offset: Offset(-3, 5),
                  child: Text((i + 1).toString(),
                    style: TextStyle(
                      fontSize: 23,
                      color: Colors.black,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
                title: Transform.translate(
                  offset: Offset(-15, 0),
                  child: Text(record.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,     
                    ),
                  ),
                ),
                subtitle: Transform.translate(
                  offset: Offset(-15, -5),
                  child: Text(record.email,
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: "Gayathri",  
                    ),
                  ),
                ),
                trailing: Text(scores[i].toString(),
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }


  Widget returnIcon(String path, int index)
  {
    return Stack(
          children: [
            Transform.translate(
              offset: Offset(-14, -7),
              child: Image(
                image: AssetImage(path),
              ),
            ),
            Text((index + 1).toString(),
              style: TextStyle(
                fontSize: 23,
                color: Colors.black,
                fontFamily: 'Roboto',
              ),
            ),
          ],
        );
  }
  Widget getIndex(int index)
  {
    switch (index)
    {
      case 0:
      {
        return returnIcon("assets/gold.png", 0);
      }
      break;
      case 1:
      {
        return returnIcon("assets/silver.png", 1);
      } 
      break;
      case 2:
      {
        return returnIcon("assets/bronze.png", 2);
      } 
      break;
      default:
      {
        return Text((index + 1).toString(),
          style: TextStyle(
            fontSize: 23,
            color: Colors.black,
            fontFamily: 'Roboto',
          ),
        );
      }
      break;
        
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan,
      body: 
      NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 280.0,
              floating: true,
              backgroundColor: Colors.cyan,
              pinned: false,
              flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  background: Container(
                    alignment: Alignment(0.0, 0),
                    decoration: BoxDecoration(
                      gradient: new LinearGradient(
                        begin: FractionalOffset.topCenter,
                        end: FractionalOffset.bottomCenter,
                        colors: [Colors.white, Colors.cyan,],
                        stops: [0.0, 1.0],
                      ),
                    ),
                    child: GestureDetector(
                      child: Stack(
                          children: [
                            Positioned(
                              child: Transform.scale(
                                child:Image(
                                  image: AssetImage("assets/star.png"),
                                  alignment: Alignment.center,
                                ),
                              scale: 0.75,
                              ),
                            ),
                            Positioned(
                              top: 115,
                              bottom: 0,
                              right: 0,
                              left: 0,
                              child: Text(record.bestScore.toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 120, 
                                  color:Colors.white,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 250,
                              bottom: 0,
                              right: 0,
                              left: 0,
                              child: Text("ДУМИ",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 50, 
                                  color:Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      onTap: () {
                        Navigator.pushReplacement(
                          context, 
                          MaterialPageRoute(
                            builder: (context) => 
                              LeaderboardScreen(),
                          ),
                        );
                      }, 
                    ),
                  ),
              ),
            ),
          ];
        },
        body:
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            
            Expanded(child: buildList(context)),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
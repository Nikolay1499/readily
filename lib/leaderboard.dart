import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coutner/main.dart';
import 'package:flutter/material.dart';
import 'record.dart';
import 'login.dart';
import 'start.dart';

class LeaderboardScreen extends StatefulWidget {
  @override
  _LeaderboardScreenState createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  int grade;
  int place;
  ValueNotifier<int> counter;
  Record personalRecord;
  Stream<QuerySnapshot> documents;

  @override
  void initState()
  {
    super.initState();
    grade = int.parse(selectedType.substring(0, 1));
    documents = Firestore.instance.collection('leaderboard')
              .where("grade", isEqualTo: grade)
              .orderBy("bestScore", descending: true)
              .orderBy("date", descending: false).snapshots();
    counter = ValueNotifier(0);
    counter.addListener(setData);
  }

  void setData()
  {
    Future.delayed(Duration(milliseconds: 500), (){
      setState(() {
        place = counter.value;
      });
    });
    
  }

  Widget buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: documents,
      builder: (context, snapshot) {
        if (!snapshot.hasData) 
          return LinearProgressIndicator();
        if(snapshot.hasError)
          print(snapshot.error);
        return buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) 
              => buildListItem(context, data, snapshot.indexOf(data))).toList(),
    );
  }

  Widget buildListItem(BuildContext context, DocumentSnapshot data, int index) {
    final record = Record.fromSnapshot(data);
    if(record.email == email)
    {
      personalRecord = record;
      counter.value = index + 1;
    }
    return Padding(
      key: ValueKey(index),
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        child: ListTile(
          key: ValueKey(index),
          leading: Transform.translate(
            offset: Offset(-3, 5),
            child: getIndex(index),
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
          trailing: Text(record.bestScore.toString(),
            style: TextStyle(
              fontSize: 30,
              color: Colors.white,
            ),
          ),
        ),
      ),
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
      drawer: DrawerWidget(activePage: "/LeaderboardScreen"),
      backgroundColor: Colors.cyan,
      body: 
      NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              automaticallyImplyLeading: false,
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
                              child: 
                              Text(place != null ? place.toString()
                                : "0",
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
                              child: Text("МЯСТО",
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
                        personalPanel(context);
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
            
            Expanded(child: buildBody(context),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> personalPanel(BuildContext context) {
    List<int> scores = personalRecord.score;
    scores.sort();
    Iterable inReverse = scores.reversed;
    scores = inReverse.toList();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Вашите постижения',
            textAlign: TextAlign.center,
            style: TextStyle(
              height: 0.75,
              fontSize: 60,
            ),
          ),
          content: Column(
            children: [
            for(int i = 0; i < scores.length; i++)
              Row(
                children: [
                  Text((i + 1).toString(),
                    style: TextStyle(
                      fontSize: 50,
                      color: Colors.black,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  SizedBox(width: 160,),
                  Transform.translate(
                    offset: Offset(0, 8),
                    child: Text(scores[i].toString(),
                      style: TextStyle(
                        fontSize: 60,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ), 
                 
            ],
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


}
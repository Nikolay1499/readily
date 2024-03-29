import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:readily/counter.dart';
import 'package:readily/main.dart';
import 'package:flutter/material.dart';
import 'package:readily/record.dart';
import 'package:readily/login.dart';
import 'package:readily/size.dart';
import 'package:readily/start.dart';

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
            child: AutoSizeText(record.name,
              maxLines: 1,
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,     
              ),
            ),
          ),
          subtitle: Transform.translate(
            offset: Offset(-15, -5),
            child: AutoSizeText(record.email,
              maxLines: 1,
              style: TextStyle(
                fontSize: 15,
                fontFamily: "Gayathri",  
              ),
            ),
          ),
          trailing: AutoSizeText(record.bestScore.toString(),
            maxLines: 1,
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
            AutoSizeText((index + 1).toString(),
              maxLines: 1,
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
        return AutoSizeText((index + 1).toString(),
          maxLines: 1,
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
                                scale: 0.85,
                                ),
                              ),
                              Positioned(
                                top: 95,
                                bottom: 0,
                                right: 8,
                                left: 0,
                                child: 
                                AutoSizeText(place != null ? place.toString()
                                  : "0",
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 120, 
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
    print(SizeConfig.screenHeight);
    int substract;
    if(SizeConfig.screenHeight > 600)
      substract = ((SizeConfig.screenHeight + 50) / 100).round() + 3;
    else
      substract = ((SizeConfig.screenHeight + 50) / 100).round() - 1;
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Вашите постижения',
            textAlign: TextAlign.center,
            style: TextStyle(
              height: 0.75,
              fontSize: SizeConfig.blockSizeHorizontal * SizeConfig.screenHeight / 39 - substract,
            ),
          ),
          content: Column(
            children: [
            for(int i = 0; i < scores.length; i++)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text((i + 1).toString(),
                    style: TextStyle(
                      fontSize: SizeConfig.blockSizeHorizontal 
                                  * SizeConfig.screenHeight / 39 - substract - 1,
                      color: Colors.black,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(0, 12),
                    child: Text(scores[i].toString(),
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: SizeConfig.blockSizeHorizontal 
                                  * SizeConfig.screenHeight / 39 - substract,
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
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coutner/record.dart';
import 'package:coutner/login.dart';

void createRecord(String grade) async {
  List<int> newList = new List<int>();
  newList.add(0);
  await Firestore.instance.collection("leaderboard")
    .document(email)
    .setData({
      'bestScore': 0,
      'name': name,
      'email': email,
      'date': Timestamp.now(),
      'grade': int.parse(grade.substring(0, 1)),
      'score': newList, 
    });
}

void updateRecord(int grade) {
    try {
      Firestore.instance
          .collection('leaderboard')
          .document(email)
          .updateData({'class': grade});
    } catch (e) {
      print(e.toString());
    }
}

void deleteData() {
  try {
    Firestore.instance
        .collection('leaderboard')
        .document(email)
        .delete();
  } catch (e) {
    print(e.toString());
  }
}

Future<int> getCurrentScore() async 
{
  final document = await Firestore.instance
      .collection('leaderboard')
      .document(email)
      .get();
  final record = Record.fromSnapshot(document);
  return record.bestScore;
}

void addToArrayRecord(int score)
{
  bool notFound = false;
  try {
    Firestore.instance
        .collection('leaderboard')
        .document(email)
        .get()
        .then((DocumentSnapshot ds) {
          final record = Record.fromSnapshot(ds);
          List<int> scores = record.score;
          scores.sort();
          Iterable inReverse = scores.reversed;
          scores = inReverse.toList();

          record.score.sort();
          for(int i = 0 ; i < scores.length; i++)
            if(scores[i] < score)
            {
              notFound = true; 
              if(scores.length < 5)
                  scores.add(scores[scores.length - 1]);
              for(int j = scores.length - 2; j >= i; j--)
                scores[j + 1] = scores[j];
              scores[i] = score;
              break;
            }
          if(scores.length < 5 && !notFound)
            scores.add(score);


          if(scores.indexOf(score) == 0)
            Firestore.instance
              .collection('leaderboard')
              .document(email)
              .updateData({'score': scores, 'bestScore' : score, 
                          'date' : Timestamp.now()});
          else
            Firestore.instance
              .collection('leaderboard')
              .document(email)
              .updateData({'score': scores});
        });
  } catch (e) {
    print(e.toString());
  }
}

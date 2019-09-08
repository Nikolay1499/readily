import 'package:cloud_firestore/cloud_firestore.dart';

class Record 
{
  String name;
  List<int> score;
  int bestScore;
  int grade;
  String email;
  final Timestamp date;
  final DocumentReference reference;

  Record.fromMap(Map<dynamic, dynamic> map, {this.reference})
      :
        assert(map['name'] != null),
        assert(map['score'] != null),
        assert(map['grade'] != null),
        assert(map['email'] != null),
        assert(map['date'] != null),
        assert(map['bestScore'] != null),
        name = map['name'],
        grade = map['grade'],
        score = new List<int>.from(map['score']),
        date = map['date'],
        bestScore = map['bestScore'],
        email = map['email'];


  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$name:$grade:$email:$bestScore:$date;>";
}
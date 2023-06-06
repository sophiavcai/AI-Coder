import 'package:cloud_firestore/cloud_firestore.dart';

class NewGameDTO {
  late DateTime date;
  late int score;
  late String name;

  void uploadToFirestore() {
    FirebaseFirestore.instance.collection('games').add({
      'date': date,
      'score': score,
      'name': name
    });
  }
}
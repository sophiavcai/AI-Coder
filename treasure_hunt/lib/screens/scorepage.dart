import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'mapscreen.dart';
import 'package:intl/intl.dart';
import '../models/game.dart';

class ScorePage extends StatefulWidget {
  final NewGame game;

  ScorePage({Key? key, required this.game}) : super(key: key);

  @override
  State<ScorePage> createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        // Background Image
        Image.asset('images/scoreboard_screen.png',
            fit: BoxFit.cover, width: double.infinity, height: double.infinity),
        scoreBoard(widget.game),
      ]),
    );
  }

  Widget scoreBoard(game) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    return Container(
      padding: EdgeInsets.all(20),
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        Text(
          "Scoreboard",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: 'Papyrus',
              fontSize: 50,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(205, 127, 50, 1.0),
              shadows: [
                Shadow(color: Colors.black, offset: Offset(5, 5), blurRadius: 3)
              ]),
        ),
        Container(
          color: Color.fromRGBO(255, 255, 255, 0.5),
          child: SizedBox(
            height: 400,
            width: 400,
            child: StreamBuilder(
                stream: firestore
                    .collection('games')
                    .orderBy('score', descending: true)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var game = snapshot.data!.docs[index];

                          DateTime date = game['date'].toDate();
                          String dateFormatted =
                              DateFormat('dd MMM, yyyy').format(date);
                          NewGame gameObject = NewGame(
                            date: date,
                            score: game['score'],
                            name: game['name'],
                            treasureCoordinates: {},
                            //myIcon: game['score']
                          );
                          return ListTile(
                            title: Text(
                              '${game['name'].toString()}',
                              style: TextStyle(
                                  fontFamily: 'Papyrus',
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  shadows: [
                                    Shadow(
                                        color: Colors.grey,
                                        offset: Offset(5, 5),
                                        blurRadius: 3)
                                  ]),
                            ),
                            subtitle: Text(
                              '${game['score'].toString()} Points',
                              style: TextStyle(
                                  fontFamily: 'Papyrus',
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  shadows: [
                                    Shadow(
                                        color: Colors.grey,
                                        offset: Offset(5, 5),
                                        blurRadius: 3)
                                  ]),
                            ),
                            trailing: Text(
                              dateFormatted,
                              style: TextStyle(
                                  fontFamily: 'Papyrus',
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  shadows: [
                                    Shadow(
                                        color: Colors.grey,
                                        offset: Offset(5, 5),
                                        blurRadius: 3)
                                  ]),
                            ),
                          );
                        });
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                }),
          ),
        ),
        Container(
            padding: EdgeInsets.all(20),
            color: Color.fromRGBO(21, 22, 103, 0.5),
            width: 400,
            height: 150,
            child: Text(
              "Ahoy Matey! On today's ${game.name}, you swiped ${game.score} points of booty! Shiver Me Timbers!",
              style: TextStyle(
                fontFamily: 'Papyrus',
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            )),
        ElevatedButton(
          style:
              ElevatedButton.styleFrom(primary: Color.fromRGBO(21, 22, 103, 1)),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MapScreen()),
            );
          },
          child: Text('Play Again'),
        )
      ]),
    );
  }
}

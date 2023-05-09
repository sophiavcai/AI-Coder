import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'mapscreen.dart';
import 'package:intl/intl.dart';
import '../models/game.dart';

class ScorePage extends StatefulWidget {
  final int score;

  const ScorePage({Key? key, required this.score}) : super(key: key);

  @override
  State<ScorePage> createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scoreboard'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Congratulations!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'You Scored ${widget.score} points today',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 32),
            Text(
              'Treasure Hunt Scoreboard',
              style: TextStyle(fontSize: 20, fontFamily: 'Arcade Classic'),
            ),
            scoreBoard(),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MapScreen()),
                );
              },
              child: Text('Play Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget scoreBoard() {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    return SizedBox(
      height: 300,
      width: 350,
      child: StreamBuilder(
          stream: firestore
              .collection('games')
              .orderBy('score', descending: true)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var game = snapshot.data!.docs[index];

                    DateTime date = game['date'].toDate();
                    String dateFormatted =
                        DateFormat('dd MMM, yyyy').format(date);
                    Game gameObject = Game(
                        date: dateFormatted,
                        latitude: game['latitude'],
                        longitude: game['longitude'],
                        score: game['score']);
                    return ListTile(
                      title: Text('Score: ${game['score'].toString()}'),
                      trailing: Text(dateFormatted),
                      // onTap: () => {
                      //   Navigator.of(context).push(MaterialPageRoute(
                      //       builder: (context) => DetailScreen(
                      //             game: postObject,
                      //           )))
                      // },
                    );
                  });
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}

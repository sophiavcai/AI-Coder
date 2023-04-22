import 'package:flutter/material.dart';

class ScorePage extends StatelessWidget {
  final int score;

  const ScorePage({Key? key, required this.score}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Treasure Hunter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/treasure-chest.png',
              width: 120,
              height: 120,
            ),
            SizedBox(height: 16),
            Text(
              'Congratulations!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'You found a treasure!',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 16),
            Text(
              'Your Score: $score',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Back to Map'),
            ),
          ],
        ),
      ),
    );
  }
}

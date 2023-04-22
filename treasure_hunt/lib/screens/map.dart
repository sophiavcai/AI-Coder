import 'package:flutter/material.dart';
import 'scorepage.dart';

class Map extends StatelessWidget {
  const Map({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ScorePage(
                        score: 100,
                      )),
            );
          },
          child: Text('Quit Game'),
        ),
      ),
    );
  }
}

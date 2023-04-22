import 'package:flutter/material.dart';
import 'map.dart'; 

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Treasure Trekker'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Map()),
            );
          },
          child: Text('Start Game'),
        ),
      ),
    );
  }
}
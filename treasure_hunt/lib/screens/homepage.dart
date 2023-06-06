import 'package:flutter/material.dart';
import 'package:treasure_hunt/screens/scorepage.dart';
import 'mapscreen.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Image.asset(
            'images/start_screen.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          // Centered text
          Column(
            children: [
              Padding(padding: EdgeInsets.all(220)),
              Center(
                child: Text(
                  'Treasure Trekker',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Papyrus',
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                            color: Colors.blueGrey,
                            offset: Offset(5, 5),
                            blurRadius: 3)
                      ]),
                ),
              ),
            ],
          ),
          // Start Game button at the bottom
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MapScreen()));
              },
              child: Text('Start Game'),
              style: ElevatedButton.styleFrom(
                  primary: Color.fromRGBO(21, 22, 103, 1),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20))),
            ),
          ),
        ],
      ),
    );
  }
}

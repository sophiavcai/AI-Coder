import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/game.dart';
import '../models/game_dto.dart';
import 'scorepage.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Placemark address = Placemark(name: "Redmond");
  bool _paused = false;
  final List<LatLng> randomCoordinates = [];
  LatLng _start = LatLng(47.67, -122.117);
  GoogleMapController? mapController;
  late MapType _currentMapType = MapType.normal;
  final gameInfo = NewGameDTO();
  BitmapDescriptor jewelIcon =
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);

  @override
  void initState() {
    _setIconJewel(3);
    getCurrentCoordinates();
    super.initState();
  }

  Future<Uint8List> getBytesFromAsset(int width) async {
    ByteData data = await rootBundle.load('images/jewel_icon.png');
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  _setIconJewel(int width) async {
    final Uint8List markerIcon = await getBytesFromAsset(width);
    return BitmapDescriptor.fromBytes(markerIcon);
  }

  void getCurrentCoordinates() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    _start = LatLng(position.latitude, position.longitude);

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      address = placemarks[0];
    } catch (err) {}
    print(address);
  }

  void _pauseGame() {
    setState(() {
      _paused = true;
    });
  }

  void _resumeGame() {
    setState(() {
      _paused = false;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  @override
  Widget build(BuildContext context) {
    NewGame game = NewGame(
        date: DateTime.now(),
        score: 0,
        treasureCoordinates:
            NewGame.generateRandomCoordinates(_start, jewelIcon),
        name: NewGame.generateJourneyName()
        //myIcon:
        );
    return StreamBuilder<Position>(
      stream: Geolocator.getPositionStream(),
      builder: (BuildContext context, AsyncSnapshot<Position> snapshot) {
        if (snapshot.hasData) {
          //NewGame.generateRandomCoordinates(_start);
          game.updateScore(snapshot.data, game.treasureCoordinates);
          return mapDisplay(game);
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
            color: Colors.white,
          );
        }
      },
    );
  }

  Widget mapDisplay(NewGame game) {
    LatLng _center = LatLng(_start.latitude, _start.longitude);
    final Set<Marker> _markers = game.treasureCoordinates;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(21, 22, 103, 1),
        automaticallyImplyLeading: false,
        title: Text(
          '${game.name}',
          style: TextStyle(fontFamily: 'Papyrus', fontSize: 25),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.map),
            onPressed: _onMapTypeButtonPressed,
          ),
          IconButton(
            icon: Icon(Icons.pause),
            onPressed: () {
              pauseButton(game);
            },
          )
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 13.0,
            ),
            mapType: _currentMapType,
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),
          Row(
            children: [ScoreTally(game.score), CoordinateDisplay(_center)],
          ),
        ],
      ),
    );
  }

  void pauseButton(game) {
    AlertDialog alert = AlertDialog(
      actionsAlignment: MainAxisAlignment.center,
      title: Text(
        "Paused",
        textAlign: TextAlign.center,
      ),
      actions: [
        TextButton(
          child: Text('Continue'),
          onPressed: () {
            _resumeGame();
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('End Game'),
          onPressed: () async {
            gameInfo.date = DateTime.now();
            gameInfo.score = game.score;
            gameInfo.name = game.name;
            gameInfo.uploadToFirestore();
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ScorePage(
                        game: game,
                      )),
            );
          },
        ),
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget ScoreTally(score) {
    return Container(
      padding: EdgeInsets.all(5),
      child: Container(
        decoration:
            BoxDecoration(color: Color.fromRGBO(21, 22, 103, 1), boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3))
        ]),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 45),
        child: Text(
          'Score\n$score',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: 'Papyrus',
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget CoordinateDisplay(LatLng position) {
    return Container(
      padding: EdgeInsets.all(5),
      child: Container(
        decoration:
            BoxDecoration(color: Color.fromRGBO(21, 22, 103, 1), boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3))
        ]),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
        child: Text(
          'Location: ${address.locality}\n(${position.latitude.toStringAsFixed(2)}, ${position.longitude.toStringAsFixed(2)})',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: 'Papyrus',
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

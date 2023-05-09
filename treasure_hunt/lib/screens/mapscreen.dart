import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'scorepage.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Position? position;
  bool _paused = false;

  @override
  void initState() {
    super.initState();
    getCurrentCoordinates();
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

  void getCurrentCoordinates() async {
    position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {});
  }

  Completer<GoogleMapController> _controller = Completer();
  late MapType _currentMapType = MapType.normal;

  LatLng? _lastMapPosition;

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
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
    return FutureBuilder<Position>(
      future:
          Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high),
      builder: (BuildContext context, AsyncSnapshot<Position> snapshot) {
        if (snapshot.hasData) {
          final Position position = snapshot.data!;
          return mapDisplay(position);
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

  Widget mapDisplay(Position position) {
    final LatLng _center = LatLng(position.latitude, position.longitude);
    final Set<Marker> _markers = {
      Marker(markerId: MarkerId("source"), position: _center)
    };
    // Use the position object to access the location coordinates
    return Scaffold(
      appBar: AppBar(
        title: Text('Treasure Hunt Map'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.map),
            onPressed: _onMapTypeButtonPressed,
          ),
          IconButton(
            icon: Icon(Icons.pause),
            onPressed: pauseButton,
          )
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 15.0,
            ),
            mapType: _currentMapType,
            markers: _markers,
            onCameraMove: _onCameraMove,
          ),
        ],
      ),
    );
  }

  void pauseButton() {
    AlertDialog alert = AlertDialog(
      title: Text("Paused"),
      actions: [
        TextButton(
          child: Text('Quit Game'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ScorePage(
                        score: 100,
                      )),
            );
          },
        ),
        TextButton(
          child: Text('Continue'),
          onPressed: () {
            _resumeGame();
            Navigator.of(context).pop();
          },
        )
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

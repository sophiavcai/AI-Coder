import 'dart:math';
import 'dart:core';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class NewGame {
  DateTime date;
  int score = 0;
  String name;
  final Set<Marker> treasureCoordinates;
  late Future<LatLng> start;
  //BitmapDescriptor? myIcon;

  NewGame(
      {required this.date,
      required this.score,
      required this.treasureCoordinates,
      required this.name
      //required this.myIcon
      });

  void updatePosition(lat, lng) {
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  void updateScore(start, treasureCoordinates) {
    final double userLat = start.latitude;
    final double userLng = start.longitude;
    double treasureLat;
    double treasureLng;
    double distance;

    for (int i = 0; i < 10; i++) {
      treasureLat = treasureCoordinates.toList()[i].position.latitude;
      treasureLng = treasureCoordinates.toList()[i].position.longitude;

      distance = Geolocator.distanceBetween(
              userLat, userLng, treasureLat, treasureLng) *
          0.00062137;
      if (distance <= 0.1) {
        score += 100;
      }
    }
  }

  static String generateJourneyName() {
    final List<String> pirateAdjectives = [
      'Bold',
      'Fearless',
      'Savage',
      'Brave',
      'Daring',
      'Cunning',
      'Reckless',
      'Fierce',
      'Valiant',
      'Gritty',
    ];

    final List<String> pirateNouns = [
      'Adventure',
      'Quest',
      'Expedition',
      'Voyage',
      'Raid',
      'Ransom',
      'Trove',
      'Booty',
      'Buccaneer',
      'Plunder',
    ];

    final random = Random();
    final adjective = pirateAdjectives[random.nextInt(pirateAdjectives.length)];
    final noun = pirateNouns[random.nextInt(pirateNouns.length)];

    return '$adjective $noun Hunt';
  }

  static Set<Marker> generateRandomCoordinates(currentPosition, icon) {
    final Set<Marker> _markers = {};
    final double lat = currentPosition.latitude;
    final double lng = currentPosition.longitude;
    final double radius = 0.5; // 1 mile radius

    print("$lat, $lng");

    final Random random = Random();
    for (int i = 0; i < 10; i++) {
      // Generate random offsets within 1 mile radius
      final double latOffset = (random.nextDouble() * radius / 69);
      final double lngOffset =
          (random.nextDouble() * radius / (69 * cos(lat * pi / 180)));

      // Calculate random coordinates
      final double randomLat =
          lat + (random.nextBool() ? latOffset : -latOffset);
      final double randomLng =
          lng + (random.nextBool() ? lngOffset : -lngOffset);

      final LatLng randomCoordinate = LatLng(randomLat, randomLng);
      _markers.add(Marker(
          markerId: MarkerId("location ${i + 1}"),
          position: randomCoordinate,
          icon: icon));
         //     BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan)));
    }
    return _markers;
  }
}

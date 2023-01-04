import 'dart:ui';

import 'package:flutter/material.dart';

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

Future<String> postData(Position location) async {
  DateTime dateToday = DateTime.now();
  String date = dateToday.toString().substring(0, 10);
  var res = await http.post(
    Uri.parse('https://api.astronomyapi.com/api/v2/studio/moon-phase'),
    body: jsonEncode({
      "format": "png",
      "style": {
        "moonStyle": "sketch",
        "backgroundStyle": "stars",
        "backgroundColor": "red",
        "headingColor": "white",
        "textColor": "#ffc107"
      },
      "observer": {"latitude": 6.56774, "longitude": 79.88956, "date": date},
      "view": {"type": "portrait-simple", "orientation": "south-up"}
    }),
    headers: {
      HttpHeaders.authorizationHeader:
          'Basic Mzg3ZTgwOTYtZjA0ZC00Zjg1LWE3MzItNDk4MGQ5NGI4MjYwOjg5ODZkMTQ3NmYzMzljZWMzOTUzNzgwOWE2OWViOTk2NGFiMzZiOWIwNTgyNWE4NzdiNDg3N2MwY2I1MDZmZjcwOWRiOWIzYjljNTk3YzQ3NDYyMGZlMGVjMWY4N2QwY2M4MjA1ZDYzOTdkMTMyMzVhMWVhZDY1OGVjODQzNWI0YTJkMjdkMTYyNDIyMmYwZjc3YzBkNzYzMmIwMGM4MzBjYzk5YmM5MjIwZTgyOWQ3NTY0YTkyYzk1N2UxYjUyOGE2OTg2MjcxNzM2MDkxMWExNDRlMTRlNWE5NzVhZTZm', //baisc api token here
    },
  );
  var body = jsonDecode(res.body);
  final String starChartUrl = body['data']['imageUrl'];
  print(starChartUrl);
  return starChartUrl;
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _getCurrentPosition().then((_) async {
      var imageUrl = await postData(_currentPosition!);
      print('success?');
      setState(() {
        this.imageUrl = imageUrl;
      });
    });
  }

  String? _currentAddress;
  Position? _currentPosition;
  String? imageUrl;

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      _getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
            '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null) {
      return Scaffold(
        appBar: AppBar(
            title: const Text("Orbiting...",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontFamily: "MartianMono"))),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    child: Text(
                      "Scanning the skies for your moon phase... 🌖 🌗 🌘 🌑 ",
                      style: TextStyle(fontSize: 25, fontFamily: "MartianMono"),
                    ),
                  ),
                ),
                Text(
                  'LAT: ${_currentPosition?.latitude ?? ""}',
                  style: TextStyle(
                      fontSize: 25,
                      fontFamily: "MartianMono",
                      color: Colors.amber),
                ),
                Text(
                  'LNG: ${_currentPosition?.longitude ?? ""}',
                  style: TextStyle(
                      fontSize: 25,
                      fontFamily: "MartianMono",
                      color: Colors.amber),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'stAR.Lunar',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontFamily: "MartianMono"),
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Image.network(imageUrl!,
                      height: 500, width: 375, fit: BoxFit.cover),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 35, 10, 20),
                  child: RichText(
                    text: TextSpan(
                      children: const [
                        TextSpan(
                          text: 'Click ',
                          style: TextStyle(
                            fontFamily: "MartianMono",
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        WidgetSpan(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 2.0),
                            child: Icon(Icons.view_in_ar_sharp,
                                color: Colors.amber),
                          ),
                        ),
                        TextSpan(
                            text: ' to explore the Moon in Augmented Reality',
                            style: TextStyle(
                              fontFamily: "MartianMono",
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            )),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    _showSimpleModalDialog(context);
                  },
                  icon: Icon(Icons.auto_awesome_outlined),
                  label: Text(
                    "Fun Fact",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }
  }
}

_showSimpleModalDialog(context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
              side: BorderSide(color: Colors.amber)),
          child: Container(
            constraints: BoxConstraints(maxHeight: 350),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: const [
                        TextSpan(
                          text: 'The Moon has quakes too!                  ',
                          style: TextStyle(
                              fontFamily: "MartianMono",
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: Colors.amber),
                        ),
                        TextSpan(
                            text:
                                'They are not called earthquakes but moonquakes. They are caused by the gravitational influence of the Earth. Unlike quakes on Earth that last only a few minutes at most, moonquakes can last up to half an hour. They are much weaker than earthquakes though.',
                            style: TextStyle(
                              fontFamily: "MartianMono",
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            )),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      });
}

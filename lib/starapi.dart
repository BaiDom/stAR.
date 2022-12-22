import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class StarAPI extends StatefulWidget {
  const StarAPI({super.key});

  @override
  State<StarAPI> createState() => _HomeScreenState();
}

var a = 'hello world';

Future<String> postData(Position location) async {
  DateTime dateToday = DateTime.now();
  String date = dateToday.toString().substring(0, 10);
  var res = await http.post(
    Uri.parse('https://api.astronomyapi.com/api/v2/studio/star-chart'),
    body: jsonEncode({
      "style": "navy",
      "observer": {
        "latitude": location.latitude,
        "longitude": location.longitude,
        "date": date
      },
      "view": {
        "type": "constellation",
        "parameters": {"constellation": "ori"}
      },
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

class _HomeScreenState extends State<StarAPI> {
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

  Future _getCurrentPosition() async {
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

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null) {
      return Scaffold(
        appBar: AppBar(
            title: FittedBox(
          fit: BoxFit.cover,
          child: const Text('Location',
              style: TextStyle(
                color: Colors.black,
                fontFamily: "MartianMono",
                fontWeight: FontWeight.bold,
              )),
        )),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    "Scanning the skies for your star map...  🌟 🌟 🌟",
                    style: TextStyle(fontSize: 25, fontFamily: "MartianMono"),
                  ),
                ),

                Row(children: const [Text(""), Spacer(), Text("")]),
                Text('LAT: ${_currentPosition?.latitude ?? ""}',
                    style: TextStyle(fontSize: 25, fontFamily: "MartianMono")),
                Text('LNG: ${_currentPosition?.longitude ?? ""}',
                    style: TextStyle(fontSize: 25, fontFamily: "MartianMono")),
                // Text('ADDRESS: ${_currentAddress ?? ""}'),
                const SizedBox(height: 32),
                // ElevatedButton(
                //   onPressed: () {
                //     _getCurrentPosition().then((_) async {
                //       var imageUrl = await postData(_currentPosition!);
                //       print('success?');
                //       setState(() {
                //         this.imageUrl = imageUrl;
                //       });
                //     });
                //   },
                //   child: const Text("Finding Your Location..."),
                // )
              ],
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
          appBar: AppBar(
            title: FittedBox(
              fit: BoxFit.cover,
              child: const Text('stAR.Map',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: "MartianMono",
                    fontWeight: FontWeight.bold,
                  )),
            ),
          ),
          body: Center(
              child: Column(children: [
            Image.network(imageUrl!),
          ])));
    }
  }
}

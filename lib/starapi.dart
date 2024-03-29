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
        "parameters": {"constellation": "aqr"}
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
  late TransformationController controller;
  TapDownDetails? tapDownDetails;

  bool _isVisible = true;

  @override
  void hideButton() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  @override
  void initState() {
    super.initState();
    controller = TransformationController();
    _getCurrentPosition().then((_) async {
      var imageUrl = await postData(_currentPosition!);
      print('success?');
      setState(() {
        this.imageUrl = imageUrl;
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
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
  Widget build(BuildContext context) {
    if (imageUrl == null) {
      return Scaffold(
        appBar: AppBar(
            title: FittedBox(
          fit: BoxFit.cover,
          child: const Text('Orbiting...',
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
                    "We are scanning the skies to find a star map based on your current location...🌃🌉🌌",
                    style: TextStyle(
                      fontSize: 25,
                      fontFamily: "MartianMono",
                    ),
                  ),
                ),
                Row(children: const [Text(""), Spacer(), Text("")]),
                Text('LAT: ${_currentPosition?.latitude ?? ""}',
                    style: TextStyle(
                        fontSize: 25,
                        fontFamily: "MartianMono",
                        color: Colors.amber)),
                Text('LNG: ${_currentPosition?.longitude ?? ""}',
                    style: TextStyle(
                        fontSize: 25,
                        fontFamily: "MartianMono",
                        color: Colors.amber)),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: SingleChildScrollView(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: const Text(
                'stAR.Map',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: "MartianMono",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        body: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 20, 8, 0),
                child: Visibility(
                  visible: _isVisible,
                  child: Text(
                    "The Constellation of Aquarius",
                    style: TextStyle(
                      fontFamily: "MartianMono",
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
                child: GestureDetector(
                  onDoubleTapDown: (details) => tapDownDetails = details,
                  onDoubleTap: () {
                    final position = tapDownDetails!.localPosition;

                    final double scale = 2.75;
                    final x = -position.dx * (scale - 1);
                    final y = -position.dy * (scale - 1);
                    final zoomed = Matrix4.identity()
                      ..translate(x, y)
                      ..scale(scale);

                    final value = controller.value.isIdentity()
                        ? zoomed
                        : Matrix4.identity();
                    controller.value = value;

                    hideButton();
                  },
                  child: InteractiveViewer(
                    clipBehavior: Clip.none,
                    transformationController: controller,
                    panEnabled: true,
                    scaleEnabled: true,
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Image.network(imageUrl!,
                          height: 600, width: 375, fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
                child: Visibility(
                  visible: _isVisible,
                  child: Text(
                    '(Double tap to zoom)',
                    style: TextStyle(
                      fontFamily: "MartianMono",
                      fontWeight: FontWeight.bold,
                      fontSize: 8,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Visibility(
                  visible: _isVisible,
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
                            text:
                                ' to explore this Star map in Augmented Reality',
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
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 5, 8, 8),
                child: Visibility(
                  visible: _isVisible,
                  child: ElevatedButton.icon(
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
                      )),
                ),
              )
            ],
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
            constraints: BoxConstraints(maxHeight: 170),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: const [
                        TextSpan(
                          text:
                              "On a really exceptional night, with no light pollution, you may be able to see 2000-2500 stars at any one time!",
                          style: TextStyle(
                              fontFamily: "MartianMono",
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: Colors.white),
                        ),
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

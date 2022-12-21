import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class APOD extends StatefulWidget {
  const APOD({super.key});

  @override
  State<APOD> createState() => _APODState();
}

class _APODState extends State<APOD> {
  Map<String, dynamic>? starData;

  @override
  Widget build(BuildContext context) {
    var body;
    if (starData != null) {
      body = Center(
          child: Column(children: [
        Text(starData!['copyright']),
        Image.network(starData!['url']),
        Text(starData!['explanation'])
      ]));
    } else {
      body = Center(
          child: Column(
        children: [
          Text(
              'Hey there Space Cadet, would you like to view an amazing astronomical picture from NASA everyday? You would! Well then click the button!'),
          ElevatedButton(
            onPressed: fetchAPI,
            child: Text("Get Awesome Stuff"),
          )
        ],
      ));
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Astronomy Picture Of The Day'),
      ),
      body: body,
    );
  }

  void fetchAPI() async {
    const url =
        'https://api.nasa.gov/planetary/apod?api_key=iRDlURIVK0SQdDk3D5Wx1Rd1Tr9J4zP5YHSWWP91';
    var uri = Uri.parse(url);
    var res = await http.get(uri);
    var body = res.body;
    var copy = jsonDecode(body);
    setState(() {
      starData = Map.from(copy);
    });
    print('SUCCESSSSSS!!!!');
  }
}

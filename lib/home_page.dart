import 'package:flutter/material.dart';
import 'package:test_project/location_page.dart';
import 'package:test_project/star_map.dart';
import 'package:test_project/starapi.dart';
import 'apireq.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
          // Alice - added random code to center the buttons for no real reason lol:
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return const StarAPI();
                    },
                  ),
                );
              },
              child: Text('View Star Map',
                  style: TextStyle(fontFamily: "MartianMono")),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return const LocationPage();
                    },
                  ),
                );
              },
              child:
                  Text('Location', style: TextStyle(fontFamily: "MartianMono")),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return const APOD();
                    },
                  ),
                );
              },
              child: Text('Astronomy Picture Of The Day',
                  style: TextStyle(fontFamily: "MartianMono")),
            ),
          ]),
    );
  }
}

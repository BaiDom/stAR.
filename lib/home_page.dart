import 'package:flutter/material.dart';
import 'package:test_project/location_page.dart';
import 'package:test_project/star_map.dart';
import 'package:test_project/starapi.dart';
import 'apod.dart';
import 'starapi.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: FittedBox(
            fit: BoxFit.cover,
            child: const Text('stAR.',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: "MartianMono",
                  fontWeight: FontWeight.bold,
                )),
          )),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Explore the Universe in AR with stAR.",
                  style: TextStyle(
                    fontFamily: "MartianMono",
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset("assets/images/galaxy.png"),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Click the button below to see a cool new astronomy picture every day!",
                  style: TextStyle(
                      fontFamily: "MartianMono",
                      fontWeight: FontWeight.bold,
                      color: Colors.amber),
                  textAlign: TextAlign.center,
                ),
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
                child: Text('Picture Of The Day',
                    style: TextStyle(fontFamily: "MartianMono")),
              ),
              // Row(children: const [Text(""), Spacer(), Text("")]),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                child: Text("-NAVIGATION-",
                    style: TextStyle(
                        fontFamily: "MartianMono",
                        fontWeight: FontWeight.bold,
                        color: Colors.amber)),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 7.0, 4, 0),
                child: RichText(
                  text: TextSpan(
                    children: const [
                      TextSpan(
                          text: 'Click the ',
                          style: TextStyle(
                            fontFamily: "MartianMono",
                            fontWeight: FontWeight.bold,
                          )),
                      WidgetSpan(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2.0),
                          child: Icon(Icons.star, color: Colors.amber),
                        ),
                      ),
                      TextSpan(
                          text:
                              ' on the navigation bar to see the star map from your location',
                          style: TextStyle(
                            fontFamily: "MartianMono",
                            fontWeight: FontWeight.bold,
                          )),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 7.0, 4, 0),
                child: RichText(
                  text: TextSpan(
                    children: const [
                      TextSpan(
                          text: 'Click the ',
                          style: TextStyle(
                            fontFamily: "MartianMono",
                            fontWeight: FontWeight.bold,
                          )),
                      WidgetSpan(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2.0),
                          child: Icon(Icons.bedtime, color: Colors.amber),
                        ),
                      ),
                      TextSpan(
                          text:
                              ' on the navigation bar to see the current Lunar phase',
                          style: TextStyle(
                            fontFamily: "MartianMono",
                            fontWeight: FontWeight.bold,
                          )),
                    ],
                  ),
                ),
              ),
              Row(children: const [Text(""), Spacer(), Text("")]),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                child: Text("-FUN FACT-",
                    style: TextStyle(
                        fontFamily: "MartianMono",
                        fontWeight: FontWeight.bold,
                        color: Colors.amber)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "On a really exceptional night, with no light pollution, you may be able to see 2000-2500 stars at any one time!",
                  style: TextStyle(
                    fontFamily: "MartianMono",
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

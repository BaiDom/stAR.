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
                padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
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
                  "Click the button below to see an awesome new astronomy picture every day!",
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
                    style: TextStyle(
                      fontFamily: "MartianMono",
                      fontWeight: FontWeight.bold,
                    )),
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
                          text: '- Click ',
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
                          text: ' to see the current Lunar phase',
                          style: TextStyle(
                            fontFamily: "MartianMono",
                            fontWeight: FontWeight.bold,
                          )),
                    ],
                  ),
                  // textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 7.0, 4, 0),
                child: RichText(
                  text: TextSpan(
                    children: const [
                      TextSpan(
                          text: '- Click ',
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
                          text: ' to see the star map from your location',
                          style: TextStyle(
                            fontFamily: "MartianMono",
                            fontWeight: FontWeight.bold,
                          )),
                    ],
                  ),
                  // textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 7.0, 4, 0),
                child: RichText(
                  text: TextSpan(
                    children: const [
                      TextSpan(
                          text: '- Click ',
                          style: TextStyle(
                            fontFamily: "MartianMono",
                            fontWeight: FontWeight.bold,
                          )),
                      WidgetSpan(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2.0),
                          child:
                              Icon(Icons.view_in_ar_sharp, color: Colors.amber),
                        ),
                      ),
                      TextSpan(
                        text: ' to start exploring in Augmented Reality',
                        style: TextStyle(
                          fontFamily: "MartianMono",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  // textAlign: TextAlign.center,
                ),
              ),
              Row(children: const [Text(""), Spacer(), Text("")]),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 20, 8, 8),
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
              )
            ],
          ),
        ),
      ),
    );
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
            constraints: BoxConstraints(maxHeight: 130),
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

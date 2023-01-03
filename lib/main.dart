import 'package:flutter/material.dart';
import 'package:test_project/apod.dart';
import 'package:test_project/home_page.dart';
import 'package:test_project/moon_page.dart';

import 'splash_page.dart';

import 'package:test_project/starapi.dart';
import 'package:test_project/aug_reality.dart';

import 'intro-slideScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.amber,
          scaffoldBackgroundColor: Colors.black,
          textTheme: (TextTheme(bodyText2: TextStyle(color: Colors.white)))),
      home: const SplashPage(),
    );
  }
}

//below is a stateful widget

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int currentPage = 0;
  List<Widget> pages = const [
    HomePage(),
    HomeScreen(),
    StarAPI(),
    APOD(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Center(
      //     child: FittedBox(
      //       fit: BoxFit.cover,
      //       child: Text('stAR.',
      //           style: TextStyle(
      //               color: Colors.black,
      //               fontFamily: "MartianMono",
      //               fontWeight: FontWeight.bold)),
      //     ),
      //   ),
      // ),
      body: pages[currentPage],
      // Augmented Reality button here: -----------------------------
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) {
                return const AugReality();
              },
            ),
          );
        },
        child: Icon(Icons.view_in_ar),
      ),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'home',
          ),
          NavigationDestination(
            icon: Icon(Icons.bedtime),
            label: 'moon',
          ),
          NavigationDestination(
            icon: Icon(Icons.star),
            label: 'star',
          ),
        ],
        onDestinationSelected: (int index) {
          setState(() {
            currentPage = index;
          });
        },
        selectedIndex: currentPage,
      ),
    );
  }
}

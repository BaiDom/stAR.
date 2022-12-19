import 'package:flutter/material.dart';
import 'package:test_project/star_map.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) {
                return const StarPage();
              },
            ),
          );
        },
        child: Text('View Star Map'),
      ),
    );
  }
}

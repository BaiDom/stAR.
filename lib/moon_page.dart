import 'package:flutter/material.dart';

const int itemCount = 20;

class MoonPage extends StatelessWidget {
  const MoonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: itemCount,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
            title: Text('moons ${(index + 1)}'),
            leading: const Icon(Icons.bedtime),
            trailing: const Icon(Icons.bedtime_off_outlined),
            onTap: () {
              debugPrint('moons ${(index + 1)} selected');
            });
      },
    );
  }
}

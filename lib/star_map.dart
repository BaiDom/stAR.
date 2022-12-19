import 'package:flutter/material.dart';

class StarPage extends StatefulWidget {
  const StarPage({super.key});

  @override
  State<StarPage> createState() => _StarPageState();
}

class _StarPageState extends State<StarPage> {
  bool isSwitch = false;
  bool? isCheckBox = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Star Map'),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_outlined),
        ),
      ),
      body: Column(
        children: [
          Image.asset('images/stars.png'),
          const SizedBox(
            height: 5,
          ),
          const Divider(
            color: Colors.black,
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(100, 10, 100, 10),
            padding: const EdgeInsets.all(10.0),
            color: Colors.amber,
            width: double.infinity,
            child: const Center(
              child: Text(
                'my stars',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              debugPrint('Elevated Button');
            },
            child: Text('Save Stars'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isSwitch ? Colors.amber : Colors.white,
            ),
            onPressed: () {
              debugPrint('Elevated Button');
            },
            child: Text('Inverted Stars'),
          ),
          OutlinedButton(
            onPressed: () {
              debugPrint('Outlined Button');
            },
            child: Text('Share Stars'),
          ),
          GestureDetector(
            onTap: () {
              debugPrint('gesture detector = row');
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Icon(Icons.star, color: Colors.amber),
                Text('see the moon'),
                Icon(Icons.bedtime, color: Colors.amber),
              ],
            ),
          ),
          Switch(
              value: isSwitch,
              onChanged: (bool newBool) {
                setState(() {
                  isSwitch = newBool;
                });
              }),
          Checkbox(
            value: isCheckBox,
            onChanged: (bool? newBool) {
              setState(() {
                isCheckBox = newBool;
              });
            },
          ),
        ],
      ),
    );
  }
}

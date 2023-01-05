import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin/models/ar_anchor.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:flutter/material.dart';
import 'package:ar_flutter_plugin/datatypes/hittest_result_types.dart';
import 'package:ar_flutter_plugin/models/ar_hittest_result.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

class AugReality extends StatefulWidget {
  const AugReality({Key? key}) : super(key: key);

  @override
  State<AugReality> createState() => _AugRealityState();
}

class _AugRealityState extends State<AugReality> {
  late ARSessionManager arSessionManager;
  late ARObjectManager arObjectManager;
  late ARAnchorManager? arAnchorManager;

  // End drawer
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openEndDrawer() {
    _scaffoldKey.currentState!.openEndDrawer();
  }

  void _closeEndDrawer() {
    Navigator.of(context).pop();
  }

  ARNode? starNode;
  ARNode? earthNode;
  ARNode? moonNode;
  ARNode? hubbleNode;
  ARNode? marsNode;
  ARNode? venusNode;
  ARNode? jupiterNode;

  List<ARAnchor> anchors = [];
  List<ARNode> nodes = [];

  @override
  void dispose() {
    arSessionManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Center(
          child: FittedBox(
            fit: BoxFit.cover,
            child: Text('stAR.',
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: "MartianMono",
                    fontWeight: FontWeight.bold)),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * .7,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: ARView(
                  onARViewCreated: onARViewCreated,
                  planeDetectionConfig:
                      PlaneDetectionConfig.horizontalAndVertical,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: Icon(Icons.help),
                  label: Text(
                    'Instructions',
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: "MartianMono",
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text(
                        'AR Instructions',
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: "MartianMono",
                            fontWeight: FontWeight.bold),
                      ),
                      content: Wrap(children: [
                        Text(
                            'While staying in one place, please slowly pan your camera around you until the pan animation disappears. \n\nUse the right-hand menu to add 3D models to the scene. These models should spawn somewhere in front of you. You can also tap a surface around you to spawn a bonus model. \n\nTo rotate, tap the model - you will see a selection circle. Then press both thumbs (or two fingers) to the screen and swirl them clockwise or anti-clockwise.'),
                        Image.asset('assets/images/rotate.png'),
                      ]),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'OK'),
                          child: const Text(
                            'OK',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  icon: Icon(Icons.menu),
                  label: Text(
                    'AR menu',
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: "MartianMono",
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: _openEndDrawer,
                ),
              ],
            ),
          ],
        ),
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            SizedBox(
              height: 110,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.amber,
                ),
                child: Text('Add 3D models.',
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: "MartianMono",
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold)),
              ),
            ),
            ListTile(
              title: Text(
                  'Press the + buttons to add models to the scene.\n\nPlease wait a moment for your model to load. This menu will close once it has loaded.'),
            ),
            ListTile(
              leading: IconButton(
                icon: Icon(Icons.add_circle),
                onPressed: () => addStarsChart(),
              ),
              title: Text('Add Star Chart'),
            ),
            ListTile(
              leading: IconButton(
                icon: Icon(Icons.add_circle),
                onPressed: () => addEarth(),
              ),
              title: Text('Add Earth'),
            ),
            ListTile(
              leading: IconButton(
                icon: Icon(Icons.add_circle),
                onPressed: () => addMoon(),
              ),
              title: Text('Add Moon'),
            ),
            ListTile(
              leading: IconButton(
                icon: Icon(Icons.add_circle),
                onPressed: () => addHubble(),
              ),
              title: Text('Add Hubble Telescope'),
            ),
            ListTile(
              leading: IconButton(
                icon: Icon(Icons.add_circle),
                onPressed: () => addMars(),
              ),
              title: Text('Add Mars'),
            ),
            ListTile(
              leading: IconButton(
                icon: Icon(Icons.add_circle),
                onPressed: () => addVenus(),
              ),
              title: Text('Add Venus'),
            ),
            ListTile(
              leading: IconButton(
                icon: Icon(Icons.add_circle),
                onPressed: () => addJupiter(),
              ),
              title: Text('Add Jupiter'),
            ),
            ListTile(
              leading: IconButton(
                icon: Icon(Icons.layers_clear_outlined),
                onPressed: () => onRemoveEverything(),
              ),
              title: Text('Remove model(s)'),
            ),
          ],
        ),
      ),
    );
  }

  void onARViewCreated(
      ARSessionManager arSessionManager,
      ARObjectManager arObjectManager,
      ARAnchorManager arAnchorManager,
      ARLocationManager arLocationManager) {
    this.arSessionManager = arSessionManager;
    this.arObjectManager = arObjectManager;
    this.arAnchorManager = arAnchorManager;

    this.arSessionManager.onInitialize(
          showFeaturePoints: false,
          showPlanes: true,
          customPlaneTexturePath: "Images/triangle.png",
          showWorldOrigin: false,
          handlePans: false,
          handleRotation: true,
        );
    this.arObjectManager.onInitialize();

    this.arSessionManager.onPlaneOrPointTap = onPlaneOrPointTapped;
    this.arObjectManager.onRotationStart = onRotationStarted;
    this.arObjectManager.onRotationChange = onRotationChanged;
    this.arObjectManager.onRotationEnd = onRotationEnded;
  }

  Future<void> addStarsChart() async {
    if (starNode != null) {
      _closeEndDrawer();
    }
    if (earthNode != null) {
      arObjectManager.removeNode(earthNode!);
      earthNode = null;
    }
    if (moonNode != null) {
      arObjectManager.removeNode(moonNode!);
      moonNode = null;
    }
    if (hubbleNode != null) {
      arObjectManager.removeNode(hubbleNode!);
      hubbleNode = null;
    }
    if (marsNode != null) {
      arObjectManager.removeNode(marsNode!);
      marsNode = null;
    }
    if (venusNode != null) {
      arObjectManager.removeNode(venusNode!);
      venusNode = null;
    }
    if (jupiterNode != null) {
      arObjectManager.removeNode(jupiterNode!);
      jupiterNode = null;
    }

    var newNode = ARNode(
        type: NodeType.webGLB,
        uri:
            "https://github.com/sondos-ahmed/glb-assets/blob/main/noDimantionStarChart.glb?raw=true",
        position: Vector3(0.0, 0.0, -0.2),
        scale: Vector3(0.15, 0.15, 0.15));
    bool? didAddWebNode = await arObjectManager.addNode(newNode);
    starNode = (didAddWebNode!) ? newNode : null;
    _closeEndDrawer();
  }

  Future<void> addEarth() async {
    if (earthNode != null) {
      _closeEndDrawer();
    }
    if (starNode != null) {
      arObjectManager.removeNode(starNode!);
      starNode = null;
    }
    if (moonNode != null) {
      arObjectManager.removeNode(moonNode!);
      moonNode = null;
    }
    if (hubbleNode != null) {
      arObjectManager.removeNode(hubbleNode!);
      hubbleNode = null;
    }
    if (marsNode != null) {
      arObjectManager.removeNode(marsNode!);
      marsNode = null;
    }
    if (venusNode != null) {
      arObjectManager.removeNode(venusNode!);
      venusNode = null;
    }
    if (jupiterNode != null) {
      arObjectManager.removeNode(jupiterNode!);
      jupiterNode = null;
    }

    var newNode = ARNode(
        type: NodeType.webGLB,
        uri:
            "https://github.com/captainread/test-assets/blob/main/earth.glb?raw=true",
        position: Vector3(0.0, -0.2, -0.5),
        scale: Vector3(0.3, 0.3, 0.3));
    bool? didAddWebNode = await arObjectManager.addNode(newNode);
    earthNode = (didAddWebNode!) ? newNode : null;
    _closeEndDrawer();
  }

  Future<void> addMoon() async {
    if (moonNode != null) {
      _closeEndDrawer();
    }
    if (starNode != null) {
      arObjectManager.removeNode(starNode!);
      starNode = null;
    }
    if (earthNode != null) {
      arObjectManager.removeNode(earthNode!);
      earthNode = null;
    }
    if (hubbleNode != null) {
      arObjectManager.removeNode(hubbleNode!);
      hubbleNode = null;
    }
    if (marsNode != null) {
      arObjectManager.removeNode(marsNode!);
      marsNode = null;
    }
    if (venusNode != null) {
      arObjectManager.removeNode(venusNode!);
      venusNode = null;
    }
    if (jupiterNode != null) {
      arObjectManager.removeNode(jupiterNode!);
      jupiterNode = null;
    }

    var newNode = ARNode(
        type: NodeType.webGLB,
        uri:
            "https://github.com/captainread/test-assets/blob/main/the_moon_sharp.glb?raw=true",
        position: Vector3(0.0, -0.2, -0.5),
        scale: Vector3(0.3, 0.3, 0.3));
    bool? didAddWebNode = await arObjectManager.addNode(newNode);
    moonNode = (didAddWebNode!) ? newNode : null;
    _closeEndDrawer();
  }

  Future<void> addHubble() async {
    if (hubbleNode != null) {
      _closeEndDrawer();
    }
    if (starNode != null) {
      arObjectManager.removeNode(starNode!);
      starNode = null;
    }
    if (earthNode != null) {
      arObjectManager.removeNode(earthNode!);
      earthNode = null;
    }
    if (moonNode != null) {
      arObjectManager.removeNode(moonNode!);
      moonNode = null;
    }
    if (marsNode != null) {
      arObjectManager.removeNode(marsNode!);
      marsNode = null;
    }
    if (venusNode != null) {
      arObjectManager.removeNode(venusNode!);
      venusNode = null;
    }
    if (jupiterNode != null) {
      arObjectManager.removeNode(jupiterNode!);
      jupiterNode = null;
    }

    var newNode = ARNode(
        type: NodeType.webGLB,
        uri:
            "https://github.com/captainread/test-assets/blob/main/Hubble.glb?raw=true",
        position: Vector3(0.0, -0.2, -0.5),
        scale: Vector3(0.3, 0.3, 0.3));
    bool? didAddWebNode = await arObjectManager.addNode(newNode);
    hubbleNode = (didAddWebNode!) ? newNode : null;
    _closeEndDrawer();
  }

  Future<void> addMars() async {
    if (marsNode != null) {
      _closeEndDrawer();
    }
    if (starNode != null) {
      arObjectManager.removeNode(starNode!);
      starNode = null;
    }
    if (earthNode != null) {
      arObjectManager.removeNode(earthNode!);
      earthNode = null;
    }
    if (moonNode != null) {
      arObjectManager.removeNode(moonNode!);
      moonNode = null;
    }
    if (hubbleNode != null) {
      arObjectManager.removeNode(hubbleNode!);
      hubbleNode = null;
    }
    if (venusNode != null) {
      arObjectManager.removeNode(venusNode!);
      venusNode = null;
    }
    if (jupiterNode != null) {
      arObjectManager.removeNode(jupiterNode!);
      jupiterNode = null;
    }

    var newNode = ARNode(
        type: NodeType.webGLB,
        uri:
            "https://github.com/captainread/test-assets/blob/main/mars.glb?raw=true",
        position: Vector3(0.0, -0.2, -0.5),
        scale: Vector3(0.3, 0.3, 0.3));
    bool? didAddWebNode = await arObjectManager.addNode(newNode);
    marsNode = (didAddWebNode!) ? newNode : null;
    _closeEndDrawer();
  }

  Future<void> addVenus() async {
    if (venusNode != null) {
      _closeEndDrawer();
    }
    if (starNode != null) {
      arObjectManager.removeNode(starNode!);
      starNode = null;
    }
    if (earthNode != null) {
      arObjectManager.removeNode(earthNode!);
      earthNode = null;
    }
    if (moonNode != null) {
      arObjectManager.removeNode(moonNode!);
      moonNode = null;
    }
    if (hubbleNode != null) {
      arObjectManager.removeNode(hubbleNode!);
      hubbleNode = null;
    }
    if (marsNode != null) {
      arObjectManager.removeNode(marsNode!);
      marsNode = null;
    }
    if (jupiterNode != null) {
      arObjectManager.removeNode(jupiterNode!);
      jupiterNode = null;
    }

    var newNode = ARNode(
        type: NodeType.webGLB,
        uri:
            "https://github.com/captainread/test-assets/blob/main/venus.glb?raw=true",
        position: Vector3(0.0, -0.2, -0.5),
        scale: Vector3(0.3, 0.3, 0.3));
    bool? didAddWebNode = await arObjectManager.addNode(newNode);
    venusNode = (didAddWebNode!) ? newNode : null;
    _closeEndDrawer();
  }

  Future<void> addJupiter() async {
    if (jupiterNode != null) {
      _closeEndDrawer();
    }
    if (starNode != null) {
      arObjectManager.removeNode(starNode!);
      starNode = null;
    }
    if (earthNode != null) {
      arObjectManager.removeNode(earthNode!);
      earthNode = null;
    }
    if (moonNode != null) {
      arObjectManager.removeNode(moonNode!);
      moonNode = null;
    }
    if (hubbleNode != null) {
      arObjectManager.removeNode(hubbleNode!);
      hubbleNode = null;
    }
    if (marsNode != null) {
      arObjectManager.removeNode(marsNode!);
      marsNode = null;
    }
    if (venusNode != null) {
      arObjectManager.removeNode(venusNode!);
      venusNode = null;
    }
    var newNode = ARNode(
        type: NodeType.webGLB,
        uri:
            "https://github.com/captainread/test-assets/blob/main/jupiter.glb?raw=true",
        position: Vector3(0.0, -0.2, -0.5),
        scale: Vector3(0.3, 0.3, 0.3));
    bool? didAddWebNode = await arObjectManager.addNode(newNode);
    jupiterNode = (didAddWebNode!) ? newNode : null;
    _closeEndDrawer();
  }

  Future<void> onPlaneOrPointTapped(
      List<ARHitTestResult> hitTestResults) async {
    var singleHitTestResult = hitTestResults.firstWhere(
        (hitTestResult) => hitTestResult.type == ARHitTestResultType.plane);
    if (singleHitTestResult != null) {
      var newAnchor =
          ARPlaneAnchor(transformation: singleHitTestResult.worldTransform);
      bool? didAddAnchor = await this.arAnchorManager!.addAnchor(newAnchor);
      if (didAddAnchor!) {
        this.anchors.add(newAnchor);
        var newNode = ARNode(
            type: NodeType.webGLB,
            uri:
                "https://github.com/captainread/test-assets/blob/main/Curiosity_static.glb?raw=true",
            scale: Vector3(0.3, 0.3, 0.3),
            position: Vector3(0.0, 0.0, 0.0),
            rotation: Vector4(1.0, 0.0, 0.0, 0.0));
        bool? didAddNodeToAnchor =
            await this.arObjectManager.addNode(newNode, planeAnchor: newAnchor);
        if (didAddNodeToAnchor!) {
          this.nodes.add(newNode);
        } else {
          this.arSessionManager.onError("Adding Node to Anchor failed");
        }
      } else {
        this.arSessionManager.onError("Adding Anchor failed");
      }
    }
  }

// removes all models
  Future<void> onRemoveEverything() async {
    if (starNode != null) {
      arObjectManager.removeNode(starNode!);
      starNode = null;
    }
    if (earthNode != null) {
      arObjectManager.removeNode(earthNode!);
      earthNode = null;
    }
    if (moonNode != null) {
      arObjectManager.removeNode(moonNode!);
      moonNode = null;
    }
    if (hubbleNode != null) {
      arObjectManager.removeNode(hubbleNode!);
      hubbleNode = null;
    }
    if (marsNode != null) {
      arObjectManager.removeNode(marsNode!);
      marsNode = null;
    }
    if (venusNode != null) {
      arObjectManager.removeNode(venusNode!);
      venusNode = null;
    }
    if (jupiterNode != null) {
      arObjectManager.removeNode(jupiterNode!);
      jupiterNode = null;
    }
    nodes.forEach((node) {
      this.arObjectManager.removeNode(node);
    });
    nodes = [];
    anchors.forEach((anchor) {
      this.arAnchorManager!.removeAnchor(anchor);
    });
    anchors = [];
    _closeEndDrawer();
  }

// handles rotating models
  onRotationStarted(String nodeName) {
    print("Started rotating node " + nodeName);
  }

  onRotationChanged(String nodeName) {
    print("Continued rotating node " + nodeName);
  }

  onRotationEnded(String nodeName, Matrix4 newTransform) {
    print("Ended rotating node " + nodeName);
    final rotatedNode =
        this.nodes.firstWhere((element) => element.name == nodeName);
  }
}

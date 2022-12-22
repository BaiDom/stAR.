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

  // String webObjectReference
  ARNode? webObjectNode;
  ARNode? webObjectNode2;
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
      appBar: AppBar(
        title: Center(
          child: FittedBox(
            fit: BoxFit.cover,
            child: Text('Augmented Reality',
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: "MartianMono",
                    fontWeight: FontWeight.bold)),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * .8,
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
              children: [
                Expanded(
                  child: ElevatedButton(
                      onPressed: onWebObjectAtButtonPressed,
                      child: const Text("Add / Remove Object 1")),
                ),
                Expanded(
                  child: ElevatedButton(
                      onPressed: onWebObjectAtButtonPressed2,
                      child: const Text("Add / Remove Object 2")),
                ),
                ElevatedButton(
                    onPressed: onRemoveEverything,
                    child: const Text("Remove Placed Objects")),
              ],
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
          customPlaneTexturePath: "assets/triangle.png",
          showWorldOrigin: true,
          // handleTaps: false,
        );
    this.arObjectManager.onInitialize();
    this.arSessionManager.onPlaneOrPointTap = onPlaneOrPointTapped;
    this.arObjectManager.onNodeTap = onNodeTapped;
  }

// NODES STUFF

  Future<void> onRemoveEverything() async {
    nodes.forEach((node) {
      this.arObjectManager.removeNode(node);
    });
    nodes = [];
    anchors.forEach((anchor) {
      this.arAnchorManager!.removeAnchor(anchor);
    });
    anchors = [];
  }

  Future<void> onNodeTapped(List<String> nodes) async {
    var number = nodes.length;
    this.arSessionManager.onError("Tapped $number node(s)");
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
        // Add node to anchor
        var newNode = ARNode(
            type: NodeType.webGLB,
            uri:
                "https://github.com/captainread/test-assets/blob/main/Earth4k.glb?raw=true",
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

// BUTTONS STUFF

  Future<void> onWebObjectAtButtonPressed() async {
    // check if an object has been placed yet. if it hasn't been placed, add the object; if it has, remove it.
    if (webObjectNode != null) {
      arObjectManager.removeNode(webObjectNode!);
      webObjectNode = null;
    } else {
      var newNode = ARNode(
          type: NodeType.webGLB,
          // targeting a GLB file stored online:
          uri:
              "https://github.com/captainread/test-assets/blob/main/Moon_1_3474.glb?raw=true",
          // position of the object (I'm guessing compared to world origin):
          position: Vector3(0.0, 0.0, 0.0),
          // size of the object:
          scale: Vector3(0.15, 0.15, 0.15));
      bool? didAddWebNode = await arObjectManager.addNode(newNode);
      webObjectNode = (didAddWebNode!) ? newNode : null;
    }
  }

// experimenting with creating another (ugly) button which spawns a different model at origin:
  Future<void> onWebObjectAtButtonPressed2() async {
    if (webObjectNode2 != null) {
      arObjectManager.removeNode(webObjectNode2!);
      webObjectNode2 = null;
    } else {
      var newNode = ARNode(
          type: NodeType.webGLB,
          uri:
              "https://github.com/captainread/test-assets/blob/main/Hubble.glb?raw=true",
          position: Vector3(0.1, 0.1, 0.1),
          scale: Vector3(0.2, 0.2, 0.2));
      bool? didAddWebNode = await arObjectManager.addNode(newNode);
      webObjectNode2 = (didAddWebNode!) ? newNode : null;
    }
  }
}

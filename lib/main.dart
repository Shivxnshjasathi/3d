import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Cube',
      theme: ThemeData.light(),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Flutter Cube Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late Scene _scene;
  double initialzoom = 4; // x is initial zoom
  bool spin = true;
  int zoom = 4;
  late Object shark;

  late AnimationController _controller;

  @override
  void initState() {
    shark = Object(fileName: "cube/cube.obj");
    super.initState();
    _controller = AnimationController(
        duration: Duration(milliseconds: 30000), vsync: this)
      ..addListener(() {
        if (shark != null) {
          shark.rotation.y = _controller.value * 360;
          shark.updateTransform();

          if (zoom == 4) {
            if (initialzoom > 1) {
              initialzoom = initialzoom - 0.01;
            }
          } else if (zoom == 1) {
            if (initialzoom < 4) {
              initialzoom = initialzoom + 0.01;
            }
          }

          _scene.camera.zoom = initialzoom;
          _scene.update();
        }
      })
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            Center(
              child: Cube(
                onSceneCreated: (Scene scene) {
                  _scene = scene;
                  scene.world.add(shark);
                  scene.camera.zoom = initialzoom; // use x
                },
              ),
            ),
            Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height / 1.4,),
                Padding(
                  padding: const EdgeInsets.all(60.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          if (spin) {
                            spin = false;
                            _controller.repeat();
                          } else {
                            spin = true;
                            _controller.stop();
                          }
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height / 10,
                          width: MediaQuery.of(context).size.width / 3,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.red,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Center(
                                child: Text("Animation start / stop",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500))),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          if (zoom == 1) {
                            zoom = 4;
                          } else {
                            zoom = 1;
                          }
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height / 10,
                          width: MediaQuery.of(context).size.width / 3,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.blue,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Center(
                                child: Text("Zoom In / Out",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500))),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}

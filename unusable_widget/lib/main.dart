import 'package:flutter/material.dart';

void main() {
  return runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.lightBlue,
        appBar: AppBar(
          title: Text("BrightSquid: Brightness Adjuster!"),
          // backgroundColor: Colors.lightBlue,
        ),
        body: BrightSquid()
      ),
    ),
  );
}

class BrightSquid extends StatefulWidget {

  @override
  BrightSquidState createState() => new BrightSquidState();
}

class SavedValues extends Object {
  static double pressure = 0.0;
  static Image imageAdjust = Image.asset("assets/images/bikini_bottom.jpg");
  static String ow = "Don't hold back.";
  static Stopwatch stopwatch = new Stopwatch();
  static double darknessFactor = 0.0;
}

class BrightSquidState extends State<BrightSquid> {
  void fingerDownHandler(PointerEvent details) {
    setState(() {
      print("Ow");
      if (!SavedValues.stopwatch.isRunning) {
        SavedValues.stopwatch.start();
      }
      SavedValues.pressure = details.pressure;
      SavedValues.ow = "ow";
    });
  }

  void fingerUpHandler(PointerEvent details) {
    setState(() {
      if (SavedValues.stopwatch.isRunning) {
        SavedValues.stopwatch.stop();
        SavedValues.stopwatch.reset();
      }
      SavedValues.ow = "";
      SavedValues.pressure = 0.0;
    });
  }

  void slidingHandler(PointerEvent details) {
    setState(() {
      SavedValues.pressure = details.pressure;
      if (!SavedValues.stopwatch.isRunning) {
        SavedValues.stopwatch.start();
      }
      if (SavedValues.stopwatch.elapsedMilliseconds >= 1500) {
        SavedValues.ow = "I hate all of you.";
        SavedValues.pressure = 0.5;
      }
    });
  }

  double lerpForceToBrightness(double force) {
    // Interpolate from a 0 - 1 scale to 0 - 255.
    double brightness = 128;
    brightness = force * 255;
    return brightness;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Listener(
          child: Image.asset("assets/images/squiddy.jpg"),
          onPointerDown: fingerDownHandler,
          onPointerUp: fingerUpHandler,
          onPointerMove: slidingHandler,
        ),
        AppBar(
          backgroundColor: Colors.blueGrey,
          title: Text("Image to adjust:"),
        ),
        ColorFiltered(child: Image.asset("assets/images/bikini_bottom.jpg"), colorFilter: ColorFilter.matrix(<double>[1, 0, 0, 0, -lerpForceToBrightness(SavedValues.pressure),
          0, 1, 0, 0, -lerpForceToBrightness(SavedValues.pressure),
          0, 0, 1, 0, -lerpForceToBrightness(SavedValues.pressure),
          0, 0, 0, 1, 0])),
        Text("Force of hit: " + SavedValues.pressure.toString(), style: TextStyle(fontSize: 40)),
        Text(SavedValues.ow, style: TextStyle(fontSize: 40)),
      ]
    );
  }
}


import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Watch Face App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        body: WatchFace(),
      ),
    );
  }
}

class WatchFace extends StatefulWidget {
  @override
  _WatchFaceState createState() => _WatchFaceState();
}

class _WatchFaceState extends State<WatchFace> {
  Timer? _timer;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        _now = DateTime.now();
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Center(
        child: CustomPaint(
          painter: ClockPainter(_now),
          size: Size.square(200.0),
        ),
      ),
    );
  }
}

class ClockPainter extends CustomPainter {
  final DateTime _dateTime;

  ClockPainter(this._dateTime);

  @override
  void paint(Canvas canvas, Size size) {
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final double radius = min(centerX, centerY);

    // Saat arka planı
    final Paint backgroundPaint = Paint()..color = Colors.black;
    canvas.drawCircle(Offset(centerX, centerY), radius, backgroundPaint);

    // Saat çerçevesi
    final Paint framePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;
    canvas.drawCircle(Offset(centerX, centerY), radius, framePaint);

    // Saat işaretleri
    final double strokeWidth = 2.0;
    final double hourHandLength = radius * 0.5;
    final double minuteHandLength = radius * 0.7;
    final double secondHandLength = radius * 0.8;

    final Paint hourHandPaint = Paint()
      ..color = Color.fromARGB(255, 255, 255, 255)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final Paint minuteHandPaint = Paint()
      ..color = Color.fromARGB(255, 255, 255, 255)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final Paint secondHandPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final double hourRadians =
        (_dateTime.hour * 30 + _dateTime.minute * 0.5) * (pi / 180);
    final double minuteRadians = (_dateTime.minute * 6) * (pi / 180);
    final double secondRadians = (_dateTime.second * 6) * (pi / 180);

    canvas.drawLine(
      Offset(centerX, centerY),
      Offset(
        centerX + hourHandLength * cos(hourRadians),
        centerY + hourHandLength * sin(hourRadians),
      ),
      hourHandPaint,
    );

    canvas.drawLine(
      Offset(centerX, centerY),
      Offset(
        centerX + minuteHandLength * cos(minuteRadians),
        centerY + minuteHandLength * sin(minuteRadians),
      ),
      minuteHandPaint,
    );

    canvas.drawLine(
      Offset(centerX, centerY),
      Offset(
        centerX + secondHandLength * cos(secondRadians),
        centerY + secondHandLength * sin(secondRadians),
      ),
      secondHandPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

import 'dart:ui';

import 'package:flutter/material.dart';

class LinesPage extends StatefulWidget {
  const LinesPage({Key? key}) : super(key: key);

  @override
  _LinesPageState createState() => _LinesPageState();
}

class _LinesPageState extends State<LinesPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _controller.value = 0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lines")),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 32.0, right: 32.0),
                        child: CustomPaint(
                          painter: LinePainter(progress: _controller.value),
                          size: const Size(double.maxFinite, 100),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 32.0, right: 32.0),
                        child: CustomPaint(
                          painter: DashLinePainter(progress: _controller.value),
                          size: const Size(double.maxFinite, 100),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const Padding(
              padding: EdgeInsets.only(left: 24.0),
              child: Text('Progress'),
            ),
            Slider(
              value: _controller.value,
              min: 0.0,
              max: 1.0,
              onChanged: (value) {
                setState(() {
                  _controller.value = value;
                });
              },
            ),
            Center(
              child: ElevatedButton(
                child: const Text('Animated'),
                onPressed: () {
                  _controller.reset();
                  _controller.forward();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class LinePainter extends CustomPainter {
  final double progress;

  const LinePainter({
    required this.progress,
  });

  static final _paint = Paint()
    ..color = Colors.black
    ..strokeWidth = 4.0
    ..style = PaintingStyle.stroke
    ..strokeJoin = StrokeJoin.round;

  @override
  void paint(Canvas canvas, Size size) {
    var path = Path();
    path.moveTo(0, size.height / 2);
    path.lineTo(size.width * progress, size.height / 2);
    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(covariant LinePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class DashLinePainter extends CustomPainter {
  final double progress;

  const DashLinePainter({required this.progress});

  static final _paint = Paint()
    ..color = Colors.black
    ..strokeWidth = 4.0
    ..style = PaintingStyle.stroke
    ..strokeJoin = StrokeJoin.round;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, size.height / 2)
      ..lineTo(size.width * progress, size.height / 2);

    Path dashPath = Path();
    double dashWidth = 10.0;
    double dashSpace = 5.0;
    double distance = 0.0;

    for (PathMetric pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        dashPath.addPath(
          pathMetric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth;
        distance += dashSpace;
      }
    }
    canvas.drawPath(dashPath, _paint);
  }

  @override
  bool shouldRepaint(covariant DashLinePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

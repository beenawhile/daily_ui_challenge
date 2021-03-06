import 'package:daily_ui/2022/6/4_drawing/drawn_line.dart';
import 'package:flutter/material.dart';

class HandDrawingPainter extends CustomPainter {
  final List<DrawnLine?> lines;

  const HandDrawingPainter({required this.lines});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;

    for (int i = 0; i < lines.length; ++i) {
      if (lines[i] == null) continue;
      for (int j = 0; j < lines[i]!.path.length - 1; ++j) {
        if (lines[i]!.path[j] != null && lines[i]!.path[j + 1] != null) {
          paint.color = lines[i]!.color;
          paint.strokeWidth = lines[i]!.width;
          canvas.drawLine(lines[i]!.path[j]!, lines[i]!.path[j + 1]!, paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(HandDrawingPainter oldDelegate) {
    return true;
  }
}

import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class TextToPictureConverter {
  static ui.Picture convert({
    required String text,
    required double canvasSize,
    required bool border,
  }) {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(
      recorder,
      Rect.fromPoints(const Offset(0.0, 0.0), Offset(canvasSize, canvasSize)),
    );

    const Color color = Colors.white;

    if (border) {
      final stroke = Paint()
        ..color = color
        ..style = PaintingStyle.stroke;

      canvas.drawRect(Rect.fromLTWH(0.0, 0.0, canvasSize, canvasSize), stroke);
    }

    final span = TextSpan(
      style:
          const TextStyle(fontFamily: "Monospace", color: color, fontSize: 24),
      text: text,
    );

    final tp = TextPainter(
      text: span,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    tp.layout(
      minWidth: 0,
      maxWidth: double.infinity,
    );

    final offset =
        Offset((canvasSize - tp.width) * 0.5, (canvasSize - tp.height) * 0.5);
    tp.paint(canvas, offset);

    return recorder.endRecording();
  }
}

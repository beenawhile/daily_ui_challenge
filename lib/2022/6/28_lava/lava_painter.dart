import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:daily_ui/2022/6/28_lava/ball.dart';

class LavaPainter extends CustomPainter {
  final Color color;
  final Lava lava;
  const LavaPainter(
    this.color,
    this.lava,
  );

  @override
  void paint(Canvas canvas, Size size) {
    lava.draw(canvas, size, color, debug: false);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class Lava {
  num step = 5;
  Size size;

  double get width => size.width;

  double get height => size.height;

  late Rect sRect;

  double get sx => (width ~/ step).floor().toDouble();

  double get sy => (height ~/ step).floor().toDouble();

  bool paint = false;
  double iter = 0;
  int sign = 1;

  late Map<int, Map<int, ForcePoint>> matrix;

  late List<Ball> balls;
  int ballsLength;

  Lava(this.ballsLength, this.size);

  void updateSize(Size size) {
    size = size;
    sRect = Rect.fromCenter(
        center: Offset.zero, width: sx.toDouble(), height: sy.toDouble());

    matrix = {};
    for (int i = (sRect.left - step).toInt(); i < sRect.right + step; i++) {
      matrix[i] = {};
      for (int j = (sRect.top - step).toInt(); j < sRect.bottom + step; j++) {
        matrix[i]![j] = ForcePoint(
            (i + sx ~/ 2).toDouble() * step, (j + sy ~/ 2).toDouble() * step);
      }
    }
    balls = List.filled(ballsLength, Ball(size));
  }

  double computeForce(int sx, int sy) {
    double force;
    if (!sRect.contains(Offset(sx.toDouble(), sy.toDouble()))) {
      force = .6 * sign;
    } else {
      force = 0;
      final point = matrix[sx]?[sy];
      for (final ball in balls) {
        force += ball.radius *
            ball.radius /
            (-2 * point!.x * ball.pos.x -
                2 * point.y * ball.pos.y +
                ball.pos.magnitude +
                point.magnitude);
      }
      force *= sign;
    }

    matrix[sx]?[sy]?.force = force;
    return force;
  }

  final List<int> plx = [0, 0, 1, 0, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 0, 0];
  final List<int> ply = [0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1, 1, 0, 1, 0, 1];
  final List<int> mscases = [0, 3, 0, 3, 1, 3, 0, 3, 2, 2, 0, 2, 1, 1, 0];
  final ix = [1, 0, -1, 0, 0, 1, 0, -1, -1, 0, 1, 0, 0, 1, 1, 0, 0, 0, 1, 1];

  List? marchingSquares(List? params, Path path) {
    int sx = params![0];
    int sy = params[1];
    int? pdir = params[2];

    if (matrix[sx]?[sy]?.computed == iter) return null;

    int dir, mscase = 0;
    for (var a = 0; 4 > a; a++) {
      final dx = ix[a + 12];
      final dy = ix[a + 16];
      double? force = matrix[sx + dx]?[sy + dy]?.force;
      if (force == null ||
          force > 0 && sign < 0 ||
          force < 0 && sign > 0 ||
          force == 0) {
        force = computeForce(sx + dx, sy + dy);
      }
      if (force.abs() > 1) {
        mscase += math.pow(2, a).toInt();
      }
    }

    if (15 == mscase) {
      return [sx, sy - 1, null];
    } else if (5 == mscase) {
      dir = 2 == pdir ? 3 : 1;
    } else if (10 == mscase) {
      dir = 3 == pdir ? 0 : 2;
    } else {
      dir = mscases[mscase];
      matrix[sx]![sy]!.computed = iter;
    }

    final dx1 = plx[(4 * dir + 2).toInt()];
    final dy1 = ply[(4 * dir + 2).toInt()];
    final pForce1 = matrix[sx + dx1]?[sy + dy1]?.force;

    final dx2 = plx[(4 * dir + 3).toInt()];
    final dy2 = ply[(4 * dir + 3).toInt()];
    final pForce2 = matrix[sx + dx2]?[sy + dy2]?.force;
    final p =
        step / ((pForce1!.abs() - 1).abs() / (pForce2!.abs() - 1).abs() + 1.0);

    final dxX = plx[(4 * dir).toInt()];
    final dyX = ply[(4 * dir).toInt()];
    final dxY = plx[(4 * dir + 1).toInt()];
    final dyY = ply[(4 * dir + 1).toInt()];

    final lineX = matrix[sx + dxX]![sy + dyX]!.x + ix[dir] * p;
    final lineY = matrix[sx + dxY]![sy + dyY]!.y + ix[dir + 4] * p;

    if (paint == false) {
      path.moveTo(lineX, lineY);
    } else {
      path.lineTo(lineX, lineY);
    }
    paint = true;
    return [sx + ix[dir + 4], sy + ix[dir + 8], dir];
  }

  void draw(Canvas canvas, Size size, Color color, {bool debug = false}) {
    for (Ball ball in balls) {
      ball.moveIn(size);
    }

    iter++;
    sign = -sign;
    paint = false;

    for (Ball ball in balls) {
      Path path = Path();
      List? params = [
        (ball.pos.x / step - sx / 2).round(),
        (ball.pos.y / step - sy / 2).round(),
        null,
      ];
      do {
        params = marchingSquares(params, path);
      } while (params != null);
      if (paint) {
        path.close();

        Paint paint = Paint()..color = color;

        canvas.drawPath(path, paint);

        this.paint = false;
      }
    }

    if (debug) {
      for (var ball in balls) {
        canvas.drawCircle(Offset(ball.pos.x.toDouble(), ball.pos.y.toDouble()),
            ball.radius, Paint()..color = Colors.black.withOpacity(0.5));
      }

      matrix.forEach((_, item) => item.forEach((_, point) => canvas.drawCircle(
          Offset(point.x.toDouble(), point.y.toDouble()),
          math.max(1, math.min(point.force.abs(), 5)),
          Paint()..color = point.force > 0 ? Colors.blue : Colors.red)));
    }
  }
}

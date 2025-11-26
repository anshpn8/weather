import 'package:flutter/material.dart';
import 'dart:math';

class WindDirectionIndicator extends StatelessWidget {
  final double angle; // 0–360 degrees
  final double speed; // km/h

  const WindDirectionIndicator({
    super.key,
    required this.angle,
    required this.speed,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _WindDirectionPainter(angle, speed),
      size: const Size(180, 180),
    );
  }
}


class _WindDirectionPainter extends CustomPainter {
  final double angle;
  final double speed;

  _WindDirectionPainter(this.angle, this.speed);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;

    // Big circle
    final circlePaint = Paint()
      ..color = Colors.grey.shade500
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15;

    canvas.drawCircle(center, radius, circlePaint);

    // Arrow head
    final rad = (angle - 90) * pi / 180;

    final arrowCenter = Offset(
      center.dx + (radius-8) * cos(rad),
      center.dy + (radius-8) * sin(rad),
    );

    final arrowPaint = Paint()..color = Colors.blueAccent;
    const headSize = 16.0;

    final leftWing = Offset(
      arrowCenter.dx + headSize * cos(rad + pi * 0.8),
      arrowCenter.dy + headSize * sin(rad + pi * 0.8),
    );
    final rightWing = Offset(
      arrowCenter.dx + headSize * cos(rad - pi * 0.8),
      arrowCenter.dy + headSize * sin(rad - pi * 0.8),
    );

    final path = Path()
      ..moveTo(arrowCenter.dx, arrowCenter.dy)
      ..lineTo(leftWing.dx, leftWing.dy)
      ..lineTo(rightWing.dx, rightWing.dy)
      ..close();

    canvas.drawPath(path, arrowPaint);

    // Center wind speed
    TextPainter(
      text: TextSpan(
        text: "${speed.toInt()} km/h",
        style: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )
      ..layout()
      ..paint(canvas, Offset(center.dx - 35, center.dy - 14));

    // Direction labels with rotation toward center
    const directions = {
      "W": 270.0,
      "NW": 315.0,
      "N": 0.0,
      "NE": 45.0,
      "E": 90.0,
      "SE": 135.0,
      "S": 180.0,
      "SW": 225.0,
    };

    directions.forEach((label, deg) {
      // border position
      final rad = (deg - 90) * pi / 180;
      final offset = Offset(
        center.dx + (radius) * cos(rad),
        center.dy + (radius) * sin(rad),
      );

      // rotation angle so text faces center
      final textRotation = (deg) * pi / 180; // turn toward center

      canvas.save();
      canvas.translate(offset.dx, offset.dy);
      canvas.rotate(textRotation);

      final tp = TextPainter(
        text: TextSpan(
          text: label,
          style: const TextStyle(
            fontSize: 15,
            color: Colors.black,
            // fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));

      canvas.restore();
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}


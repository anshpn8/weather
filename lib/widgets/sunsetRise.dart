import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/data_model/forecastmodel.dart';

class SunArcProgress extends StatelessWidget {
  final DateTime sunrise;
  final DateTime sunset;
  final DateTime currentTime;

  const SunArcProgress({
    super.key,
    required this.sunrise,
    required this.sunset,
    required this.currentTime,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(300, 150),
      painter: _SunSinePainter(
        sunrise: sunrise,
        sunset: sunset,
        currentTime: currentTime,
      ),
    );
  }
}


class _SunSinePainter extends CustomPainter {
  final DateTime sunrise;
  final DateTime sunset;
  final DateTime currentTime;

  _SunSinePainter({
    required this.sunrise,
    required this.sunset,
    required this.currentTime,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;

    final double amplitude = height * 0.4;
    final double midY = height * 0.6;

    final int steps = 200;

    // ----- Gradient for base curve -----
    final Gradient baseGradient = LinearGradient(
      colors: [
        Colors.orange.withOpacity(0.15),
        Colors.orange.withOpacity(0.25),
        Colors.orange.withOpacity(0.15),
      ],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );

    final Paint basePaint = Paint()
      ..shader = baseGradient.createShader(
        Rect.fromLTWH(0, 0, width, height),
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    // ----- Gradient for progress curve -----
    final Gradient progressGradient = LinearGradient(
      colors: [
        Colors.yellow,
        Colors.orange,
        Colors.deepOrange,
      ],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );

    final Paint progressPaint = Paint()
      ..shader = progressGradient.createShader(
        Rect.fromLTWH(0, 0, width, height),
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final Paint sunPaint = Paint()..color = Colors.yellow;

    Path basePath = Path();
    Path progressPath = Path();

    // ----- Calculate daily progress (0..1) -----
    final totalMinutes = sunset.difference(sunrise).inMinutes;
    final elapsedMinutes =
    currentTime.difference(sunrise).inMinutes.clamp(0, totalMinutes);

    final double progress = elapsedMinutes / totalMinutes;

    // ----- Draw sine curve and progress path -----
    for (int i = 0; i <= steps; i++) {
      double t = i / steps; // 0..1
      double x = t * width;
      double y = midY - sin(t * pi) * amplitude;

      if (i == 0) {
        basePath.moveTo(x, y);
        progressPath.moveTo(x, y);
      } else {
        basePath.lineTo(x, y);

        if (t <= progress) {
          progressPath.lineTo(x, y);
        }
      }
    }

    canvas.drawPath(basePath, basePaint);
    canvas.drawPath(progressPath, progressPaint);

    // ---- Draw sun ----
    double sunX = progress * width;
    double sunY = midY - sin(progress * pi) * amplitude;

    canvas.drawCircle(Offset(sunX, sunY), 10, sunPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}


class SunArcWidget extends StatelessWidget {
  final AstroModel astroModel;
  final DateTime currentTime;

  const SunArcWidget({
    Key? key,
    required this.astroModel,
    required this.currentTime,
  }) : super(key: key);

  DateTime _parseTimeToday(String time) {
    final now = DateTime.now();
    final parsed = DateFormat("hh:mm a").parse(time);

    return DateTime(
      now.year,
      now.month,
      now.day,
      parsed.hour,
      parsed.minute,
    );
  }

  @override
  Widget build(BuildContext context) {
    final sunrise = _parseTimeToday(astroModel.sunrise);
    final sunset = _parseTimeToday(astroModel.sunset);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color.fromRGBO(112, 110, 110, 0.45),
      ),
      child: Column(
        children: [
          SunArcProgress(
            sunrise: sunrise,
            sunset: sunset,
            currentTime: currentTime,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text("Sun Rise"),
                  Text(astroModel.sunrise)
                ],
              ),
              Column(
                children: [
                  Text("Sun Set"),
                  Text(astroModel.sunset)
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

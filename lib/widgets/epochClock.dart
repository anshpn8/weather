import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class EpochClock extends StatefulWidget {
  final int timeEpoch; // Unix timestamp (seconds or milliseconds)

  const EpochClock({Key? key, required this.timeEpoch}) : super(key: key);

  @override
  _EpochClockState createState() => _EpochClockState();
}

class _EpochClockState extends State<EpochClock> {
  late DateTime _currentTime;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // Convert epoch to DateTime
    _currentTime = _epochToDateTime(widget.timeEpoch);

    // Start ticking every second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = _currentTime.add(const Duration(seconds: 1));
      });
    });
  }

  DateTime _epochToDateTime(int epoch) {
    // Handle both seconds and milliseconds
    if (epoch.toString().length == 10) {
      return DateTime.fromMillisecondsSinceEpoch(epoch * 1000);
    } else {
      return DateTime.fromMillisecondsSinceEpoch(epoch);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Analog clock face
        SizedBox(
          width: 100,
          height: 100,
          child: CustomPaint(
            painter: _ClockPainter(_currentTime),
          ),
        ),
        const SizedBox(height: 10),
        // Digital time display
        Text(
          "${_currentTime.hour.toString().padLeft(2, '0')}:${_currentTime.minute.toString().padLeft(2, '0')}:${_currentTime.second.toString().padLeft(2, '0')}",
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _ClockPainter extends CustomPainter {
  final DateTime time;

  _ClockPainter(this.time);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final Paint circlePaint = Paint()
      ..color = Color.fromRGBO(112, 110, 110, 0.1)
      ..style = PaintingStyle.fill;

    final Paint borderPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    // Draw clock face
    canvas.drawCircle(center, radius, circlePaint);
    canvas.drawCircle(center, radius, borderPaint);

    // Hour hand
    final hourAngle = (time.hour % 12 + time.minute / 60) * 30 * (3.1416 / 180);
    final hourHand = Offset(
      center.dx + radius * 0.5 * cos(hourAngle - 3.1416 / 2),
      center.dy + radius * 0.5 * sin(hourAngle - 3.1416 / 2),
    );
    canvas.drawLine(center, hourHand, Paint()..color = Colors.black..strokeWidth = 6);

    // Minute hand
    final minuteAngle = (time.minute + time.second / 60) * 6 * (3.1416 / 180);
    final minuteHand = Offset(
      center.dx + radius * 0.7 * cos(minuteAngle - 3.1416 / 2),
      center.dy + radius * 0.7 * sin(minuteAngle - 3.1416 / 2),
    );
    canvas.drawLine(center, minuteHand, Paint()..color = Colors.black..strokeWidth = 4);

    // Second hand
    final secondAngle = time.second * 6 * (3.1416 / 180);
    final secondHand = Offset(
      center.dx + radius * 0.9 * cos(secondAngle - 3.1416 / 2),
      center.dy + radius * 0.9 * sin(secondAngle - 3.1416 / 2),
    );
    canvas.drawLine(center, secondHand, Paint()..color = Colors.red..strokeWidth = 2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

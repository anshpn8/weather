// timer_widget.dart
import 'dart:async';
import 'package:flutter/material.dart';

class TimerWidget extends StatefulWidget {
  final Function(int time) setTime;
  int takenTime;
  TimerWidget(this.setTime,this.takenTime, {super.key});


  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  late Timer _timer;
  late int _elapsedSeconds;

  @override
  void initState() {
    _elapsedSeconds = widget.takenTime;
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {
          _elapsedSeconds++;
          widget.setTime(_elapsedSeconds);
        });
      }
    });
  }

  String _formatTime(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;

    return "${ hours >0? "${_twoDigits(hours)}:" : ""}${_twoDigits(minutes)}:${_twoDigits(secs)}";
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Text(
      _formatTime(_elapsedSeconds),
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }
}


class EpochClockWidget extends StatefulWidget {
  final int epochTime; // in seconds

  const EpochClockWidget({Key? key, required this.epochTime}) : super(key: key);

  @override
  _EpochClockWidgetState createState() => _EpochClockWidgetState();
}

class _EpochClockWidgetState extends State<EpochClockWidget> {
  late DateTime startTime;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTime = DateTime.fromMillisecondsSinceEpoch(widget.epochTime * 1000);

    // Update every 1 minute
    timer = Timer.periodic(const Duration(minutes: 1), (Timer t) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  DateTime getCurrentTime() {
    final now = DateTime.now();
    final elapsed = now.difference(startTime);
    return startTime.add(elapsed);
  }

  @override
  Widget build(BuildContext context) {
    final currentTime = getCurrentTime();
    return Text(
      "${currentTime.hour.toString().padLeft(2, '0')}:"
          "${currentTime.minute.toString().padLeft(2, '0')}",
      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
    );
  }
}


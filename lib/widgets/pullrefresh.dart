import 'package:flutter/material.dart';

class CustomPullToRefresh extends StatefulWidget {
  final Widget child;
  final Future<void> Function() onRefresh;

  const CustomPullToRefresh({
    super.key,
    required this.child,
    required this.onRefresh,
  });

  @override
  State<CustomPullToRefresh> createState() => _CustomPullToRefreshState();
}

class _CustomPullToRefreshState extends State<CustomPullToRefresh>
    with SingleTickerProviderStateMixin {


  double dragOffset = 0.0;
  final double triggerOffset = 10; // required swipe length to refresh
  bool isRefreshing = false;

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (isRefreshing) return;

    setState(() {
      dragOffset += details.delta.dy;
      if (dragOffset < 0) dragOffset = 0;
    });
  }

  void _handleDragEnd(DragEndDetails details) async {
    if (isRefreshing) return;

    if (dragOffset >= triggerOffset) {
      // Trigger refresh
      setState(() => isRefreshing = true);

      await widget.onRefresh();

      // Reset with animation
      _controller.forward(from: 0).then((_) {
        setState(() {
          dragOffset = 0;
          isRefreshing = false;
        });
      });
    } else {
      // Not enough drag → animate back
      _controller.forward(from: 0).then((_) {
        setState(() {
          dragOffset = 0;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double progress = (dragOffset / triggerOffset).clamp(0.0, 1.0);

    return Stack(
      children: [
        GestureDetector(
          onVerticalDragUpdate: _handleDragUpdate,
          onVerticalDragEnd: _handleDragEnd,
          child: Transform.translate(
            offset: Offset(0, dragOffset * 0.4), // smooth pulling effect
            child: widget.child,
          ),
        ),

        // Pull Progress Indicator
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Opacity(
            opacity: progress,
            child: Transform.scale(
              scale: progress,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: isRefreshing
                      ? const Center(
                      child: CircularProgressIndicator(strokeWidth: 3)
                    )
                      : CircularProgressIndicator(
                    strokeWidth: 3,
                    value: progress, // progress according to swipe
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// widgets/moon_phase.dart
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

/// MoonPhaseWidget
/// - [assetPath]: path to your full-moon PNG asset (the full moon image).
/// - [brightnessPercent]: 0..100 (0 = fully dark / new moon, 100 = fully bright / full moon)
/// - [litOnRight]: true => lit side is right (waxing), false => lit side is left (waning)
/// - [size]: width & height (square). If null uses available space / image intrinsic size.
class MoonPhaseWidget extends StatelessWidget {
  final String assetPath;
  final double brightnessPercent;
  final bool litOnRight;
  final double? size;
  final double darknessOpacity; // how dark the night side is (0..1)

  const MoonPhaseWidget({
    Key? key,
    required this.assetPath,
    required this.brightnessPercent,
    this.litOnRight = true,
    this.size,
    this.darknessOpacity = 0.62,
  })  : assert(brightnessPercent >= 0 && brightnessPercent <= 100),
        assert(darknessOpacity >= 0 && darknessOpacity <= 1),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    // clamp brightness
    final double k = (brightnessPercent.clamp(0.0, 100.0)) / 100.0;

    // Use a Stack: image at bottom, overlay painter on top
    return LayoutBuilder(builder: (context, constraints) {
      final double dimension = size ??
          min(constraints.maxWidth == double.infinity ? 200 : constraints.maxWidth,
              constraints.maxHeight == double.infinity ? 200 : constraints.maxHeight);

      return SizedBox(
        width: dimension,
        height: dimension,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Full moon image (fit center, keep aspect)
            ClipOval(
              child: Image.asset(
                assetPath,
                fit: BoxFit.fill,
                errorBuilder: (_, __, ___) => Container(color: Colors.grey),
              ),
            ),

            // overlay that draws darkness and cut out the illuminated part
            CustomPaint(
              painter: _MoonPhasePainter(
                brightness: k,
                litOnRight: litOnRight,
                darknessOpacity: darknessOpacity,
              ),
            ),
          ],
        ),
      );
    });
  }
}

/// CustomPainter that draws a dark overlay and cuts out the illuminated area
class _MoonPhasePainter extends CustomPainter {
  final double brightness; // 0..1
  final bool litOnRight;
  final double darknessOpacity;

  _MoonPhasePainter({
    required this.brightness,
    required this.litOnRight,
    required this.darknessOpacity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Working on a circle that fits the bounds.
    final Offset center = Offset((size.width) / 2, (size.height) / 2);
    final double radius = (min(size.width, size.height)-20) / 2;

    // Save layer so blend modes work reliably
    final Paint layerPaint = Paint();
    canvas.saveLayer(Offset.zero & size, layerPaint);

    // 1) Draw full dark overlay (the "night" side)
    final Paint darkPaint = Paint()
      ..color = Colors.black.withOpacity(darknessOpacity)
      ..style = PaintingStyle.fill;

    // draw a circle mask (only moon disc area should be affected)
    canvas.drawCircle(center, radius, darkPaint);

    // 2) Compute illuminated "bulb" shape by cutting the dark overlay with a shifted circle.
    //
    // Approach (approximation):
    //   - Create a second circle (same radius) whose center is horizontally shifted.
    //   - Use BlendMode.dstOut (or clear) to remove the overlapping part of the dark overlay,
    //     exposing the underlying full-moon image.
    //
    // The horizontal shift depends on brightness:
    //   - brightness = 1.0 -> shift far enough to reveal nearly the whole disc (full moon)
    //   - brightness = 0.0 -> shift far enough to reveal nothing (new moon)
    //
    // We use shift = (1.0 - 2*k) * radius where k = brightness.
    // This produces a crescent / gibbous shape visually similar to lunar phases.
    //
    final double k = brightness.clamp(0.0, 1.0);

    // compute shift; direction depends on litOnRight
    final double shiftSign = litOnRight ? 1.0 : -1.0;

    // offset factor: when k = 0.5 -> shift = 0 (half moon)
    // when k ~ 1: shift -> -radius (approx fully revealed on right)
    // when k ~ 0: shift -> +radius (fully dark)
    final double shift = (1.0 - 2.0 * k) * radius * shiftSign;

    final Offset litCenter = Offset(center.dx - shift, center.dy);

    // draw the "lit cutter" circle with dstOut to remove dark overlay
    final Paint cutter = Paint()..blendMode = BlendMode.dstOut;

    canvas.drawCircle(litCenter, radius, cutter);

    // 3) Add subtle gradient glow for the lit side to make it pop a bit
    if (k > 0.03) {
      // glow intensity scales with brightness
      final double glowAlpha = (0.45 * k).clamp(0.0, 0.0);
      final Paint glowPaint = Paint()
        ..blendMode = BlendMode.screen
        ..shader = ui.Gradient.radial(
          Offset(litCenter.dx, litCenter.dy),
          radius * 1.1,
          [
            Colors.yellow.withOpacity(glowAlpha),
            Colors.transparent,
          ],
        );

      // Draw glow only within moon disc area:
      canvas.drawCircle(center, radius, glowPaint);
    }

    // 4) (Optional) draw a soft terminator shadow edge - darken the boundary a bit
    // We'll paint a thin semi-transparent arc along terminator to give depth.
    final Paint terminator = Paint()
      ..color = Colors.black.withOpacity(0.08 * (1 - k))
      ..style = PaintingStyle.stroke
      ..strokeWidth = max(1.0, radius * 0.04)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, radius * 0.1);

    // shape of terminator: approximate as the circle intersection outline
    // We'll draw a circle offset center to mimic the terminator center.
    final Offset termCenter = litCenter;
    canvas.drawCircle(termCenter, radius, terminator);

    // restore layer
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _MoonPhasePainter oldDelegate) {
    return oldDelegate.brightness != brightness || oldDelegate.litOnRight != litOnRight;
  }
}

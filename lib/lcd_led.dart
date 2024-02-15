library lcd_led;

import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';

/// Class to defines multiple digit
class LedDigits extends StatelessWidget {
  const LedDigits({
    super.key,
    required this.number,
    required this.numberOfDigits,
    this.spacing = 10,
    this.backgroundColor = Colors.black,
    this.offColor = const Color.fromARGB(255, 49, 49, 49),
    this.onColor = Colors.red,
  });

  final int number;

  final int numberOfDigits;

  final double spacing;

  final Color backgroundColor;

  final Color offColor;

  final Color onColor;

  List<Widget> getDigits(int number, BoxConstraints constraints) {
    List<Widget> digits = [];
    // 'N' means leds off
    String numberString = number.toString().padLeft(numberOfDigits, 'N');
    for (int i = 0; i < numberOfDigits; i++) {
      double w =
          (constraints.maxWidth - spacing * (numberOfDigits - 1)) / numberOfDigits;
      digits.add(
        SizedBox(
          width: w,
          height: constraints.maxHeight,
          child: LedDigit(
            digit: numberString[i],
            backgroundColor: backgroundColor,
            offColor: offColor,
            onColor: onColor,
          ),
        ),
      );
      if (i < numberOfDigits - 1) {
        digits.add(
          SizedBox(width: spacing),
        );
      }
    }
    return digits;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return ColoredBox(
        color: backgroundColor,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: getDigits(number, constraints),
        ),
      );
    });
  }
}

/// Class to defines a single digit
///
class LedDigit extends StatefulWidget {
  const LedDigit({
    super.key,
    required this.digit,
    this.backgroundColor = Colors.black,
    this.offColor = const Color.fromARGB(255, 49, 49, 49),
    this.onColor = Colors.red,
  });

  final String digit;

  final Color backgroundColor;

  final Color offColor;

  final Color onColor;

  @override
  State<LedDigit> createState() => _LedDigitState();
}

class _LedDigitState extends State<LedDigit>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Uint8List lcd;
  Uint8List? oldLcd;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    controller.addListener(() {
      setState(() {});
    });
    controller.forward(from: 0);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant LedDigit oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.digit != widget.digit) {
      controller.forward(from: 0);
      oldLcd = lcd;
    }
  }

  @override
  Widget build(BuildContext context) {
    //       0
    //     ----
    //   1|    |2
    //    |  3 |
    //     ----
    //   4|    |5
    //    |    |
    //     ----
    //       6
    switch (widget.digit) {
      case '0': ///////////////// 0  1  2  3  4  5  6
        lcd = Uint8List.fromList([1, 1, 1, 0, 1, 1, 1]);
      case '1':
        lcd = Uint8List.fromList([0, 0, 1, 0, 0, 1, 0]);
      case '2':
        lcd = Uint8List.fromList([1, 0, 1, 1, 1, 0, 1]);
      case '3':
        lcd = Uint8List.fromList([1, 0, 1, 1, 0, 1, 1]);
      case '4':
        lcd = Uint8List.fromList([0, 1, 1, 1, 0, 1, 0]);
      case '5':
        lcd = Uint8List.fromList([1, 1, 0, 1, 0, 1, 1]);
      case '6':
        lcd = Uint8List.fromList([1, 1, 0, 1, 1, 1, 1]);
      case '7':
        lcd = Uint8List.fromList([1, 0, 1, 0, 0, 1, 0]);
      case '8':
        lcd = Uint8List.fromList([1, 1, 1, 1, 1, 1, 1]);
      case '9':
        lcd = Uint8List.fromList([1, 1, 1, 1, 0, 1, 1]);
      case '-':
        lcd = Uint8List.fromList([0, 0, 0, 1, 0, 0, 0]);
      case 'N':
        lcd = Uint8List.fromList([0, 0, 0, 0, 0, 0, 0]);
    }

    return RepaintBoundary(
      child: ClipRect(
        child: CustomPaint(
          painter: _DigitPainter(
            lcd: lcd,
            oldLcd: oldLcd ?? Uint8List.fromList([0, 0, 0, 0, 0, 0, 0]),
            backgroundColor: widget.backgroundColor,
            offColor: widget.offColor,
            onColor: widget.onColor,
            animValue: controller.value,
          ),
        ),
      ),
    );
  }
}

/// CustomPainter to draw the digit
///
class _DigitPainter extends CustomPainter {
  _DigitPainter({
    required this.lcd,
    required this.oldLcd,
    required this.backgroundColor,
    required this.offColor,
    required this.onColor,
    this.animValue = 1,
  });

  final Uint8List lcd;
  final Uint8List oldLcd;

  final Color backgroundColor;

  final Color offColor;

  final Color onColor;

  final double? animValue;

  @override
  void paint(Canvas canvas, Size size) {
    final thickness = size.width * 0.2;

    canvas.drawRect(Offset.zero & size, Paint()..color = backgroundColor);
    for (int i = 0; i < lcd.length; i++) {
      final paint = Paint()
        ..color = lcd[i] == 1
            ? (oldLcd[i] == 1
                ? onColor
                : Color.lerp(offColor, onColor, animValue!)!)
            : (oldLcd[i] == 0
                ? offColor
                : Color.lerp(onColor, offColor, animValue!)!)
        ..style = PaintingStyle.fill;

      //       0
      //     ----
      //   1|    |2
      //    |  3 |
      //     ----
      //   4|    |5
      //    |    |
      //     ----
      //       6
      Path path = Path();

      /// build single led path
      switch (i) {
        case 0:
          final double x1 = 0, y1 = 0, x2 = size.width, y2 = thickness;
          path
            ..moveTo(x1, y1)
            ..lineTo(x2, y1)
            ..lineTo(x2 - thickness, y2)
            ..lineTo(x1 + thickness, y2)
            ..close();
          break;
        case 1:
          final double x1 = 0, y1 = 0, x2 = thickness, y2 = size.height / 2;
          path
            ..moveTo(x1, y1)
            ..lineTo(x1, y2)
            ..lineTo(x2, y2 - thickness / 2)
            ..lineTo(x2, thickness)
            ..close();
          break;
        case 2:
          final double x1 = size.width - thickness,
              y1 = 0,
              x2 = size.width,
              y2 = size.height / 2;
          path
            ..moveTo(x1, thickness)
            ..lineTo(x2, y1)
            ..lineTo(x2, y2)
            ..lineTo(x1, y2 - thickness / 2)
            ..close();
          break;
        case 3:
          final double x1 = 0,
              y1 = size.height / 2 - thickness / 4,
              x2 = size.width,
              y2 = size.height / 2 + thickness / 4;
          path
            ..moveTo(x1, y1 + thickness / 4)
            ..lineTo(x1 + thickness, y1 - thickness / 4)
            ..lineTo(x2 - thickness, y1 - thickness / 4)
            ..lineTo(x2, y2 - thickness / 4)
            ..lineTo(x2 - thickness, y2 + thickness / 4)
            ..lineTo(x1 + thickness, y2 + thickness / 4)
            ..close();
          break;
        case 4:
          final double x1 = 0,
              y1 = size.height / 2,
              x2 = thickness,
              y2 = size.height;
          path
            ..moveTo(x1, y1)
            ..lineTo(x2, y1 + thickness / 2)
            ..lineTo(x2, y2 - thickness)
            ..lineTo(x1, y2)
            ..close();
          break;
        case 5:
          final double x1 = size.width - thickness,
              y1 = size.height / 2,
              x2 = size.width,
              y2 = size.height;
          path
            ..moveTo(x1, y1 + thickness / 2)
            ..lineTo(x2, y1)
            ..lineTo(x2, y2)
            ..lineTo(x1, y2 - thickness)
            ..close();
          break;
        case 6:
          final double x1 = 0,
              y1 = size.height - thickness,
              x2 = size.width,
              y2 = size.height;
          path
            ..moveTo(x1 + thickness, y1)
            ..lineTo(x2 - thickness, y1)
            ..lineTo(x2, y2)
            ..lineTo(x1, y2)
            ..close();
          break;
      }

      canvas.drawPath(path, paint);
      paint
        ..color = backgroundColor
        ..strokeWidth = thickness / 3
        ..style = PaintingStyle.stroke;
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_DigitPainter oldDelegate) {
    return animValue != oldDelegate.animValue && lcd != oldDelegate.lcd;
  }
}

import 'dart:async';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:lcd_led/lcd_led.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  /// The string with supported chars to give 
  /// to the `LedDigits` `string` parameter
  var n = ' ';

  @override
  void initState() {
    super.initState();
    /// Update the `string` parameter ever 1/10 of a second
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (context.mounted) {
        setState(() {
          var now = DateTime.now();
          n = '-${DateFormat('kk:mm:ss').format(now)}.${now.millisecond ~/ 100}';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      home: Scaffold(
        body: Center(
          // child: SizedBox(
          //   width: 500,
          //   height: 70,
          //   child: LedDigits(
          //     string: n,
          //     numberOfLeds: 12,
          //     spacing: 5,
          //   ),
          // ),
          child: SizedBox(
            height: 70,
            child: AspectRatio(
              aspectRatio: n.length.toDouble() / 1.5,
              child: LedDigits(
                string: n,
                numberOfLeds: n.length,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

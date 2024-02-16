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
  var n = 'N';

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (context.mounted) {
        setState(() {
          var now = DateTime.now();
          n = '-${DateFormat('kk:mm:ss').format(now)}.${now.millisecond~/100}';
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
          child: SizedBox(
            width: 500,
            height: 70,
            child: LedDigits(
              string: n,
              numberOfLeds: 11,
              spacing: 5,
            ),
          ),
        ),
      ),
    );
  }
}

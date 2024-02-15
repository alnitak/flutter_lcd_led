import 'dart:async';

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
  var n = 50;

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (context.mounted) {
        setState(() {
          n--;
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
            width: 400,
            height: 100,
            child: LedDigits(
              number: n,
              numberOfDigits: 5,
              spacing: 20,
            ),
          ),
        ),
      ),
    );
  }
}

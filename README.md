# LCD LED
[![Pub](https://img.shields.io/pub/v/lcd_led.svg)](https://pub.dev/packages/lcd_led)

Emulates a 7 LEDs display (well, with colon and dot also!).

## Features
![Screenshot](https://github.com/alnitak/flutter_lcd_led/raw/master/images/leds.gif?raw=true "LCD LEDs Demo")

- display numbers, dots, colon, and minus chars
- customizable colors

## Usage

##### Case 1 (fixed overall size)
Give the `LedDigits` widget a fixed size.
If the `numberOfLeds` > `string`.length, the widget will align the digits to the right.

```dart
SizedBox(
    width: 500,
    height: 70,
    child: LedDigits(
        string: '-12.3:',
        numberOfLeds: 6,
        spacing: 5,
        backgroundColor: Colors.black, // default value
        onColor: Colors.red, // default value
        offColor: Color.fromARGB(255, 49, 49, 49), // default value
    ),
)
```

##### Case 2 (fixed height)
If you want a fixed height and a dynamic width, use something like the below code:

```dart
SizedBox(
    height: 70,
    child: AspectRatio(
        aspectRatio: n.length.toDouble()/1.5, // the LEDs width will be half the `SizedBox` height
        child: LedDigits(
        string: n,
        numberOfLeds: n.length,
    ),
)
```


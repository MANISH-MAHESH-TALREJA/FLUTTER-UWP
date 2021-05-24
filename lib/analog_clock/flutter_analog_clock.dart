library flutter_analog_clock;
import 'dart:async';

import 'flutter_analog_clock_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';

/// A analog clock.
class FlutterAnalogClock extends StatefulWidget {
  final DateTime dateTime;
  final Color dialPlateColor;
  final Color hourHandColor;
  final Color minuteHandColor;
  final Color secondHandColor;
  final Color numberColor;
  final Color borderColor;
  final Color tickColor;
  final Color centerPointColor;
  final bool showBorder;
  final bool showTicks;
  final bool showMinuteHand;
  final bool showSecondHand;
  final bool showNumber;
  final double borderWidth;
  final double hourNumberScale;
  final List<String> hourNumbers;
  final bool isLive;
  final double width;
  final double height;
  final BoxDecoration decoration;
  final Widget child;

  const FlutterAnalogClock(
      {required this.dateTime,
      this.dialPlateColor = Colors.white,
      this.hourHandColor = Colors.black,
      this.minuteHandColor = Colors.black,
      this.secondHandColor = Colors.black,
      this.numberColor = Colors.black,
      this.borderColor = Colors.black,
      this.tickColor = Colors.black,
      this.centerPointColor = Colors.black,
      this.showBorder = true,
      this.showTicks = true,
      this.showMinuteHand = true,
      this.showSecondHand = true,
      this.showNumber = true,
      required this.borderWidth,
      this.hourNumberScale = 1.0,
      this.hourNumbers = FlutterAnalogClockPainter.defaultHourNumbers,
      this.isLive = true,
      this.width = double.infinity,
      this.height = double.infinity,
      this.decoration = const BoxDecoration(),
      required this.child,
      required Key key})
      : super(key: key);
  const FlutterAnalogClock.dark(
      {required this.dateTime,
      this.dialPlateColor = Colors.black,
      this.hourHandColor = Colors.grey,
      this.minuteHandColor = Colors.grey,
      this.secondHandColor = Colors.grey,
      this.numberColor = Colors.grey,
      this.borderColor = Colors.black,
      this.tickColor = Colors.grey,
      this.centerPointColor = Colors.grey,
      this.showBorder = true,
      this.showTicks = true,
      this.showMinuteHand = true,
      this.showSecondHand = true,
      this.showNumber = true,
      required this.borderWidth,
      this.hourNumberScale = 1.0,
      this.hourNumbers = FlutterAnalogClockPainter.defaultHourNumbers,
      this.isLive = true,
      this.width = double.infinity,
      this.height = double.infinity,
      this.decoration = const BoxDecoration(),
      required this.child,
      required Key key})
      : super(key: key);

  @override
  _FlutterAnalogClockState createState() =>
      // ignore: no_logic_in_create_state
      _FlutterAnalogClockState(dateTime);
}

class _FlutterAnalogClockState extends State<FlutterAnalogClock> {
  DateTime _dateTime;
  Timer _timer = Timer(const Duration(), () {});
  _FlutterAnalogClockState(this._dateTime);

  @override
  void initState() {
    super.initState();
    // ignore: unnecessary_null_comparison
    if (!widget.isLive && _dateTime == null) {
      _dateTime = DateTime.now();
    }
    _timer = (widget.isLive
        ? Timer.periodic(const Duration(seconds: 1), (Timer timer) {
            _dateTime = _dateTime.add(const Duration(seconds: 1));
            if (mounted) {
              setState(() {});
            }
          })
        : null)!;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: widget.decoration,
      child: CustomPaint(
        child: widget.child,
        painter: FlutterAnalogClockPainter(
          _dateTime,
          dialPlateColor: widget.dialPlateColor,
          hourHandColor: widget.hourHandColor,
          minuteHandColor: widget.minuteHandColor,
          secondHandColor: widget.secondHandColor,
          numberColor: widget.numberColor,
          borderColor: widget.borderColor,
          tickColor: widget.tickColor,
          centerPointColor: widget.centerPointColor,
          showBorder: widget.showBorder,
          showTicks: widget.showTicks,
          showMinuteHand: widget.showMinuteHand,
          showSecondHand: widget.showSecondHand,
          showNumber: widget.showNumber,
          borderWidth: widget.borderWidth,
          hourNumberScale: widget.hourNumberScale,
          hourNumbers: widget.hourNumbers,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}

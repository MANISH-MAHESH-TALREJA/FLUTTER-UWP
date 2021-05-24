import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyPixel extends StatelessWidget
{
  var innerColor = Colors.white;
  var outerColor = Colors.white;
  var child = const Text('');

  // ignore: use_key_in_widget_constructors
  MyPixel({required this.innerColor, required this.outerColor, required this.child});

  @override
  Widget build(BuildContext context)
  {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
              child: Container(
                padding: const EdgeInsets.all(4.0),
          color: outerColor,
          child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
              child: Container(
                padding: const EdgeInsets.all(4.0),
          color: innerColor,
          child: Center(child: child),
        ),
      ),
        ),
      ),
    );
  }
}

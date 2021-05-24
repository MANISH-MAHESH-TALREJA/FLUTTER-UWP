import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyPath extends StatelessWidget
{
  var innerColor = Colors.white;
  var outerColor = Colors.white;
  var child = const Text('');

  // ignore: use_key_in_widget_constructors
  MyPath({required this.innerColor, required this.outerColor, required this.child});

  @override
  Widget build(BuildContext context)
  {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.02, vertical: MediaQuery.of(context).size.height*0.0125),
          color: outerColor,
          child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
              child: Container(
          color: innerColor,
          child: Center(child: child),
        ),
      ),
        ),
      ),
    );
  }
}

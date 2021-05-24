import 'package:flutter/material.dart';

class CustomText extends StatelessWidget
{
  final String _message;
  final Color color;
  final double fontSize;

  // ignore: use_key_in_widget_constructors
  const CustomText(this._message, {this.color = Colors.white, this.fontSize = 20.0});

  @override
  Widget build(BuildContext context)
  {
    return Text(
      _message,
      style: TextStyle(color: color, fontSize: fontSize),
    );
  }
}

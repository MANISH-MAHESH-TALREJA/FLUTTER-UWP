import 'package:flutter/material.dart';
import 'game.dart';

// ignore: use_key_in_widget_constructors
class MySnake extends StatelessWidget
{
  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      backgroundColor: Colors.brown[500],
      body: Game(),
    );
  }
}

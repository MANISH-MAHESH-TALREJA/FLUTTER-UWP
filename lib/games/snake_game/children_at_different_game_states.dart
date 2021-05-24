import 'package:flutter/material.dart';

final Widget gameStartChild = Container(
  width: 900,
  height: 500,
  padding: const EdgeInsets.all(32),
  child: const Center(
    child: Text(
      "Tap to start the Game!\nDo not Touch Walls:)",
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.blue,fontSize: 30),
    ),
  ),
);

final Widget gameRunningChild = Container(
  width: 47,
  height: 26,
  decoration: const BoxDecoration(
    color: Color(0xFFFF0000),
    shape: BoxShape.circle,
  ),
);

final Widget newSnakePointInGame = Container(
  width: 24,
  height: 24,
  decoration: const BoxDecoration(
    color: Color(0xFF0080FF),
    shape: BoxShape.circle,
  ),
);

//class which gives the snake HEAD
class Point {
  double xx = 0;
  double yy = 0;

  Point(double x, double y) {
    // ignore: prefer_initializing_formals
    xx = x;
    // ignore: prefer_initializing_formals
    yy = y;
  }
}

import 'package:flutter/material.dart';

// ignore: use_key_in_widget_constructors
class MyPlayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1.6),
      child: Image.asset(
        'assets/images/pacman/pacman0.png'
      ),
    );
  }
}
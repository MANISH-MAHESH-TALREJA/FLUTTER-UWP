import 'package:flutter/material.dart';
import 'package:games/home_page.dart';

void main()
{
  runApp(MaterialApp(
    home: HomePage(),
    debugShowCheckedModeBanner: false,
    title: "FLUTTER MINI GAMES",
    theme: ThemeData(
      primarySwatch: Colors.pink,
          fontFamily: 'Tahoma'
    ),
  ));
}
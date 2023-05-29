import 'package:flutter/material.dart';
import 'package:videocall2/screen/home_screen.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(fontFamily: 'NotoSans'),
      home: const HomeScreen(),
    ),
  );
}

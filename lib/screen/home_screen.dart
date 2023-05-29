import 'package:flutter/material.dart';
import 'package:videocall2/component/calendar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Calendar(),
          ],
        ),
      ),
    );
  }
}

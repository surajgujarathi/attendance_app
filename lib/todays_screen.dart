import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TodaysScreen extends StatefulWidget {
  const TodaysScreen({super.key});

  @override
  State<TodaysScreen> createState() => _TodaysScreenState();
}

class _TodaysScreenState extends State<TodaysScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('data'),
      ),
    );
  }
}

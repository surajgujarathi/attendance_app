import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:slide_to_act/slide_to_act.dart';

class TodaysScreen extends StatefulWidget {
  const TodaysScreen({super.key});

  @override
  State<TodaysScreen> createState() => _TodaysScreenState();
}

class _TodaysScreenState extends State<TodaysScreen> {
  double screenHeight = 0;
  double screenWidth = 0;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(top: 32),
            child: Text(
              'Welcome',
              style:
                  TextStyle(color: Colors.black54, fontSize: screenWidth / 20),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              'Employee',
              style: TextStyle(fontSize: screenWidth / 18),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(top: 32),
            child: Text(
              "Today's Status",
              style: TextStyle(fontSize: screenWidth / 18),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 32),
            height: 150,
            decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(2, 2),
                  ),
                ],
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Check in',
                      style: TextStyle(fontSize: screenWidth / 20),
                    ),
                    Text(
                      '09:30',
                      style: TextStyle(fontSize: screenWidth / 16),
                    )
                  ],
                )),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Check Out',
                      style: TextStyle(fontSize: screenWidth / 20),
                    ),
                    Text(
                      '--/--',
                      style: TextStyle(fontSize: screenWidth / 16),
                    )
                  ],
                ))
              ],
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: RichText(
              text: TextSpan(
                  text: '11',
                  style:
                      TextStyle(color: Colors.red, fontSize: screenWidth / 18),
                  children: [
                    TextSpan(
                        text: 'Jan 2024',
                        style: TextStyle(
                            fontSize: screenWidth / 18, color: Colors.black))
                  ]),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              '20:00:02',
              style:
                  TextStyle(fontSize: screenWidth / 20, color: Colors.black54),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 24),
            child: Builder(builder: (context) {
              final GlobalKey<SlideActionState> key = GlobalKey();
              return SlideAction(
                text: 'Slide to check out',
                textStyle: TextStyle(
                    color: Colors.black54, fontSize: screenWidth / 18),
                outerColor: Colors.white,
                innerColor: Colors.red,
                key: key,
                onSubmit: () {
                  key.currentState!.reset();
                },
              );
            }),
          )
        ],
      ),
    ));
  }
}

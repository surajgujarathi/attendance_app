import 'package:attendance_app/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:slide_to_act/slide_to_act.dart';

class TodaysScreen extends StatefulWidget {
  const TodaysScreen({super.key});

  @override
  State<TodaysScreen> createState() => _TodaysScreenState();
}

class _TodaysScreenState extends State<TodaysScreen> {
  final String currentDate = DateFormat('dd MMM yyyy').format(DateTime.now());
  double screenHeight = 0;
  double screenWidth = 0;

  String checkIn = "--/--";
  String checkout = "--/--";

  @override
  void initState() {
    super.initState();
    _getRecord();
  }

  Future<void> _getRecord() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('Employee')
          .where('id', isEqualTo: User.username)
          .get();

      if (snap.docs.isNotEmpty) {
        final employeeDocId = snap.docs[0].id;
        DocumentSnapshot recordSnap = await FirebaseFirestore.instance
            .collection('Employee')
            .doc(employeeDocId)
            .collection('Record')
            .doc(currentDate)
            .get();
        final data = recordSnap.data() as Map<String, dynamic>?;
        setState(() {
          checkIn = data?['checkIn'] ?? "--/--";
          checkout = data?['checkout'] ?? "--/--";
        });
      }
    } catch (e) {
      print("Error fetching record: $e");
      setState(() {
        checkIn = "--/--";
        checkout = "--/--";
      });
    }
    print('Check In: $checkIn');
    print('Check Out: $checkout');
  }

  Future<void> _handleSlideAction() async {
    final currentTime = DateFormat('hh:mm').format(DateTime.now());

    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('Employee')
          .where('id', isEqualTo: User.username)
          .get();

      if (snap.docs.isEmpty) {
        print("No employee found");
        return;
      }

      final employeeDocId = snap.docs[0].id;
      DocumentSnapshot recordSnap = await FirebaseFirestore.instance
          .collection('Employee')
          .doc(employeeDocId)
          .collection('Record')
          .doc(currentDate)
          .get();

      if (recordSnap.exists) {
        final data = recordSnap.data() as Map<String, dynamic>?;

        if (data != null) {
          if (data['checkIn'] != null) {
            await FirebaseFirestore.instance
                .collection('Employee')
                .doc(employeeDocId)
                .collection('Record')
                .doc(currentDate)
                .update({'checkout': currentTime});
            setState(() {
              checkout = currentTime;
            });
          } else {
            // If checkIn doesn't exist, set it
            await FirebaseFirestore.instance
                .collection('Employee')
                .doc(employeeDocId)
                .collection('Record')
                .doc(currentDate)
                .update({'checkIn': currentTime});
            setState(() {
              checkIn = currentTime;
            });
          }
        }
      } else {
        // Create the record if it doesn't exist
        await FirebaseFirestore.instance
            .collection('Employee')
            .doc(employeeDocId)
            .collection('Record')
            .doc(currentDate)
            .set({'checkIn': currentTime});
        setState(() {
          checkIn = currentTime;
        });
      }
    } catch (e) {
      print("Error during slide action: $e");
      // Consider showing a snackbar or dialog to inform the user
    }
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;

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
                style: TextStyle(
                    color: Colors.black54, fontSize: screenWidth / 20),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                'Employee ' + User.username,
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
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(2, 2),
                  ),
                ],
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
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
                          'Check In',
                          style: TextStyle(fontSize: screenWidth / 20),
                        ),
                        Text(
                          checkIn,
                          style: TextStyle(fontSize: screenWidth / 16),
                        ),
                      ],
                    ),
                  ),
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
                          checkout,
                          style: TextStyle(fontSize: screenWidth / 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(
                  text: DateFormat('dd MMM yyyy').format(DateTime.now()),
                  style: TextStyle(
                      color: Colors.black, fontSize: screenWidth / 18),
                  children: [
                    TextSpan(
                      text: '\n${DateFormat('EEEE').format(DateTime.now())}',
                      style: TextStyle(
                          color: Colors.red, fontSize: screenWidth / 18),
                    ),
                  ],
                ),
              ),
            ),
            StreamBuilder(
              stream: Stream.periodic(Duration(seconds: 1)),
              builder: (context, snapshot) => Text(
                DateFormat('hh:mm:ss a').format(DateTime.now()),
                style: TextStyle(
                    fontSize: screenWidth / 20, color: Colors.black54),
              ),
            ),
            checkout == "--/--"
                ? Container(
                    margin: EdgeInsets.only(top: 24),
                    child: Builder(
                      builder: (context) {
                        final GlobalKey<SlideActionState> key = GlobalKey();
                        return SlideAction(
                          text: checkIn == "--/--"
                              ? 'Slide to check in'
                              : 'Slide to check out',
                          textStyle: TextStyle(
                              color: Colors.black54,
                              fontSize: screenWidth / 18),
                          outerColor: Colors.white,
                          innerColor: Colors.red,
                          key: key,
                          onSubmit: _handleSlideAction,
                        );
                      },
                    ),
                  )
                : Container(
                    child: Text(
                      'You have completed this day!',
                      style: TextStyle(
                          fontSize: screenWidth / 20, color: Colors.black54),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

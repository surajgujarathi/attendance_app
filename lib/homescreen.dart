import 'package:attendance_app/calendar_screen.dart';
import 'package:attendance_app/model/user.dart';
import 'package:attendance_app/profile_screen.dart';
import 'package:attendance_app/services/location_services.dart';
import 'package:attendance_app/todays_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double screenHeight = 0;
  double screenWidth = 0;

  int currentIndex = 1;
  Color primary = const Color(0xffeef444c);
  //bottom navigation
  List<IconData> naviagationIcons = [
    Icons.calendar_month,
    Icons.check_box_sharp,
    Icons.person_2_sharp
  ];

  @override
  void initState() {
    super.initState();
    _startLocationService();
    getId();
  }

  void _startLocationService() async {
    LocationService().initialize();

    LocationService().getLongitude().then((value) {
      setState(() {
        User.lang = value!;
      });

      LocationService().getLatitude().then((value) {
        setState(() {
          User.lat = value!;
        });
      });
    });
  }

  void getId() async {
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection('Employee')
        .where('id', isEqualTo: User.employeeId)
        .get();
    setState(() {
      User.id = snap.docs[0].id;
    });
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: const [CalendarScreen(), TodaysScreen(), ProfileScreen()],
      ),
      backgroundColor: Colors.white,
      bottomNavigationBar: Container(
        height: 60,
        margin: const EdgeInsets.only(
          left: 12,
          right: 12,
          bottom: 12,
        ),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(40)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black26, blurRadius: 10, offset: Offset(2, 2)),
            ]),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(40)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < naviagationIcons.length; i++) ...<Expanded>{
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    setState(() {
                      currentIndex = i;
                    });
                  },
                  child: Container(
                    height: screenHeight,
                    width: screenWidth,
                    color: Colors.white,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            naviagationIcons[i],
                            color: i == currentIndex ? primary : Colors.black54,
                            size: i == currentIndex ? 30 : 26,
                          ),
                          i == currentIndex
                              ? Container(
                                  margin: const EdgeInsets.only(top: 3),
                                  height: 3,
                                  width: 22,
                                  decoration: BoxDecoration(
                                    color: primary,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ),
                  ),
                )),
              }
            ],
          ),
        ),
      ),
    );
  }
}

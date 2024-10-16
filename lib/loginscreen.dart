import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<LoginScreen> {
  TextEditingController idController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  double screenHeight = 0;
  double screenWidth = 0;
  Color primary = const Color(0xffeef444c);
  @override
  Widget build(BuildContext context) {
    final bool isKeybaordvisible =
        KeyboardVisibilityProvider.isKeyboardVisible(context);
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          isKeybaordvisible
              ? SizedBox(
                  height: screenHeight / 20,
                )
              : Container(
                  height: screenHeight / 2.9,
                  width: screenWidth,
                  decoration: BoxDecoration(
                    color: primary,
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(70),
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: screenWidth / 5,
                    ),
                  ),
                ),
          Container(
            margin: EdgeInsets.only(
                top: screenHeight / 15, bottom: screenHeight / 20),
            child: Text(
              'Login',
              style: TextStyle(fontSize: screenWidth / 18),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.symmetric(horizontal: screenWidth / 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                fieldTitle('Employee ID'),
                customField('Enter Your employee id', idController, false),
                fieldTitle('Password'),
                customField('Enter Your Password', passwordController, true),
                GestureDetector(
                  onTap: () async {
                    FocusScope.of(context).unfocus();
                    String id = idController.text.trim();
                    String password = passwordController.text.trim();

                    if (id.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Employee id is still empty')));
                      return; // Early return
                    }

                    if (password.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Password is still empty')));
                      return; // Early return
                    }

                    try {
                      QuerySnapshot snap = await FirebaseFirestore.instance
                          .collection("Employee")
                          .where('id', isEqualTo: id)
                          .get();

                      if (snap.docs.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Employee id does not exist')));
                        return; // Early return
                      }

                      String storedPassword = snap.docs[0]['password'];
                      if (password == storedPassword) {
                        print('Continue');
                        // Navigate to the next screen or perform the authenticated action
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Password is not correct')));
                      }
                    } catch (e) {
                      print(e.toString());
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Error occurred! Please try again.')));
                    }
                  },
                  child: Container(
                    height: 60,
                    width: screenWidth,
                    margin: EdgeInsets.only(top: screenHeight / 40),
                    decoration: BoxDecoration(
                        color: primary,
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: Center(
                      child: Text(
                        'Login',
                        style: TextStyle(
                            fontSize: screenWidth / 26,
                            color: Colors.white,
                            letterSpacing: 2),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget fieldTitle(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: TextStyle(fontSize: screenWidth / 26),
      ),
    );
  }

  Widget customField(
      String hint, TextEditingController controller, bool obscure) {
    return Container(
      margin: EdgeInsets.only(bottom: screenHeight / 50),
      width: screenWidth,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(2, 2))
        ],
      ),
      child: Row(
        children: [
          Container(
            width: screenWidth / 6,
            child: Icon(
              Icons.person,
              color: Colors.red,
              size: screenWidth / 15,
            ),
          ),
          Expanded(
              child: TextFormField(
            controller: controller,
            enableSuggestions: false,
            autocorrect: false,
            decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: screenHeight / 40),
                border: InputBorder.none,
                hintText: hint),
            obscureText: obscure,
          ))
        ],
      ),
    );
  }
}

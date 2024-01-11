import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:uas_app/pages/Display.dart';
import 'package:uas_app/pages/home_page.dart';
import 'package:uas_app/pages/profile_page.dart';

class ButtomNavBar extends StatefulWidget {
  const ButtomNavBar({super.key});

  @override
  State<ButtomNavBar> createState() => _ButtomNavBarState();
}

class _ButtomNavBarState extends State<ButtomNavBar> {
  int myCurrentIndex = 0;
  List pages = const [
    HomePage(),
    Display(),
    ProfilePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        buttonBackgroundColor: Color.fromRGBO(83, 33, 43, 1),
        color: Color.fromRGBO(83, 33, 43, 1),
        items: <Widget>[
          Icon(
            Icons.home,
            size: 30,
            color: Color.fromRGBO(255, 251, 245, 1),
          ),
          Icon(
            Icons.description,
            size: 30,
            color: Color.fromRGBO(255, 251, 245, 1),
          ),
          Icon(
            Icons.person,
            size: 30,
            color: Color.fromRGBO(255, 251, 245, 1),
          ),
        ],
        onTap: (index) {
          setState(() {
            myCurrentIndex = index;
          });
        },
      ),
      body: pages[myCurrentIndex],
    );
  }
}

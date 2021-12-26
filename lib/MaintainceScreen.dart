import 'CatogryHomePage.dart';
import 'ScreenTags.dart';
import 'package:connectivity/connectivity.dart';
import 'dart:core';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'events_page.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:badges/badges.dart';
import 'package:google_fonts/google_fonts.dart';



class MaintaincePage extends StatefulWidget {
  const MaintaincePage({Key? key}) : super(key: key);

  @override
  _MaintaincePage createState() {
    return _MaintaincePage();
  }
}

class _MaintaincePage extends State<MaintaincePage>{
  int selectedIndex = 5;
  int badge = 0;
  final padding = EdgeInsets.symmetric(horizontal: 18, vertical: 12);
  double gap = 10;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      body: Container(
        child: Column(
            children: <Widget>[
          Image.asset(
            'images/robot-repair-scientist-vector.jpg',
            fit: BoxFit.contain,
            // height: double.infinity,
            // width: double.infinity,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            alignment: Alignment.center,
            repeat: ImageRepeat.noRepeat,

          ),

        ]),
        decoration: BoxDecoration(
                color: GlobalStringText.backPurple),
      ),

      bottomNavigationBar: buildBottomNavigationBar(),
    );


  }


  Widget buildBottomNavigationBar() {
    return Material(
      color: Colors.transparent,
      elevation: 0,

      child: SafeArea(
        top: true,
        child: Container(

          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
            color: GlobalStringText.whiteColor,
            borderRadius: BorderRadius.all(Radius.circular(50)),
            boxShadow: [
              BoxShadow(
                spreadRadius: -10,
                blurRadius: 60,
                color: Colors.black.withOpacity(.4),
                offset: Offset(0, 25),
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 7),
            child: GNav(

              tabs: [
                GButton(
                  gap: gap,
                  iconActiveColor: Colors.pink,
                  iconColor: Colors.black,
                  textColor: Colors.pink,
                  backgroundColor: Colors.pink.withOpacity(.2),
                  iconSize: 24,
                  padding: padding,
                  icon: LineIcons.heart,
                  leading: selectedIndex == 1 || badge == 0
                      ? null
                      : Badge(
                    badgeColor: Colors.red.shade100,
                    elevation: 0,
                    position: BadgePosition.topEnd(top: -12, end: -12),
                    badgeContent: Text(
                      badge.toString(),
                      style: TextStyle(color: Colors.red.shade900),
                    ),
                    child: Icon(
                      LineIcons.heart,
                      color: selectedIndex == 1
                          ? Colors.pink
                          : Colors.black,
                    ),
                  ),
                  text: 'Favorite tickets',
                ),
                GButton(
                  gap: gap,
                  iconActiveColor: Colors.purple,
                  iconColor: Colors.black,
                  textColor: Colors.purple,
                  backgroundColor: Colors.purple.withOpacity(.2),
                  iconSize: 24,
                  padding: padding,
                  icon: LineIcons.home,
                  text: 'HomePage',
                ),
                GButton(
                  gap: gap,
                  iconActiveColor: Colors.amber[600],
                  iconColor: Colors.black,
                  textColor: Colors.amber[600],
                  backgroundColor: Colors.amber[600]!.withOpacity(.2),
                  iconSize: 24,
                  padding: padding,
                  icon: LineIcons.inbox,
                  text: 'Inbox',
                ),

              ],
              selectedIndex: selectedIndex,
              onTabChange: (index) {
                setState(() {
                  switch(index)
                  {
                  // just update the navigator i putted random navigation for the purpose of testing...
                  // waiting for yousef to do the pages
                    case 0 :
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const EventsPage(
                              category: GlobalStringText.tagEntertainment)));
                      break;
                    case 1 :
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => CategoryPageScreen()));
                      break;

                    case 2 :
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const EventsPage(
                              category: GlobalStringText.tagCarPool
                          )));
                      break;
                  }


                });

              },
            ),
          ),
        ),
      ),);
  }
}

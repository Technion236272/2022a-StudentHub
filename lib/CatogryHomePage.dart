import 'package:firebase_core/firebase_core.dart';

import 'ScreenTags.dart';
import 'package:connectivity/connectivity.dart';
import 'dart:core';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'chat_backend.dart';
import 'events_page.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:badges/badges.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studenthub/MaintainceScreen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'FavoritesPage.dart';

import 'package:studenthub/Auth.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'events_page.dart';
import 'openedTicketsPage.dart';
import 'inboxScreen.dart';
import 'profilePage.dart';

class CategoryPageScreen extends StatefulWidget {
  const CategoryPageScreen({Key? key}) : super(key: key);

  @override
  _CategoryPageScreen createState() {
    return _CategoryPageScreen();
  }
}

class _CategoryPageScreen extends State<CategoryPageScreen> {
  ///////////////////////////PARAMS//////////////////////////
  final GlobalKey<FormState> _key = GlobalKey();
  int selectedIndex = 1;
  int badge = 0;
  final padding = EdgeInsets.symmetric(horizontal: 18, vertical: 12);
  double gap = 10;
  String action = "Home";
  Timestamp? currentBackPressTime;

  @override
  void initState() {
    super.initState();
    Chat.init(context);
  }

  ////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final user = Provider.of<AuthRepository>(context);
    return WillPopScope(
        child: Container(
          child: Scaffold(
            extendBody: true,
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.transparent,
            body: Column(
              children: [
                Container(
                    decoration: const BoxDecoration(
                      // spice up the button with a radius
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    height: 135,
                    // we need to agree on one height for all screens eventually
                    padding: const EdgeInsets.fromLTRB(20, 30, 0, 0),
                    child: Column(
                      children: [
                        Align(
                          child: Row(
                            children: [
                              Text("Hi " + (user.getName() ?? ""),
                                  style: GoogleFonts.quicksand(
                                    textStyle: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      fontFamily:
                                          GlobalStringText.QuickSandFont,
                                      color:
                                          GlobalStringText.WhiteColorHiMessage,
                                    ),
                                  )),
                              IconButton(
                                onPressed: () async {
                                  await user.signOut();
                                  Navigator.pushNamedAndRemoveUntil(
                                      context, '/Auth', (route) => false);
                                },
                                icon: Image.asset("images/logout.png"),
                                iconSize: 40,
                              ),
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          ),
                          alignment: Alignment.centerLeft, //this ok??
                        ),
                        Align(
                          child: Row(
                            children: [
                              Text("Welcome Back!  ",
                                  style: GoogleFonts.quicksand(
                                    textStyle: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      fontFamily:
                                          GlobalStringText.QuickSandFont,
                                      color:
                                          GlobalStringText.WhiteColorHiMessage,
                                    ),
                                  )),
                              Tab(
                                  icon: Image.asset(
                                      GlobalStringText.ImageWavingTest)),
                              //Image.asset(GlobalStringText.ImageWaving,fit : BoxFit.scaleDown ),
                              //waving hand here
                            ],
                          ),
                          alignment: Alignment.centerLeft, //this ok??
                        )
                      ],
                    )),
                Expanded(
                  child: Container(
                      decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 5,
                            )
                          ],
                          color: GlobalStringText.WhiteScreen,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20))),
                      padding: const EdgeInsets.only(
                          left: 21.0, right: 21.0, bottom: 0.0, top: 0.0),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                                margin: const EdgeInsets.only(top: 0.0),
                                child: Column(children: [
                                  Align(
                                    alignment: Alignment.topCenter,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        GestureDetector(
                                            child: Container(
                                                width: 100,
                                                height: 100,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(20)),
                                                  color: Colors.transparent,
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          GlobalStringText
                                                              .ImagesTickets),
                                                      fit: BoxFit.scaleDown),
                                                )),
                                            onTap: () {
                                              Navigator.of(context)
                                                  .pushNamed('/Home/Opened');
                                            }),
                                        Container(
                                            width: 120,
                                            height: 120,
                                            decoration: BoxDecoration(
                                              borderRadius: const BorderRadius.all(
                                                  Radius.circular(20)),
                                              color: Colors.transparent,
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      GlobalStringText
                                                          .ImagesServices),
                                                  fit: BoxFit.scaleDown),
                                            )),
                                        GestureDetector(
                                            child: Container(
                                                width: 100,
                                                height: 100,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(20)),
                                                  color: Colors.transparent,
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          GlobalStringText
                                                              .ImagesProfile),
                                                      fit: BoxFit.scaleDown),
                                                )),
                                            onTap: () {
                                              Navigator.of(context).pushNamed(
                                                  '/Home/Profile',
                                                  arguments: user.user!.uid);
                                            }),
                                      ],
                                    ),
                                  )
                                ])),
                            CategoryFields(),
                          ],
                        ),
                      )),
                ),
              ],
            ),
            //bottomNavigationBar: ,
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            floatingActionButton: buildBottomNavigationBar() ,
          ),
          decoration: BoxDecoration(
            // spice up the button with a radius
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
            gradient: LinearGradient(
                // gradient starts from left
                begin: Alignment.centerLeft,
                // gradient ends at right
                end: Alignment.centerRight,
                // set all your colors
                colors: [
                  GlobalStringText.FifthpurpleColor,
                  GlobalStringText.ForthpurpleColor,
                  GlobalStringText.ThirdpurpleColor,
                  GlobalStringText.SecondpurpleColor,
                  GlobalStringText.FirstpurpleColor,
                  Color.fromRGBO(143, 148, 251, 1),
                ]),
          ),
        ),
        onWillPop: () async {
          Timestamp now = Timestamp.now();
          if (currentBackPressTime == null ||
              now.toDate().difference(currentBackPressTime!.toDate()) >
                  Duration(seconds: 2)) {
            currentBackPressTime = now;
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('Press again to exit')));
            return Future.value(false);
          }
          return Future.value(true);
        });
  }

  Widget buildBottomNavigationBar() {
    return SafeArea(
      top: true,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
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
                switch (index) {
                  case 0:
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/Home/Favorites', (route) => route.isFirst);
                    break;
                  case 2:
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/Home/Inbox', (route) => route.isFirst);
                    break;
                }
              });
            },
          ),
        ),
      ),
    );
  }

  Widget CategoryFields() {
    return Center(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(width: 6),
            GestureDetector(
                child: Container(
                    child: Card(
                      elevation: 0,
                      color: Colors.transparent,
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                child: Image.asset(
                                  'images/icons8-comedy-64.png',
                                  fit: BoxFit.fill,
                                )),
                          ),
                          Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                              child: Text(
                                'Entertainment',
                                style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                      fontSize: 18,
                                      color: GlobalStringText.purpleColor,
                                      fontWeight: FontWeight.w500),
                                ),
                              )),
                        ],
                      ),
                    ),
                    width: MediaQuery.of(context).size.width * 0.41,
                    height: MediaQuery.of(context).size.height * 0.185,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: GlobalStringText.DeepPinkColorFirst,
                    )),
                onTap: () {
                  Navigator.of(context).pushNamed('/Home/Entertainment');
                }),
            SizedBox(width: 20),
            GestureDetector(
                child: Container(
                    child: Card(
                      elevation: 0,
                      color: Colors.transparent,
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                                padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
                                child: Image.asset(
                                  GlobalStringText.ImagesTravelCat,
                                  fit: BoxFit.fill,
                                )),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                            child: Text(
                              'CarPool',
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                    fontSize: 18,
                                    color: GlobalStringText.purpleColor,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    width: MediaQuery.of(context).size.width * 0.41,
                    height: MediaQuery.of(context).size.height * 0.185,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: GlobalStringText.LightYellowColorFirst,
                    )),
                onTap: () {
                  Navigator.of(context).pushNamed('/Home/CarPool');
                  ;
                }),
          ],
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(width: 6),
            GestureDetector(
                child: Container(
                    child: Card(
                      elevation: 0,
                      color: Colors.transparent,
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                child: Image.asset(
                                  GlobalStringText.ImagesFoodCat,
                                  fit: BoxFit.fill,
                                )),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                            child: Text(
                              'Food',
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                    fontSize: 18,
                                    color: GlobalStringText.purpleColor,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    width: MediaQuery.of(context).size.width * 0.41,
                    height: MediaQuery.of(context).size.height * 0.185,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: GlobalStringText.LightBlueColorFirst,
                    )),
                onTap: () {
                  Navigator.of(context).pushNamed('/Home/Food');
                }),
            SizedBox(width: 20),
            GestureDetector(
                child: Container(
                    child: Card(
                      elevation: 0,
                      color: Colors.transparent,
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                                padding: EdgeInsets.fromLTRB(0, 13, 0, 0),
                                child: Image.asset(
                                  GlobalStringText.ImagesAcadSupportCat,
                                  fit: BoxFit.scaleDown,
                                )),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                            child: Text(
                              'Academic Support',
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                    fontSize: 14,
                                    color: GlobalStringText.purpleColor,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    width: MediaQuery.of(context).size.width * 0.41,
                    height: MediaQuery.of(context).size.height * 0.185,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: GlobalStringText.LightGreenColorFirst,
                    )),
                onTap: () {
                  Navigator.of(context).pushNamed('/Home/AcademicSupport');
                }),
          ],
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(width: 6),
            GestureDetector(
                child: Container(
                    child: Card(
                      elevation: 0,
                      color: Colors.transparent,
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                child: Image.asset(
                                  GlobalStringText.ImagesStudyBudCat,
                                  fit: BoxFit.fill,
                                )),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                            child: Text(
                              'Study Buddy',
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                    fontSize: 18,
                                    color: GlobalStringText.purpleColor,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    width: MediaQuery.of(context).size.width * 0.41,
                    height: MediaQuery.of(context).size.height * 0.185,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: GlobalStringText.LightOarngeColorFirst,
                    )),
                onTap: () {
                  Navigator.of(context).pushNamed('/Home/StudyBuddy');
                }),
            SizedBox(width: 20),
            GestureDetector(
                child: Container(
                    child: Card(
                      elevation: 0,
                      color: Colors.transparent,
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                child: Image.asset(
                                  GlobalStringText.ImagesMaterialCat,
                                  fit: BoxFit.fill,
                                )),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                            child: Text(
                              'Material',
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                    fontSize: 18,
                                    color: GlobalStringText.purpleColor,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    width: MediaQuery.of(context).size.width * 0.41,
                    height: MediaQuery.of(context).size.height * 0.185,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: GlobalStringText.LightRedColorFirst,
                    )),
                onTap: () {
                  Navigator.of(context).pushNamed('/Home/Material');
                }),
          ],
        )
      ],
    ));
  }
}

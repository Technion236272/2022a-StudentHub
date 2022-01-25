import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:studenthub/main.dart';
import 'ScreenTags.dart';
import 'package:studenthub/Auth.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'inboxScreen.dart';
import 'package:studenthub/CatogryHomePage.dart';

class profilePage extends StatefulWidget {
  final String userID;
  const profilePage({Key? key, required this.userID}) : super(key: key);

  @override
  _profilePage createState() => _profilePage();
}

class _profilePage extends State<profilePage> {
  double gap = 10;
  int selectedIndex = 0;
  int badge = 0;
  final padding = EdgeInsets.symmetric(horizontal: 18, vertical: 12);



  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final user = Provider.of<AuthRepository>(context);

    return Scaffold(

      body: FutureBuilder(future: getProfileInfo(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
    switch (snapshot.connectionState) {
    case ConnectionState.waiting:
    {
    return const Center(child: Text("Loading"));
    }
    default:
    {
    if (snapshot.hasError) {
    return Center(child: Text("Error ${snapshot.error}"));
    } else {
      var userInfo  = snapshot.data;
    return Column(

      children: <Widget>[
        SafeArea(
            child: Container(

              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.11,
              color: Color(0xFF8C88F9),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      IconButton(
                          onPressed: () {
                            Navigator.of(context).pushNamedAndRemoveUntil('/Home', (route) => route.isFirst);
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          )),
                      new Spacer(),
                      IconButton(
                        onPressed: () async {
                          await user.signOut();
                          Navigator.pushNamedAndRemoveUntil(context, '/Auth', (route) => false);
                        },
                        icon: Image.asset("images/logout.png"),
                        iconSize: 40,
                      )
                    ],
                  ),
                ],
              ),
            )),
        Flexible(
          child: Container(
            height: MediaQuery
                .of(context)
                .size
                .height * 0.9,
            width: MediaQuery
                .of(context)
                .size
                .width,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20.0),
                  topLeft: Radius.circular(20.0)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Color(0xFF8C88F9),
                    spreadRadius: 12,
                    blurRadius: 10)
              ],
            ),
            child: Container(
              child: Column(
                children: <Widget>[
                  Padding(padding: EdgeInsets.all(10)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        "images/icons8-administrator-male-96.png",
                        height: 100,
                        width: 100,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      Text(
                        "Profile",
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat',
                            color: Color(0xFF6769EC)),
                      )
                    ],
                  ),
                  SizedBox(height: 30,), // profile
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const <Widget>[
                      Text(
                        "Name",
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat',
                            color: Color(0xFF6769EC)),
                      )
                    ],
                  ), // name
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children:  <Widget>[
                      Text(
                          (userInfo as profileInfo).name,
                          style: GoogleFonts.poppins(textStyle: const TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.normal,
                              color: Colors.black),)
                      )
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const <Widget>[
                      Text(
                        "Faculty",
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat',
                            color: Color(0xFF6769EC)),
                      )
                    ],
                  ), // faculty
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children:  <Widget>[
                      Text(
                          (userInfo as profileInfo).faculty,
                          style: GoogleFonts.poppins(textStyle: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.normal,
                              color: Colors.black),)
                      )
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const <Widget>[
                      Text(
                        "Phone Number",
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat',
                            color: Color(0xFF6769EC)),
                      )
                    ],
                  ), // PN
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children:  <Widget>[
                      Text(
                          (userInfo as profileInfo).phoneNumber,
                          style: GoogleFonts.poppins(textStyle: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.normal,
                              color: Colors.black),)
                      )
                    ],
                  ),
                  SizedBox(height: 10,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const <Widget>[
                      Text(
                        "Gender",
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat',
                            color: Color(0xFF6769EC)),
                      )
                    ],
                  ), // gender
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children:  <Widget>[
                      Text(
                          (userInfo as profileInfo).gender,
                          style: GoogleFonts.poppins(textStyle: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.normal,
                              color: Colors.black),)
                      )
                    ],
                  ),


                ],
              ),
              margin: EdgeInsets.only(left: 15, right: 15),
            ),
          ),
        )
      ],
    );
    }
    }
    }
    },)


    );
  }

  Future<profileInfo> getProfileInfo() async {
    var userInfo ;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final User? user = Provider.of<AuthRepository>(context, listen: false).user;

          await _firestore.collection("users").doc("${widget.userID}").get().then((DocumentSnapshot userData) {


               userInfo = profileInfo(
                userData.get('Faculty'),
                userData.get('Full Name'),
                userData.get('Gender'),
                userData.get('Phone Number'),

              );
          });

          return userInfo;

  }




}
class profileInfo  {
  final String faculty;
  final String name;
  final String gender;
  final String phoneNumber;



  profileInfo( this.faculty,  this.name, this.gender,  this.phoneNumber );

}
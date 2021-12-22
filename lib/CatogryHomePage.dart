import 'ScreenTags.dart';
import 'package:connectivity/connectivity.dart';
import 'dart:core';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class CategoryPageScreen extends StatefulWidget {
  static String tag = GlobalStringText.tagNewPostScreen;

  const CategoryPageScreen({Key? key}) : super(key: key);

  @override
  _CategoryPageScreen createState() {
    return _CategoryPageScreen();
  }
}

class _CategoryPageScreen extends State<CategoryPageScreen> {
  ///////////////////////////PARAMS//////////////////////////
  final GlobalKey<FormState> _key = GlobalKey();

  ////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
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
                height: 160, // we need to agree on one height for all screens eventually
                padding: const EdgeInsets.fromLTRB(30, 50,0, 0),
                child: Column(
                  children: [
                    Align(
                      child: Text("Hi Yair", style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        fontFamily: GlobalStringText.QuickSandFont,
                        color: GlobalStringText.WhiteColorHiMessage,
                      ),),
                      alignment: Alignment.centerLeft,//this ok??
                    ),
                    Align(
                      child: Row(
                        children: [
                          Text("Welcome Back!", style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              fontFamily: GlobalStringText.QuickSandFont,
                              color: GlobalStringText.WhiteColorHiMessage,
                          ),),
                          Tab(icon: new Image.asset(GlobalStringText.ImageWavingTest)),
                           //Image.asset(GlobalStringText.ImageWaving,fit : BoxFit.scaleDown ),
                          //waving hand here
                        ],
                      ),
                      alignment: Alignment.centerLeft,//this ok??
                    )
                  ],
                )
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: GlobalStringText.WhiteScreen,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  padding: const EdgeInsets.only(left: 21.0 , right: 21.0 , bottom: 0.0 , top : 0.0),

                  child: Center(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [

                         Container(margin:const EdgeInsets.only(top: 0.0),
                             child : Column(
                             children: [Align(
                               alignment: Alignment.topCenter,
                               child: Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: <Widget>[

                                   GestureDetector(
                                       child: Container(
                                           width: 100,
                                           height: 100,
                                           decoration: BoxDecoration(
                                             borderRadius: BorderRadius.all(Radius.circular(20)),
                                             color: Colors.transparent,
                                             image: DecorationImage(
                                                 image: AssetImage(
                                                     GlobalStringText.ImagesTickets),
                                                 fit: BoxFit.scaleDown),
                                           )),
                                       onTap: () {
                                         null;
                                       }),

                                   GestureDetector(
                                       child: Container(
                                           width: 120,
                                           height: 120,
                                           decoration: BoxDecoration(
                                             borderRadius: BorderRadius.all(Radius.circular(20)),
                                             color: Colors.transparent,
                                             image: DecorationImage(
                                                 image:
                                                 AssetImage(GlobalStringText.ImagesServices),
                                                 fit: BoxFit.scaleDown),
                                           )),
                                       onTap: () {
                                         null;
                                       }),
                                   GestureDetector(
                                       child: Container(
                                           width: 100,
                                           height: 100,
                                           decoration: BoxDecoration(
                                             borderRadius: BorderRadius.all(Radius.circular(20)),
                                             color: Colors.transparent,
                                             image: DecorationImage(
                                                 image:
                                                 AssetImage(GlobalStringText.ImagesProfile),
                                                 fit: BoxFit.scaleDown),
                                           )),
                                       onTap: () {
                                         null;
                                       }),
                                 ],
                               ),
                             )]
                         )),
                          CategoryFields(),
                        ],
                      ),
                  )
                ),
              )
            ],
          ),

      ),
      decoration: BoxDecoration(
        // spice up the button with a radius
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
        gradient: LinearGradient(
            // gradient starts from left
            begin: Alignment.bottomLeft,
            // gradient ends at right
            end: Alignment.topRight,
            // set all your colors
            colors: [
              GlobalStringText.FifthpurpleColor,
              GlobalStringText.ForthpurpleColor,
              GlobalStringText.ThirdpurpleColor,
              GlobalStringText.SecondpurpleColor,
              GlobalStringText.FirstpurpleColor,
            ]),
      ),
    );
  }

  Widget CategoryFields() {
    return Center(child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [



          Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                    child: Container(
                        width: 160,
                        height: 141,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: GlobalStringText.DeepPinkColorFirst,
                          image: DecorationImage(
                              image: AssetImage(
                                  GlobalStringText.ImagesEnertiamentCat),
                              fit: BoxFit.scaleDown),
                        )),
                    onTap: () {
                      null;
                    }),
                SizedBox(width: 20),
                GestureDetector(
                    child: Container(
                        width: 160,
                        height: 141,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: GlobalStringText.LightYellowColorFirst,
                          image: DecorationImage(
                              image:
                                  AssetImage(GlobalStringText.ImagesTravelCat),
                              fit: BoxFit.scaleDown),
                        )),
                    onTap: () {
                      null;
                    }),
              ],
            ),
          Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                    child: Container(
                        width: 160,
                        height: 141,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: GlobalStringText.LightBlueColorFirst,
                          image: DecorationImage(
                              image: AssetImage(GlobalStringText.ImagesFoodCat),
                              fit: BoxFit.scaleDown),
                        )),
                    onTap: () {
                      null;
                    }),
                SizedBox(width: 20),
                GestureDetector(
                    child: Container(
                        width: 160,
                        height: 141,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: GlobalStringText.LightGreenColorFirst,
                          image: DecorationImage(
                              image: AssetImage(
                                  GlobalStringText.ImagesAcadSupportCat),
                              fit: BoxFit.scaleDown),
                        )),
                    onTap: () {
                      null;
                    }),
              ],
            ),
          Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                    child: Container(
                        width: 160,
                        height: 141,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: GlobalStringText.LightOarngeColorFirst,
                          image: DecorationImage(
                              image: AssetImage(
                                  GlobalStringText.ImagesStudyBudCat),
                              fit: BoxFit.scaleDown),
                        )),
                    onTap: () {
                      null;
                    }),
                SizedBox(width: 20),
                GestureDetector(
                    child: Container(
                        width: 160,
                        height: 141,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: GlobalStringText.LightRedColorFirst,
                          image: DecorationImage(
                              image: AssetImage(
                                  GlobalStringText.ImagesMaterialCat),
                              fit: BoxFit.scaleDown),
                        )),
                    onTap: () {
                      null;
                    }),
              ],
            ),
        ],
      ));
  }
}

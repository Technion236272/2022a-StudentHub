import 'ScreenTags.dart';
import 'package:connectivity/connectivity.dart';
import 'dart:core';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

//---------------------------------------CLASSES--------------------------------------------------//
class Food {
  late int id;
  late String name;

  Food(this.id, this.name);

  static List<Food> getFoodTypes() {
    return <Food>[
      Food(
        1,
        'Select Food type',
      ),
      Food(2, 'Meat'),
      Food(3, 'Vegan'),
      Food(4, 'SeaFood'),
      Food(5, 'Pizza'),
      Food(6, 'FastFood'),
      Food(7, 'Other'),
    ];
  }
}

class Event {
  late int id;
  late String name;

  Event(this.id, this.name);

  static List<Event> getEventTypes() {
    return <Event>[
      Event(
        1,
        'Select Event Type',
      ),
      Event(2, 'Party'),
      Event(3, 'Sport'),
      Event(4, 'BoardGames'),
      Event(5, 'Chilling'),
      Event(6, 'Other'),
    ];
  }
}
//-----------------------------------------------------------------------------------------//

//-----------------------------------------------------------------------------------------//
class NewPostScreen extends StatefulWidget {
  static String tag = GlobalStringText.tagNewPostScreen;

  NewPostScreen({Key? key}) : super(key: key);

  @override
  _NewPostScreenState createState() {
    return _NewPostScreenState();
  }
}

class _NewPostScreenState extends State<NewPostScreen> {
  String ReciveTitle = '';

  //var ReciveUserID="";

  TextEditingController TitleController = TextEditingController();
  TextEditingController LocationController = TextEditingController();
  TextEditingController TimeController = TextEditingController();
  TextEditingController DescriptionController = TextEditingController();
  TextEditingController EventTypeController = TextEditingController();
  TextEditingController FoodTypeController = TextEditingController();
  TextEditingController CourseNumberController = TextEditingController();

  final FocusNode myFocusNodeTitle = FocusNode();
  final FocusNode myFocusNodeDescription = FocusNode();
  final FocusNode myFocusNodeTime = FocusNode();
  final FocusNode myFocusNodeEvent = FocusNode();
  final FocusNode myFocusNodeFood = FocusNode();
  final FocusNode myFocusNodeCourse = FocusNode();
  final FocusNode myFocusNodeLocation = FocusNode();

  final ScrollController _scrollController = ScrollController();
  final GlobalKey<FormState> _key = GlobalKey();
  final bool _validate = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late String Title, Description, Time, EvenType, Location, FoodType;

  final List<Food> _food = Food.getFoodTypes();
  late List<DropdownMenuItem<Food>> _dropdownFoodMenuItems;
  late Food _selectedFood;

  final List<Event> _events = Event.getEventTypes();
  late List<DropdownMenuItem<Event>> _dropdownEventsMenuItems;
  late Event _selectedEvent;

  //User selectedUser

//----------------------------------------------------------------------------------------------//
  List<DropdownMenuItem<Food>> buildDropdownMenuItems(List foods) {
    List<DropdownMenuItem<Food>> items = List.empty(growable: true);
    for (Food food in foods) {
      items.add(
        DropdownMenuItem(
          value: food,
          child: Text(
            food.name,
            style: TextStyle(
                fontSize: 14.0,
                color: GlobalStringText.textFieldGrayColor,
                fontFamily: GlobalStringText.FontTextFormField,
                fontWeight: FontWeight.w300),
          ),
        ),
      );
    }
    return items;
  }

//----------------------------------------------------------------------------------------------//
  List<DropdownMenuItem<Event>> buildDropdownMenuItems1(List events) {
    List<DropdownMenuItem<Event>> items = List.empty(growable: true);
    for (Event event in events) {
      items.add(
        DropdownMenuItem(
          value: event,
          child: Text(
            event.name,
            style: TextStyle(
              fontSize: 14.0,
              color: GlobalStringText.textFieldGrayColor,
              fontFamily: GlobalStringText.FontTextFormField,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      );
    }
    return items;
  }

//----------------------------------------------------------------------------------------------//

  @override
  void initState() {
    // this._checkInternetConnectivity(context);
    // this.ReciveUserdetails();
    _dropdownFoodMenuItems = buildDropdownMenuItems(_food);
    _selectedFood = _dropdownFoodMenuItems[0].value!;
    _dropdownEventsMenuItems = buildDropdownMenuItems1(_events);
    _selectedEvent = _dropdownEventsMenuItems[0].value!;
    super.initState();
  }

  void onChangeDropdownItem(Food? selectedFood) {
    setState(() {
      _selectedFood = selectedFood!;
    });
  }

//----------------------------------------------------------------------------------------------//
  void onChangeDropdownItem1(Event? selectedEvent) {
    setState(() {
      _selectedEvent = selectedEvent!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        resizeToAvoidBottomInset: false,
        backgroundColor: GlobalStringText.FifthpurpleColor,
        body: Column(
          children: [
            Container(
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
                    ]),
              ),
              height: 110 ,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: GlobalStringText.whiteColor,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                padding: const EdgeInsets.all(16.0),
                child: Form(
                    key: _key,
                    child: ListView(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: TicketFields(),
                        )
                      ],
                    )),
              ),
            )
          ],
        ));
  }

  List<Widget> TicketFields() {
    return <Widget>[
//------------------------------------------------------------------------------------------------------------//
      Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
        child: Column(
          children: [
            Align(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Image.asset(GlobalStringText.ImagesAddTicket),
                ],
              ),
              alignment: Alignment.centerRight,
            ),
            Align(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Image.asset(GlobalStringText.ImagesTitle),
                ],
              ),
              alignment: Alignment.centerLeft,
            ),
            const SizedBox(height: 5.0),
            TextFormField(
              focusNode: myFocusNodeTitle,
              controller: TitleController,
              decoration: InputDecoration(
                filled: true,
                fillColor: GlobalStringText.textFieldColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    width: 0,
                    style: BorderStyle.solid,
                  ),
                ),
                labelText: 'Pick what ever title you want',
                labelStyle: TextStyle(
                    fontSize: 14.0,
                    color: GlobalStringText.textFieldGrayColor,
                    fontFamily: GlobalStringText.FontTextFormField,
                    fontWeight: FontWeight.w300),
                prefixText: ' ',
              ),
            ),
          ],
        ),
      ),
//------------------------------------------------------------------------------------------------------------//
      Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Image.asset(GlobalStringText.ImagesLocation),
          ],
        ),
        alignment: Alignment.centerLeft,
      ),
      const SizedBox(height: 5.0),
      TextFormField(
        focusNode: myFocusNodeLocation,
        controller: LocationController,
        decoration: InputDecoration(
          filled: true,
          fillColor: GlobalStringText.textFieldPinkColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              width: 0,
              style: BorderStyle.solid,
            ),
          ),
          hintText: 'Example : Haifa , Technion 28 ',
          hintStyle: TextStyle(
              fontSize: 12.0, color: GlobalStringText.textFieldGrayColor),
          //helperText: 'Keep it short, this is just a demo.',
          labelText: 'Pick city and street number',
          labelStyle: TextStyle(
              fontSize: 14.0,
              color: GlobalStringText.textFieldGrayColor,
              fontFamily: GlobalStringText.FontTextFormField,
              fontWeight: FontWeight.w300),

          prefixText: ' ',
          //suffixStyle: const TextStyle(color: Colors.green)
        ),
      ),

      ///////////////------------------------------------------------------------------/////////////////
      Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Image.asset(GlobalStringText.ImagesTime),
          ],
        ),
        alignment: Alignment.centerLeft,
      ),
      const SizedBox(height: 5.0),
      TextFormField(
        focusNode: myFocusNodeTime,
        controller: TimeController,
        decoration: InputDecoration(
          filled: true,
          fillColor: GlobalStringText.textFieldColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              width: 0,
              style: BorderStyle.solid,
            ),
          ),
          hintText: 'Example 28.12 , 14:00 ',
          hintStyle: TextStyle(
              fontSize: 12.0, color: GlobalStringText.textFieldGrayColor),
          //helperText: 'Keep it short, this is just a demo.',
          labelText: 'Pick a date and an hour',
          labelStyle: TextStyle(
              fontSize: 14.0,
              color: GlobalStringText.textFieldGrayColor,
              fontFamily: GlobalStringText.FontTextFormField,
              fontWeight: FontWeight.w300),

          prefixText: ' ',
          //suffixStyle: const TextStyle(color: Colors.green)
        ),
      ),

      const SizedBox(height: 5.0),
      Visibility(
          visible: false,
          child: Column(
            children: [
              Align(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Image.asset(GlobalStringText.ImagesCourseNum),
                  ],
                ),
                alignment: Alignment.centerLeft,
              ),
              const SizedBox(height: 5.0),
              TextFormField(
                focusNode: myFocusNodeCourse,
                controller: CourseNumberController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: GlobalStringText.textFieldColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      width: 0,
                      style: BorderStyle.solid,
                    ),
                  ),
                  hintText: 'example 234218',
                  hintStyle: TextStyle(
                      fontSize: 12.0,
                      fontFamily: GlobalStringText.FontTextFormField,
                      color: GlobalStringText.textFieldGrayColor),
                  //helperText: 'Keep it short, this is just a demo.',
                  labelText: 'Choose Course Number',
                  labelStyle: TextStyle(
                      fontSize: 14.0,
                      color: GlobalStringText.textFieldGrayColor,
                      fontFamily: GlobalStringText.FontTextFormField,
                      fontWeight: FontWeight.w300),

                  prefixText: ' ',
                  //suffixStyle: const TextStyle(color: Colors.green)
                ),
              ),
            ],
          )),

      Visibility(
          visible: true,
          child: Column(
            children: [
              Align(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Image.asset(GlobalStringText.ImagesFood),
                  ],
                ),
                alignment: Alignment.centerLeft,
              ),
              const SizedBox(height: 5.0),
              Container(
                decoration: BoxDecoration(
                    color: GlobalStringText.textFieldDeepPinkColor,
                    borderRadius: BorderRadius.circular(8.0)),
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            DropdownButton(
                              borderRadius: BorderRadius.circular(8.0),
                              dropdownColor:
                              GlobalStringText.textFieldDeepPinkColor,
                              isExpanded: true,
                              icon: const Icon(Icons.arrow_drop_down),
                              iconSize: 40,
                              underline: const SizedBox(),
                              value: _selectedFood,
                              items: _dropdownFoodMenuItems,
                              onChanged: onChangeDropdownItem,
                            ),
                          ]),
                    )
                  ],
                ),
              ),
            ],
          )),

      Visibility(
          visible: false,
          child: Column(
            children: [
              Align(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Image.asset(GlobalStringText.ImagesEvent),
                  ],
                ),
                alignment: Alignment.centerLeft,
              ),
              const SizedBox(height: 5.0),
              Container(
                decoration: BoxDecoration(
                    color: GlobalStringText.textFieldDeepPinkColor,
                    borderRadius: BorderRadius.circular(8.0)),
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: const Text(
                        ' ',
                        style: TextStyle(
                            fontSize: 10.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.purpleAccent),
                      ),
                      subtitle: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            DropdownButton(
                              borderRadius: BorderRadius.circular(8.0),
                              dropdownColor:
                              GlobalStringText.textFieldDeepPinkColor,
                              isExpanded: true,
                              icon: const Icon(Icons.arrow_drop_down),
                              iconSize: 40,
                              underline: const SizedBox(),
                              value: _selectedEvent,
                              items: _dropdownEventsMenuItems,
                              onChanged: onChangeDropdownItem1,
                            ),
                          ]),
                    )
                  ],
                ),
              ),
            ],
          )),

      const SizedBox(height: 5.0),

      Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Image.asset(GlobalStringText.ImagesDescription),
          ],
        ),
        alignment: Alignment.centerLeft,
      ),
      const SizedBox(height: 5.0),
      TextFormField(
        maxLines: 5,
        focusNode: myFocusNodeDescription,
        controller: DescriptionController,
        decoration: InputDecoration(
          filled: true,
          fillColor: GlobalStringText.textFieldColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              width: 0,
              style: BorderStyle.solid,
            ),
          ),
          hintText: 'Enter Description for your Ticket',
          hintStyle: TextStyle(fontSize: 12.0,fontFamily: GlobalStringText.FontTextFormField, color: GlobalStringText.textFieldGrayColor),
          labelText: 'Describe your ticket...',
          labelStyle: TextStyle(
              fontSize: 14.0, color: GlobalStringText.textFieldGrayColor, fontFamily: GlobalStringText.FontTextFormField,fontWeight: FontWeight.w300),
          prefixText: ' ',
          //suffixStyle: const TextStyle(color: Colors.green)
        ),
      ),

      const Divider(
        color: Colors.white,
      ),
    ];
  }
}

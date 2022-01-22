import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/painting.dart';
import 'package:line_icons/line_icon.dart';
import 'package:provider/provider.dart';
import 'package:studenthub/Auth.dart';
import 'package:line_icons/line_icons.dart';
import 'package:badges/badges.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'ScreenTags.dart';
import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:google_maps_place_picker_mb/providers/place_provider.dart';
import 'package:google_maps_place_picker_mb/providers/search_provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

//---------------------------------------CLASSES--------------------------------------------------//
class Food {
  late int id;
  late String name;

  Food(this.id, this.name);

  String getName() => name;

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

  String getName() => name;

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
  String category;
  Map? data;


  NewPostScreen(this.category, {Key? key,  this.data}) : super(key: key);

  @override
  _NewPostScreenState createState() {
    return _NewPostScreenState();
  }
}

class _NewPostScreenState extends State<NewPostScreen> {

  static final kInitialPosition = LatLng(-33.8567844, 151.213108);


  DateTime selected_time = DateTime.now();
  late PickResult _selectedPlaceStart = PickResult();
  late PickResult _selectedPlaceDest = PickResult();

  TextEditingController TitleController = TextEditingController();
  TextEditingController LocationController = TextEditingController();
  TextEditingController DestinationController = TextEditingController();
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
            style: GoogleFonts.poppins(
                textStyle: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w300)),
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
            style: GoogleFonts.poppins(
                textStyle: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w300)),
          ),
        ),
      );
    }
    return items;
  }

  void fillInitFormVals() {
    if (widget.data != null) {
      TitleController = TextEditingController(text: widget.data!['title']);
      LocationController = TextEditingController(text: widget.data!['location'] ?? '');
      DestinationController = TextEditingController(text: widget.data!['destination'] ?? '');
      TimeController = TextEditingController(text: widget.data!['time']);
      selected_time =  DateFormat('d.M.yyyy , HH:mm').parse(TimeController.text);
      DescriptionController = TextEditingController(text: widget.data!['description']);
      EventTypeController = TextEditingController(text: widget.data!['type'] ?? '');
      FoodTypeController = TextEditingController(text: widget.data!['type'] ?? '');
      CourseNumberController = TextEditingController(text: widget.data!['course'] ?? '');
    }
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
    fillInitFormVals();
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
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
        backgroundColor: GlobalStringText.FifthpurpleColor,
        body: Column(
          children: [
            Container(
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    )),
                alignment: Alignment.topLeft,
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
                    ]),
              ),
              height: 110,
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
                    child: SingleChildScrollView(
                        child: Padding(
                      padding: EdgeInsets.only(bottom: bottom),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: TicketFields(),
                      ),
                    ))),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Image.asset(GlobalStringText.ImagesTitle),
                  IconButton(onPressed: () {
                    pushTicket();
                  }, icon: Image.asset(widget.data != null? "images/edit.png" : GlobalStringText.ImagesAddTicket), iconSize: 60, padding: EdgeInsets.zero,),
                ],
              ),
              alignment: Alignment.centerRight,
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
                    fontSize: 15.0,
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
    InkWell(
    onTap: ()  {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return PlacePicker(
              apiKey: "AIzaSyAfka9If5Jz-DslgoEWvm8pqfp_9Y2xoGs",
              hintText: "Find a place ...",
              searchingText: "Please wait ...",
              selectText: "Select place",
              outsideOfPickAreaText: "Place not in area",
              initialPosition: kInitialPosition,
              useCurrentLocation: true,
              selectInitialPosition: true,
              usePinPointingSearch: true,
              usePlaceDetailSearch: true,
              onPlacePicked: (result) {
                _selectedPlaceStart = result;
                Navigator.of(context).pop();
                setState(() {});
              },
              // forceSearchOnZoomChanged: true,
              // automaticallyImplyAppBarLeading: false,
              // autocompleteLanguage: "ko",
              // region: 'au',
              // pickArea: CircleArea(
              //   center: HomePage.kInitialPosition,
              //   radius: 300,
              //   fillColor: Colors.lightGreen.withGreen(255).withAlpha(32),
              //   strokeColor: Colors.lightGreen.withGreen(255).withAlpha(192),
              //   strokeWidth: 2,
              // ),
              // selectedPlaceWidgetBuilder: (_, selectedPlace, state, isSearchBarFocused) {
              //   print("state: $state, isSearchBarFocused: $isSearchBarFocused");
              //   return isSearchBarFocused
              //       ? Container()
              //       : FloatingCard(
              //           bottomPosition: 0.0, // MediaQuery.of(context) will cause rebuild. See MediaQuery document for the information.
              //           leftPosition: 0.0,
              //           rightPosition: 0.0,
              //           width: 500,
              //           borderRadius: BorderRadius.circular(12.0),
              //           child: state == SearchingState.Searching
              //               ? Center(child: CircularProgressIndicator())
              //               : RaisedButton(
              //                   child: Text("Pick Here"),
              //                   onPressed: () {
              //                     // IMPORTANT: You MUST manage selectedPlace data yourself as using this build will not invoke onPlacePicker as
              //                     //            this will override default 'Select here' Button.
              //                     print("do something with [selectedPlace] data");
              //                     Navigator.of(context).pop();
              //                   },
              //                 ),
              //         );
              // },
              // pinBuilder: (context, state) {
              //   if (state == PinState.Idle) {
              //     return Icon(Icons.favorite_border);
              //   } else {
              //     return Icon(Icons.favorite);
              //   }
              // },
              // introModalWidgetBuilder: (context,  close) {
              //   return Positioned(
              //     top: MediaQuery.of(context).size.height * 0.35,
              //     right: MediaQuery.of(context).size.width * 0.15,
              //     left: MediaQuery.of(context).size.width * 0.15,
              //     child: Container(
              //       width: MediaQuery.of(context).size.width * 0.7,
              //       child: Material(
              //         type: MaterialType.canvas,
              //         color: Theme.of(context).cardColor,
              //         shape: RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(12.0),
              //         ),
              //         elevation: 4.0,
              //         child: ClipRRect(
              //           borderRadius: BorderRadius.circular(12.0),
              //           child: Container(
              //             padding: EdgeInsets.all(8.0),
              //             child: Column(
              //               children: [
              //                 SizedBox.fromSize(size: new Size(0, 10)),
              //                 Text("Please select your preferred address.",
              //                   style: TextStyle(
              //                     fontWeight: FontWeight.bold,
              //                   )
              //                 ),
              //                 SizedBox.fromSize(size: new Size(0, 10)),
              //                 SizedBox.fromSize(
              //                   size: Size(MediaQuery.of(context).size.width * 0.6, 56), // button width and height
              //                   child: ClipRRect(
              //                     borderRadius: BorderRadius.circular(10.0),
              //                     child: Material(
              //                       child: InkWell(
              //                         overlayColor: MaterialStateColor.resolveWith(
              //                           (states) => Colors.blueAccent
              //                         ),
              //                         onTap: close,
              //                         child: Row(
              //                           mainAxisAlignment: MainAxisAlignment.center,
              //                           children: [
              //                             Icon(Icons.check_sharp, color: Colors.blueAccent),
              //                             SizedBox.fromSize(size: new Size(10, 0)),
              //                             Text("OK",
              //                               style: TextStyle(
              //                                 color: Colors.blueAccent
              //                               )
              //                             )
              //                           ],
              //                         )
              //                       ),
              //                     ),
              //                   ),
              //                 )
              //               ]
              //             )
              //           ),
              //         ),
              //       ),
              //     )
              //   );
              // },
            );
          },
        ),
      );
    },
    child: Container(
    child: Row(
    children: [Padding(padding: EdgeInsets.all(5)),
    Expanded(child: Text(
      _selectedPlaceStart.formattedAddress ?? (widget.category == GlobalStringText.tagCarPool? "Please pick Departure" : ""),
      style: TextStyle(color: Colors.deepPurpleAccent, fontSize: 16),
    ))
    ],
    mainAxisAlignment: MainAxisAlignment.start,
    ),
    decoration: BoxDecoration(
    color: Color(0xFFF0F4F8),
    borderRadius: BorderRadius.all(Radius.circular(5.0)),
    border: Border.all(color: Colors.black)),
    height: 50,
    ),
    ),



      SizedBox(height: 10,),
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
      InkWell(
        onTap: () {
          DatePicker.showDateTimePicker(context,
              showTitleActions: true,
              minTime: DateTime.now(),
              maxTime: (DateTime(2060, 12, 31, 23, 59)), onChanged: (date) {
            print('change $date in time zone ' +
                date.timeZoneOffset.inHours.toString());
          }, onConfirm: (date) {
            setState(() {
              selected_time = date;
            });
          });
        },
        child: Container(
          child: Row(
            children: [Padding(padding: EdgeInsets.all(5)),
              Text(
                DateFormat('d.M.yyyy , HH:mm').format(selected_time),
                style: TextStyle(color: Colors.deepPurpleAccent, fontSize: 16),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.start,
          ),
          decoration: BoxDecoration(
              color: Color(0xFFF0F4F8),
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              border: Border.all(color: Colors.black)),
          height: 50,
        ),
      ),

      /* TextFormField(
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
          hintText: 'Example 28.12.2021 , 14:00 ',
          hintStyle: TextStyle(
              fontSize: 12.0, color: GlobalStringText.textFieldGrayColor),
          //helperText: 'Keep it short, this is just a demo.',
          labelText: 'Pick a date and an hour and stick to the format',
          labelStyle: TextStyle(
              fontSize: 15.0,
              color: GlobalStringText.textFieldGrayColor,
              fontFamily: GlobalStringText.FontTextFormField,
              fontWeight: FontWeight.w300),

          prefixText: ' ',
          //suffixStyle: const TextStyle(color: Colors.green)
        ),
      )*/

      const SizedBox(height: 5.0),
      Visibility(
          visible: widget.category == GlobalStringText.tagMaterial ||
              widget.category == GlobalStringText.tagStudyBuddy ||
              widget.category == GlobalStringText.tagAcademicSupport,
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
                      fontSize: 15.0,
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
          visible: widget.category == GlobalStringText.tagFood,
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
          visible: widget.category == GlobalStringText.tagEntertainment,
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
      Visibility(
          visible: widget.category == GlobalStringText.tagCarPool,
          child: Column(
            children: [
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
              InkWell(

                onTap: ()  {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return PlacePicker(
                          apiKey: "AIzaSyAfka9If5Jz-DslgoEWvm8pqfp_9Y2xoGs",
                          hintText: "Find a place ...",
                          searchingText: "Please wait ...",
                          selectText: "Select place",
                          outsideOfPickAreaText: "Place not in area",
                          initialPosition: kInitialPosition,
                          useCurrentLocation: true,
                          selectInitialPosition: true,
                          usePinPointingSearch: true,
                          usePlaceDetailSearch: true,
                          onPlacePicked: (result) {
                            _selectedPlaceDest = result;
                            Navigator.of(context).pop();
                            setState(() {});
                          },
                          // forceSearchOnZoomChanged: true,
                          // automaticallyImplyAppBarLeading: false,
                          // autocompleteLanguage: "ko",
                          // region: 'au',
                          // pickArea: CircleArea(
                          //   center: HomePage.kInitialPosition,
                          //   radius: 300,
                          //   fillColor: Colors.lightGreen.withGreen(255).withAlpha(32),
                          //   strokeColor: Colors.lightGreen.withGreen(255).withAlpha(192),
                          //   strokeWidth: 2,
                          // ),
                          // selectedPlaceWidgetBuilder: (_, selectedPlace, state, isSearchBarFocused) {
                          //   print("state: $state, isSearchBarFocused: $isSearchBarFocused");
                          //   return isSearchBarFocused
                          //       ? Container()
                          //       : FloatingCard(
                          //           bottomPosition: 0.0, // MediaQuery.of(context) will cause rebuild. See MediaQuery document for the information.
                          //           leftPosition: 0.0,
                          //           rightPosition: 0.0,
                          //           width: 500,
                          //           borderRadius: BorderRadius.circular(12.0),
                          //           child: state == SearchingState.Searching
                          //               ? Center(child: CircularProgressIndicator())
                          //               : RaisedButton(
                          //                   child: Text("Pick Here"),
                          //                   onPressed: () {
                          //                     // IMPORTANT: You MUST manage selectedPlace data yourself as using this build will not invoke onPlacePicker as
                          //                     //            this will override default 'Select here' Button.
                          //                     print("do something with [selectedPlace] data");
                          //                     Navigator.of(context).pop();
                          //                   },
                          //                 ),
                          //         );
                          // },
                          // pinBuilder: (context, state) {
                          //   if (state == PinState.Idle) {
                          //     return Icon(Icons.favorite_border);
                          //   } else {
                          //     return Icon(Icons.favorite);
                          //   }
                          // },
                          // introModalWidgetBuilder: (context,  close) {
                          //   return Positioned(
                          //     top: MediaQuery.of(context).size.height * 0.35,
                          //     right: MediaQuery.of(context).size.width * 0.15,
                          //     left: MediaQuery.of(context).size.width * 0.15,
                          //     child: Container(
                          //       width: MediaQuery.of(context).size.width * 0.7,
                          //       child: Material(
                          //         type: MaterialType.canvas,
                          //         color: Theme.of(context).cardColor,
                          //         shape: RoundedRectangleBorder(
                          //             borderRadius: BorderRadius.circular(12.0),
                          //         ),
                          //         elevation: 4.0,
                          //         child: ClipRRect(
                          //           borderRadius: BorderRadius.circular(12.0),
                          //           child: Container(
                          //             padding: EdgeInsets.all(8.0),
                          //             child: Column(
                          //               children: [
                          //                 SizedBox.fromSize(size: new Size(0, 10)),
                          //                 Text("Please select your preferred address.",
                          //                   style: TextStyle(
                          //                     fontWeight: FontWeight.bold,
                          //                   )
                          //                 ),
                          //                 SizedBox.fromSize(size: new Size(0, 10)),
                          //                 SizedBox.fromSize(
                          //                   size: Size(MediaQuery.of(context).size.width * 0.6, 56), // button width and height
                          //                   child: ClipRRect(
                          //                     borderRadius: BorderRadius.circular(10.0),
                          //                     child: Material(
                          //                       child: InkWell(
                          //                         overlayColor: MaterialStateColor.resolveWith(
                          //                           (states) => Colors.blueAccent
                          //                         ),
                          //                         onTap: close,
                          //                         child: Row(
                          //                           mainAxisAlignment: MainAxisAlignment.center,
                          //                           children: [
                          //                             Icon(Icons.check_sharp, color: Colors.blueAccent),
                          //                             SizedBox.fromSize(size: new Size(10, 0)),
                          //                             Text("OK",
                          //                               style: TextStyle(
                          //                                 color: Colors.blueAccent
                          //                               )
                          //                             )
                          //                           ],
                          //                         )
                          //                       ),
                          //                     ),
                          //                   ),
                          //                 )
                          //               ]
                          //             )
                          //           ),
                          //         ),
                          //       ),
                          //     )
                          //   );
                          // },
                        );
                      },
                    ),
                  );
                },
                child: Container(
                  child: Row(
                    children: [
                      Padding(padding: EdgeInsets.all(5)),
                      Expanded(
                        child: Text(
                          _selectedPlaceDest.formattedAddress ?? "Please pick Destination",
                          style: TextStyle(color: Colors.deepPurpleAccent, fontSize: 16),
                        ),
                      )
                    ],
                    mainAxisAlignment: MainAxisAlignment.start,
                  ),
                  decoration: BoxDecoration(
                      color: Color(0xFFF0F4F8),
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      border: Border.all(color: Colors.black)),
                  height: 50,
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
          hintStyle: TextStyle(
              fontSize: 12.0,
              fontFamily: GlobalStringText.FontTextFormField,
              color: GlobalStringText.textFieldGrayColor),
          labelText: 'Describe your ticket...',
          labelStyle: TextStyle(
              fontSize: 15.0,
              color: GlobalStringText.textFieldGrayColor,
              fontFamily: GlobalStringText.FontTextFormField,
              fontWeight: FontWeight.w300),
          prefixText: ' ',
          //suffixStyle: const TextStyle(color: Colors.green)
        ),
      ),

      const Divider(
        color: Colors.white,
      ),
    ];
  }

  Future<void> pushTicket() async {
    if(emptyFieldExists()) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please fill all fields')));
      return Future.value(false);
    }
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final User? user = Provider.of<AuthRepository>(context, listen: false).user;
    var doc_ref;
    String action = widget.data != null? 'edit' : widget.category;
    switch(action) {
    case 'edit': {
    String type = (widget.category == GlobalStringText.tagFood)? _selectedFood.getName() : _selectedEvent.getName();
    (widget.data!['ref'] as DocumentReference).update({
    'Title' : TitleController.text,
    'Location' : _selectedPlaceStart.formattedAddress,
    'Time' : DateFormat('d.M.yyyy , HH:mm').format(selected_time),
    'Type' : type,
    'Description' : DescriptionController.text,
    'CourseNum' : CourseNumberController.text,
    'Destination' : DestinationController.text,
    });
    } break;
    case GlobalStringText.tagFood:
        {
          Map<String, dynamic> data = {
            'Title': TitleController.text,
            'Location': _selectedPlaceStart.formattedAddress,
            'Time': DateFormat('d.M.yyyy , HH:mm').format(selected_time),
            'Type': _selectedFood.getName(),
            'Description': DescriptionController.text,
            'Owner': user?.displayName,
            'uid' : user?.uid,
            'groupId' : (await _firestore.collection('chats').add({ 'subs' : [user!.uid] })).id
          };
          doc_ref = await _firestore.collection("Food").add(data);
        }
        break;
      case GlobalStringText.tagEntertainment:
        {
          Map<String, dynamic> data = {
            'Title': TitleController.text,
            'Location': _selectedPlaceStart.formattedAddress,
            'Time': DateFormat('d.M.yyyy , HH:mm').format(selected_time),
            'Type': _selectedEvent.getName(),
            'Description': DescriptionController.text,
            'Owner': user?.displayName,
            'uid' : user?.uid,
            'groupId' : (await _firestore.collection('chats').add({ 'subs' : [user!.uid] })).id
          };
          doc_ref = await _firestore.collection("Entertainment").add(data);
        }
        break;
      case GlobalStringText.tagCarPool:
        {
          Map<String, dynamic> data = {
            'Title': TitleController.text,
            'Location': _selectedPlaceStart.formattedAddress,
            'Destination': _selectedPlaceDest.formattedAddress,
            'Time': DateFormat('d.M.yyyy , HH:mm').format(selected_time),
            'Description': DescriptionController.text,
            'Owner': user?.displayName,
            'uid' : user?.uid,
            'groupId' : (await _firestore.collection('chats').add({ 'subs' : [user!.uid] })).id
          };
          doc_ref = await _firestore.collection("CarPool").add(data);
        }
        break;
      case GlobalStringText.tagAcademicSupport:
        {
          Map<String, dynamic> data = {
            'Title': TitleController.text,
            'Location': _selectedPlaceStart.formattedAddress,
            'CourseNum': CourseNumberController.text,
            'Time': DateFormat('d.M.yyyy , HH:mm').format(selected_time),
            'Description': DescriptionController.text,
            'Owner': user?.displayName,
            'uid' : user?.uid,
            'groupId' : (await _firestore.collection('chats').add({ 'subs' : [user!.uid] })).id
          };
          doc_ref = await _firestore.collection("AcademicSupport").add(data);
        }
        break;
      case GlobalStringText.tagStudyBuddy:
        {
          Map<String, dynamic> data = {
            'Title': TitleController.text,
            'Location': _selectedPlaceStart.formattedAddress,
            'CourseNum': CourseNumberController.text,
            'Time': DateFormat('d.M.yyyy , HH:mm').format(selected_time),
            'Description': DescriptionController.text,
            'Owner': user?.displayName,
            'uid' : user?.uid,
            'groupId' : (await _firestore.collection('chats').add({ 'subs' : [user!.uid] })).id
          };
          doc_ref = await _firestore.collection("StudyBuddy").add(data);
        }
        break;
      case GlobalStringText.tagMaterial:
        {
          Map<String, dynamic> data = {
            'Title': TitleController.text,
            'Location': _selectedPlaceStart.formattedAddress,
            'CourseNum': CourseNumberController.text,
            'Time': DateFormat('d.M.yyyy , HH:mm').format(selected_time),
            'Description': DescriptionController.text,
            'Owner': user?.displayName,
            'uid' : user?.uid,
            'groupId' : (await _firestore.collection('chats').add({ 'subs' : [user!.uid] })).id
          };
          doc_ref = await _firestore.collection("Material").add(data);
        }
        break;
      default:
        {}

    }
    _firestore.collection("users/${user?.uid}/tickets").add({
      'ref': doc_ref,
      'category': widget.category,
    });
    Navigator.of(context).pop();
  }

  bool emptyFieldExists() {
    switch(widget.category) {
      case GlobalStringText.tagFood:
        return (TitleController.text.isEmpty ||
                _selectedPlaceStart.formattedAddress == null ||
                _selectedFood.getName().isEmpty);
      case GlobalStringText.tagEntertainment:
        return (TitleController.text.isEmpty ||
            _selectedPlaceStart.formattedAddress == null ||
            _selectedEvent.getName().isEmpty);
      case GlobalStringText.tagCarPool:
        return (TitleController.text.isEmpty ||
            _selectedPlaceStart.formattedAddress == null ||
            _selectedPlaceDest.formattedAddress == null);
      case GlobalStringText.tagAcademicSupport:
        return (TitleController.text.isEmpty ||
            _selectedPlaceStart.formattedAddress == null ||
            CourseNumberController.text.isEmpty);

      case GlobalStringText.tagStudyBuddy:
        return (TitleController.text.isEmpty ||
            _selectedPlaceStart.formattedAddress == null ||
            CourseNumberController.text.isEmpty);
      case GlobalStringText.tagMaterial:
        return (TitleController.text.isEmpty ||
            _selectedPlaceStart.formattedAddress == null ||
            CourseNumberController.text.isEmpty);
      default: return false;
    }
  }
}

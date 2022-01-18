import 'dart:ui';
import 'package:filter_list/filter_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:studenthub/ScreenTags.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:badges/badges.dart';
import 'package:studenthub/CatogryHomePage.dart';
import 'package:studenthub/chatScreen.dart';
import 'package:studenthub/ticket_form_Screen.dart';
import 'Auth.dart';
import 'package:studenthub/FavoritesPage.dart';
import 'package:intl/intl.dart';
import 'main.dart';
import 'notificationHelper.dart';
import 'MaintainceScreen.dart';
import 'profilePage.dart';

class EventsPage extends StatefulWidget {
  final String category;

  const EventsPage({Key? key, required this.category}) : super(key: key);

  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  bool _isVisible = true;
  late final ScrollController _hideFapController = ScrollController();
  late var tickets;
  int selectedIndex = 5;
  int badge = 0;
  final padding = EdgeInsets.symmetric(horizontal: 18, vertical: 12);
  double gap = 10;
  List user_favorites = [];
  final TextEditingController _filter = new TextEditingController();
  String _searchText = ""; //search bar text
  List<Ticket> names = []; //all tickets
  List<Ticket> filteredNames = []; // tickets  filtered by search text
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text('Student Hub');
  bool search_tapped = false; // flag if the search on right top pressed
  List<String> filter_list = [
    "Sport",
    "BoardGames",
    "Party",
    "Chilling",
    "Other"
  ]; // filtered list in entertainment
  List<String>? selected_filter_list = []; //selected filters

  @override
  void initState() {
    super.initState();
    _isVisible = true;
    _hideFapController.addListener(() {
      if (_hideFapController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_isVisible == true) {
          setState(() {
            _isVisible = false;
          });
        }
      } else if (_hideFapController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (_isVisible == false) {
          setState(() {
            _isVisible = true;
          });
        }
      }
    });
    tickets = getTickets();
    this._getNames();
  }



  void _getNames() async {
    setState(() {
       tickets.then((data){names=data;});
      filteredNames = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    var filtered_column = Column(
      children: [
        Visibility(
            maintainAnimation: true,
            maintainState: true,
            visible: _isVisible,
            child: AnimatedOpacity(
              opacity: _isVisible ? 1 : 0,
              duration: const Duration(milliseconds: 500),
              child: getCategoryIcon(widget.category),
            )),
        getCategoryTitle(),
        Expanded(
            child: ListView(
              controller: _hideFapController,
          children: (selected_filter_list!.length == 0 ||
                  selected_filter_list == null)
              ? names
              : _searchText.isEmpty?filterList():processSearch(filterList: selected_filter_list),
        ))
      ],
    );
    var search_column = Column(
      children: [
        Visibility(
            maintainAnimation: true,
            maintainState: true,
            visible: _isVisible,
            child: AnimatedOpacity(
              opacity: _isVisible ? 1 : 0,
              duration: const Duration(milliseconds: 500),
              child: getCategoryIcon(widget.category),
            )),
        getCategoryTitle(),
        Expanded(
            child: ListView(
          children: filteredNames,
        ))
      ],
    );
    var mainCol = Column(
      children: [
        Visibility(
            maintainAnimation: true,
            maintainState: true,
            visible: _isVisible,
            child: AnimatedOpacity(
              opacity: _isVisible ? 1 : 0,
              duration: const Duration(milliseconds: 500),
              child: getCategoryIcon(widget.category),
            )),
        getCategoryTitle(),
        Expanded(
            child: FutureBuilder(
                future: tickets,
                builder: (context, snapshot) {
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
                          return ListView.builder(
                            itemCount: (snapshot.data as List<Widget>).length,
                            itemBuilder: (BuildContext context , int index){

                             if((snapshot.data as List<Ticket>)[index]._title.toLowerCase().contains(_searchText))
                                return (snapshot.data as List<Widget>)[index];

                            else{
                               return Container();
                             }

                              },
                           // children: snapshot.data as List<Widget>,
                            controller: _hideFapController,
                          );
                        }
                      }
                  }
                }))
      ],
    );
    return Container(
      child: Scaffold(
        floatingActionButton: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AnimatedOpacity(
              opacity: search_tapped ? 0 : 1,
              duration: Duration(milliseconds: 500),
              child: AnimatedOpacity(
                opacity: _isVisible ? 1 : 0,
                duration: const Duration(milliseconds: 500),
                child: Container(
                  margin: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                  padding: const EdgeInsets.only(left: 20),
                  child: SizedBox(
                      width: 70,
                      height: 70,
                      child: FittedBox(
                        child: (_isVisible && !search_tapped)? FloatingActionButton(
                            onPressed: addFloatingAction,
                            child: Tab(
                              icon: Container(
                                child: Image(
                                  image: AssetImage(
                                    GlobalStringText.ImagesAddTicket,
                                  ),
                                  fit: BoxFit.contain,
                                ),
                                height: 60,
                                width: 60,
                              ),
                            ),
                            backgroundColor: GlobalStringText.whiteColor):null,
                      )),
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            AnimatedOpacity(
              opacity: search_tapped ? 0 : 1,
              duration: Duration(milliseconds: 500),
              child: AnimatedOpacity(
                opacity: _isVisible ? 1 : 0,
                duration: const Duration(milliseconds: 500),
                child: (_isVisible && !search_tapped) ? Container(
                  margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  padding: const EdgeInsets.only(left: 20),
                  child: buildBottomNavigationBar(),
                ):null,
              ),
            ),
          ],
        ),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: _appBarTitle,
          actions: [
            Visibility(
              child: IconButton(
                icon: Image.asset("images/filter.png"),
                onPressed: filterTap,
              ),
              visible: (search_tapped || widget.category !="Entertainment") ? false : true,
            ),
            Visibility(
              child: GestureDetector(
                child: IconButton(
                  icon: _searchIcon,
                  onPressed: onSearchTapUp,
                ),
              ),
              visible: true,
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.deepPurple,
                  blurRadius: 3.0,
                )
              ]),
          child: mainCol,
        ),
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
    );
  }

  void addFloatingAction()
  {
    Navigator.of(context)
        .push(MaterialPageRoute(
        builder: (context) =>
            NewPostScreen(widget.category)))
        .then((value) async {
        names = await getTickets();
      setState(() {
        tickets = getTickets();
        filterList();
      });
    });
  }
  void filterTap() async {
    await FilterListDialog.display<String>(context,
        listData: filter_list,
        selectedTextBackgroundColor: Colors.deepPurpleAccent,
        selectedListData: selected_filter_list,
        applyButonTextBackgroundColor: Colors.deepPurpleAccent,
        height: MediaQuery.of(context).size.height * 0.55,
        width: MediaQuery.of(context).size.width * 0.75,
        headlineText: "Select Types of Entertainment",
        headerTextStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        searchFieldHintText: "Search Here", choiceChipLabel: (item) {
      return item;
    }, validateSelectedItem: (list, val) {
      return list!.contains(val);
    }, onItemSearch: (list, text) {
      if (list!.any(
          (element) => element.toLowerCase().contains(text.toLowerCase()))) {
        return list
            .where(
                (element) => element.toLowerCase().contains(text.toLowerCase()))
            .toList();
      } else {
        return [];
      }
    }, onApplyButtonClick: (list) {
      if (list != null) {
        setState(() {
          selected_filter_list = List.from(list);
        });
      }

      Navigator.pop(context);
    },);
  }

  List<Ticket> filterList() {
    List<Ticket> filteredList = [];

    for (var i = 0; i < names.length; i++) {
      if (selected_filter_list!.contains(names[i].type)) {
        filteredList.add(names[i]);
      }
    }
    return filteredList;
  }

  void onSearchTapUp() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        search_tapped = true;

        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          onChanged: (value){
            setState(() {
              _searchText=value;
            });
          },
          controller: _filter,
          style: TextStyle(color: Colors.white),
          decoration: new InputDecoration(
              border: InputBorder.none,
              prefixIcon:  Icon(Icons.search,color: Colors.white,),
              hintText: 'Search...'),
        );
      } else {
        search_tapped = false;
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text('Student Hub');
        _searchText="";
        _filter.clear();
      }
    });
  }

  List<Ticket> processSearch({List<String>? filterList}) {
    filteredNames = [];
    tickets.then((data){if (_searchText.isNotEmpty) {
      for (var i = 0; i < data.length; i++) {

        if (data[i]._time.toLowerCase().contains(_searchText.toLowerCase()) ||
            data[i]._title.toLowerCase().contains(_searchText.toLowerCase()) ||
            data[i]._desc.toLowerCase().contains(_searchText.toLowerCase()) ||
            data[i]
                ._location
                .toLowerCase()
                .contains(_searchText.toLowerCase()) ||
            (data[i].dest != null &&
                data[i]
                    .dest!
                    .toLowerCase()
                    .contains(_searchText.toLowerCase())) ||
            (data[i].course != null &&
                data[i]
                    .course!
                    .toLowerCase()
                    .contains(_searchText.toLowerCase())) ||
            (data[i]._owner != null &&
                data[i]
                    ._owner
                    .toLowerCase()
                    .contains(_searchText.toLowerCase()))) {
          if(filterList!=null && filterList.length!=0 && data[i].type !=null && !filterList.contains(data[i].type))
            continue;

          filteredNames.add(data[i]);



        }
      }
      return filteredNames;
    }});

    return filteredNames;
  }





  Future<List<Ticket>> getTickets() async {
    var tickets = <Ticket>[];
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final User? user = Provider.of<AuthRepository>(context, listen: false).user;
    await _firestore
        .collection("users/${user?.uid}/favorites")
        .get()
        .then((value) => {
              value.docs.forEach((element) {
                user_favorites.add(element.data()['ref']);
              })
            });
    final Color catColor = getCategoryColor();
    switch (widget.category) {
      case GlobalStringText.tagFood:
        {
          await _firestore.collection("Food").get().then((collection) {
            collection.docs.forEach((element) {
              var data = element.data();
              var ticket = Ticket(
                data['groupId'],
                data['uid'],
                data['Title'],
                data['Description'],
                data['Time'],
                catColor,
                data['Location'],
                data['Owner'],
                type: data['Type'],
                ref: element.reference,
                isLoved: user_favorites.contains(element.reference),
              );
              tickets.add(ticket);
            });
          });
        }
        break;
      case GlobalStringText.tagEntertainment:
        {
          await _firestore.collection("Entertainment").get().then((collection) {
            collection.docs.forEach((element) {
              var data = element.data();
              var ticket = Ticket(
                data['groupId'],
                data['uid'],
                data['Title'],
                data['Description'],
                data['Time'],
                catColor,
                data['Location'],
                data['Owner'],
                type: data['Type'],
                ref: element.reference,
                isLoved: user_favorites.contains(element.reference),
              );
              tickets.add(ticket);
            });
          });
        }
        break;
      case GlobalStringText.tagCarPool:
        {
          await _firestore.collection("CarPool").get().then((collection) {
            collection.docs.forEach((element) {
              var data = element.data();
              var ticket = Ticket(
                data['groupId'],
                data['uid'],
                data['Title'],
                data['Description'],
                data['Time'],
                catColor,
                data['Location'],
                data['Owner'],
                dest: data['Destination'],
                ref: element.reference,
                isLoved: user_favorites.contains(element.reference),
              );
              tickets.add(ticket);
            });
          });
        }
        break;
      case GlobalStringText.tagAcademicSupport:
        {
          await _firestore
              .collection("AcademicSupport")
              .get()
              .then((collection) {
            collection.docs.forEach((element) {
              var data = element.data();
              var ticket = Ticket(
                data['groupId'],
                data['uid'],
                data['Title'],
                data['Description'],
                data['Time'],
                catColor,
                data['Location'],
                data['Owner'],

                course: data['CourseNum'],
                ref: element.reference,
                isLoved: user_favorites.contains(element.reference),
              );
              tickets.add(ticket);
            });
          });
        }
        break;
      case GlobalStringText.tagStudyBuddy:
        {
          await _firestore.collection("StudyBuddy").get().then((collection) {
            collection.docs.forEach((element) {
              var data = element.data();
              var ticket = Ticket(
                data['groupId'],
                data['uid'],
                data['Title'],
                data['Description'],
                data['Time'],
                catColor,
                data['Location'],
                data['Owner'],

                course: data['CourseNum'],
                ref: element.reference,
                isLoved: user_favorites.contains(element.reference),
              );
              tickets.add(ticket);
            });
          });
        }
        break;
      case GlobalStringText.tagMaterial:
        {
          await _firestore.collection("Material").get().then((collection) {
            collection.docs.forEach((element) {
              var data = element.data();
              var ticket = Ticket(
                data['groupId'],
                data['uid'],
                data['Title'],
                data['Description'],
                data['Time'],
                catColor,
                data['Location'],
                data['Owner'],

                course: data['CourseNum'],
                ref: element.reference,
                isLoved: user_favorites.contains(element.reference),
              );
              tickets.add(ticket);
            });
          });
        }
        break;
      default:
        {
        }
    }
    return tickets;
  }

  Widget buildBottomNavigationBar() {
    return Material(
      color: Colors.transparent,
      elevation: 0,
      child: SafeArea(
        top: true,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
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
                            color:
                                selectedIndex == 1 ? Colors.pink : Colors.black,
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
                  switch (index) {
                    // just update the navigator i putted random navigation for the purpose of testing...
                    // waiting for yousef to do the pages
                    case 0:
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => FavoritesPage()));
                      break;
                    case 1:
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => CategoryPageScreen()));
                      break;

                    case 2:
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => MaintaincePage()));
                      break;
                  }
                });
              },
            ),
          ),
        ),
      ),
    );
  }

  Color getCategoryColor() {
    switch (widget.category) {
      case GlobalStringText.tagEntertainment:
        {
          return GlobalStringText.DeepPinkColorFirst;
        }
      case GlobalStringText.tagFood:
        {
          return GlobalStringText.LightBlueColorFirst;
        }
      case GlobalStringText.tagStudyBuddy:
        {
          return GlobalStringText.LightOarngeColorFirst;
        }
      case GlobalStringText.tagMaterial:
        {
          return GlobalStringText.LightRedColorFirst;
        }
      case GlobalStringText.tagCarPool:
        {
          return GlobalStringText.LightYellowColorFirst;
        }
      case GlobalStringText.tagAcademicSupport:
        {
          return GlobalStringText.LightGreenColorFirst;
        }
      default:
        {
          return Colors.white;
        }
    }
  }

  Widget getCategoryTitle() {
    switch (widget.category) {
      case GlobalStringText.tagEntertainment:
        {
          return const Text(
            "Entertainment",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.deepPurpleAccent,
              fontSize: 25,
            ),
          );
        }
      case GlobalStringText.tagFood:
        {
          return const Text(
            "Food",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.deepPurpleAccent,
              fontSize: 25,
            ),
          );
        }
      case GlobalStringText.tagStudyBuddy:
        {
          return const Text(
            "Study Buddy",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.deepPurpleAccent,
              fontSize: 25,
            ),
          );
        }
      case GlobalStringText.tagMaterial:
        {
          return const Text(
            "Material",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.deepPurpleAccent,
              fontSize: 25,
            ),
          );
        }
      case GlobalStringText.tagCarPool:
        {
          return const Text(
            "Car Pool",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.deepPurpleAccent,
              fontSize: 25,
            ),
          );
        }
      case GlobalStringText.tagAcademicSupport:
        {
          return const Text(
            "Academic Support",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.deepPurpleAccent,
              fontSize: 25,
            ),
          );
        }
      default:
        {
          return const Text(
            "WTF IS THIS, YOU AREN'T SUPPOSED TO BE BACK HERE",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.deepPurpleAccent,
              fontSize: 25,
            ),
          );
        }
    }
  }
}

class MyPainter extends CustomPainter {
  final Offset center;
  final double radius, containerHeight;
  final BuildContext context;

  late Color color;
  late double statusBarHeight, screenWidth;

  MyPainter(
      {required this.context,
      required this.containerHeight,
      required this.center,
      required this.radius}) {
    ThemeData theme = Theme.of(context);

    color = theme.primaryColor;
    statusBarHeight = MediaQuery.of(context).padding.top;
    screenWidth = MediaQuery.of(context).size.width;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Paint circlePainter = Paint();

    circlePainter.color = color;
    canvas.clipRect(
        Rect.fromLTWH(0, 0, screenWidth, containerHeight + statusBarHeight));
    canvas.drawCircle(center, radius, circlePainter);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

typedef Void2VoidFunc = void Function();

class Ticket extends StatefulWidget {
  static int id = 0;
  final String _time;
  final String _title;
  final String _desc;
  final String _location;
  final Color _color;
  final String _owner;
  final String _ticketId;
  final String _userID;
  var ref;
  String? dest;
  String? type;
  String? course;
  bool? isOpenedTicket;
  bool? isLoved;
  Void2VoidFunc? update;
  String? category;
  int? wid_id;

  Ticket(this._ticketId, this._userID, this._title, this._desc, this._time, this._color, this._location,
      this._owner,
      {Key? key,
      this.dest,
      this.type,
      this.course,
      this.isOpenedTicket,
      this.ref,
      this.isLoved,
      this.update,
      this.category})
      : super(key: key);

  @override
  _TicketState createState() => _TicketState();
}

class _TicketState extends State<Ticket> {
  bool _isSaved = false;
  bool _isExpanded = false;
  int notif_id = -1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isSaved = widget.isLoved ?? false;
  }

  @override
  Widget build(BuildContext context) {
    var titleSave = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
            child: Text(
          widget._title,
          maxLines: 2,
          style: GoogleFonts.montserrat(
              textStyle: TextStyle(
                  fontSize: 28,
                  color: GlobalStringText.purpleColor,
                  fontWeight: FontWeight.bold)),
        )),
        IconButton(
            onPressed: love,
            icon: _isSaved
                ? const Icon(
                    Icons.favorite,
                    color: Colors.redAccent,
                  )
                : const Icon(
                    Icons.favorite_border_outlined,
                    color: Colors.white,
                  ))
      ],
    );

    var openedTicketEdit = Row(
      children: [
        Expanded(
            child: Text(
          widget._title,
          maxLines: 2,
          style: const TextStyle(fontSize: 25, color: Color(0xFF6769EC)),
        )),
        //Spacer(),
        IconButton(
          icon: Image.asset("images/edit.png"),
          onPressed: editOpened,
        ),
        IconButton(onPressed: deleteOpened, icon: Image.asset("images/del.png"))
      ],
    );
    Widget childTicket;
    if (_isExpanded) {
      String extra_info = '';
      String extra_info_data = '';
      if (widget.dest != null) {
        extra_info = "Destination : ";
        extra_info_data = widget.dest!;
      } else if (widget.course != null) {
        extra_info = "Course Number : ";
        extra_info_data = widget.course!;
      } else if (widget.type != null) {
        extra_info = "Type : ";
        extra_info_data = widget.type!;
      }
      if (widget.isOpenedTicket != null && widget.isOpenedTicket == true) {
        childTicket = Container(
          margin: const EdgeInsets.fromLTRB(5, 10, 5, 0),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Color(0xFF7A3E98)),
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              openedTicketEdit,
              SizedBox(
                height: 5,
              ),
              Text(widget._desc,
                  style: const TextStyle(
                      fontSize: 18, color: Colors.black)),
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "At " + widget._time,
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                 widget._location,
                style: TextStyle(fontSize: 20),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                  icon: getCategoryIcon(widget.category!),
                  onPressed: () {},
                ),
              )
            ],
          ),
        );
      } else {
        childTicket = Column(
          children: [
            titleSave,
            SizedBox(height: 3),
            Row(
              children: [
                Text(
                  "Ticket Description : ",
                  style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                          fontSize: 15,
                          color: GlobalStringText.purpleColor,
                          fontWeight: FontWeight.bold)),
                ),
                Expanded(
                    child: Text(
                  widget._desc,
                  style: TextStyle(fontSize: 17, color: Colors.black),
                )),
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
            SizedBox(height: 3),
            Row(
              children: [
                Text(
                  "Ticket Owner : ",
                  style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                          fontSize: 15,
                          color: GlobalStringText.purpleColor,
                          fontWeight: FontWeight.bold)),
                ),
                Expanded(
                    child: InkWell(
                      child: Text(widget._owner,
                      style: TextStyle(fontSize: 17, color: Colors.black,fontWeight: FontWeight.bold),
                      overflow: TextOverflow.fade,
                      maxLines: 1,
                      softWrap: false,),
                      onTap: (){
                        Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) =>
                                    profilePage(userID: widget._userID)));
                      },

                    ),)
              ],
            ),
            SizedBox(height: 3),
            Row(
              children: [
                Text(
                  "Location : ",
                  style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                          fontSize: 15,
                          color: GlobalStringText.purpleColor,
                          fontWeight: FontWeight.bold)),
                ),
                Text(widget._location,
                    style: TextStyle(fontSize: 17, color: Colors.black))
              ],
            ),
            SizedBox(height: 3),
            Row(
              children: [
                Text(
                  "Time : ",
                  style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                          fontSize: 15,
                          color: GlobalStringText.purpleColor,
                          fontWeight: FontWeight.bold)),
                ),
                Text(widget._time,
                    style: TextStyle(fontSize: 17, color: Colors.black))
              ],
            ),
            SizedBox(height: 3),
            Row(
              children: [
                Text(
                  extra_info,
                  style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                          fontSize: 15,
                          color: GlobalStringText.purpleColor,
                          fontWeight: FontWeight.bold)),
                ),
                Text(extra_info_data,
                    style: TextStyle(fontSize: 17, color: Colors.black))
              ],
            ),
            SizedBox(height: 3),
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ChatScreen(widget._userID, false, widget._owner)));
                    },
                    icon: Image.asset('images/icons8-sent.png')),
                IconButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ChatScreen(widget._ticketId, true, '')));
                    },
                    icon: Image.asset('images/icons8-messaging-96.png')),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
            SizedBox(height: 3),
          ],
        );
      }
    } else {
      if (widget.isOpenedTicket != null &&
          widget.isOpenedTicket as bool == true) {
        childTicket = Container(
          margin: const EdgeInsets.fromLTRB(5, 10, 5, 0),
          padding: const EdgeInsets.all(16),

          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Color(0xFF7A3E98)),
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              openedTicketEdit,
              SizedBox(
                height: 10,
              ),
              Text(
                "At " + widget._time,
                style: TextStyle(fontSize: 20),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                  icon: getCategoryIcon(widget.category!),
                  onPressed: () {},
                ),
              )
            ],
          ),
        );
      } else {
        childTicket = Column(children: [
          titleSave,
          Text(widget._desc,
              maxLines: 2,
              overflow: TextOverflow.fade,
              style: TextStyle(
                  fontSize: 17, color: GlobalStringText.textFieldGrayColor)),
          Container(
              child: Align(
            alignment: Alignment.bottomRight,
            child: Text(
              widget._time,
              style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                      fontSize: 25,
                      color: GlobalStringText.purpleColor,
                      fontWeight: FontWeight.bold)),
            ),
          ))
        ]);
      }
    }
    if (widget.isOpenedTicket != null &&
        widget.isOpenedTicket as bool == true) {
      return InkWell(
        child: childTicket,
        onTap: expand,
      );
    }
    return InkWell(
      child: Container(
        margin: const EdgeInsets.fromLTRB(5, 10, 5, 0),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(24)),
          color: widget._color,
        ),
        child: childTicket,
      ),
      onTap: expand,
    );
  }

  void love() {

    var datetime = DateFormat('d.M.yyyy , HH:mm').parse(widget._time);
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final User? user = Provider.of<AuthRepository>(context, listen: false).user;
    if (_isSaved == false) {
      scheduleNotification(
          notifsPlugin,
          DateTime.now().toString(),
          widget._title,
          "you have event soon!",
          datetime.subtract(Duration(minutes: 10)),
          Ticket.id);
      notif_id = Ticket.id;
      widget.wid_id=notif_id;
      _firestore.collection("users/${user?.uid}/favorites").add({
        'ref': widget.ref,
        'id': Ticket.id++,
      });
    } else {
      _firestore
          .collection("users/${user?.uid}/favorites")
          .where('id', isEqualTo: widget.wid_id)
          .get()
          .then((collection) => {
                collection.docs.forEach((element) {
                  element.reference.delete();
                })
              });
      notifsPlugin.cancel(notif_id);

    }
    setState(() {
      _isSaved = !_isSaved;
    });
  }

  void editOpened() {
    Map<String, dynamic> data = {
      'ref': widget.ref,
      'time': widget._time,
      'title': widget._title,
      'description': widget._desc,
      'location': widget._location,
      'destination': widget.dest,
      'type': widget.type,
      'course': widget.course,
    };

    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (context) => NewPostScreen(
                  widget.category!,
                  data: data,
                )))
        .then((value) {
      widget.update!();
    });
  }

  void deleteOpened() {
    (widget.ref as DocumentReference).delete();
    widget.update!();
  }

  void expand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }
}

Widget getCategoryIcon(String category) {
  switch (category) {
    case GlobalStringText.tagEntertainment:
      {
        return Image.asset('images/icons8-comedy-64.png');
      }
    case GlobalStringText.tagFood:
      {
        return Image.asset('images/icons8-restaurant-64.png');
      }
    case GlobalStringText.tagStudyBuddy:
      {
        return Image.asset('images/icons8-book-and-pencil-64.png');
      }
    case GlobalStringText.tagMaterial:
      {
        return Image.asset('images/icons8-library-64.png');
      }
    case GlobalStringText.tagCarPool:
      {
        return Image.asset('images/icons8-car-64.png');
      }
    case GlobalStringText.tagAcademicSupport:
      {
        return Image.asset('images/icons8-helping-hand-64.png');
      }
    default:
      {
        return Container();
      }
  }
}

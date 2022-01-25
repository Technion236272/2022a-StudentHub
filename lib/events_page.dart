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
import 'chat_backend.dart';
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
  Map<DocumentReference, int> user_favorites = {};
  var favoritesReady;
  final TextEditingController _filter = new TextEditingController();
  String _searchText = ""; //search bar text
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
  }


  _EventsPageState() {
    _filter.addListener(() {
      setState(() {
        tickets=getTickets();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
            child: StreamBuilder(
                stream: tickets,
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
                          List list = (snapshot.data as QuerySnapshot).docs;
                          list.removeWhere((element) {
                            var now = Timestamp.now();
                            var data = element.data();
                            if (DateFormat('d.M.yyyy , HH:mm').parse(data['Time']).compareTo(now.toDate().subtract(const Duration(hours: 1))) < 0) {
                              deleteTicket(element);
                              return true;
                            }
                            return false;
                          });
                          return FutureBuilder(
                              future: favoritesReady,
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
                                        list.removeWhere((element) {
                                          var now = Timestamp.now();
                                          var data = element.data();
                                          if (DateFormat('d.M.yyyy , HH:mm').parse(data['Time']).compareTo(now.toDate().subtract(const Duration(minutes: 20))) < 0) {
                                            deleteTicket(element);
                                            return true;
                                          }
                                          return false;
                                        });
                                        return ListView.builder(
                                          itemCount: list.length,

                                          itemBuilder: (BuildContext context, int index) {
                                            Ticket ticket = Ticket.fromJson(list[index], widget.category, user_favorites);
                                            if (_searchText.isNotEmpty) {
                                              if (ticket
                                                  ._title
                                                  .toLowerCase()
                                                  .contains(_searchText.toLowerCase()) ||ticket
                                                  ._desc
                                                  .toLowerCase()
                                                  .contains(_searchText.toLowerCase())  || ticket
                                                  ._owner
                                                  .toLowerCase()
                                                  .contains(_searchText.toLowerCase()) || ticket
                                                  ._location
                                                  .toLowerCase()
                                                  .contains(_searchText.toLowerCase()) || ticket
                                                  ._time
                                                  .toLowerCase()
                                                  .contains(_searchText.toLowerCase()) ||( ticket
                                                  .dest!= null && ticket
                                                  .dest!
                                                  .toLowerCase()
                                                  .contains(_searchText.toLowerCase()) ) || ( ticket
                                                  .course!= null && ticket
                                                  .course!
                                                  .toLowerCase()
                                                  .contains(_searchText.toLowerCase()) )){
                                                if(selected_filter_list!.isNotEmpty)
                                                {
                                                  if(selected_filter_list!.contains(ticket.type))
                                                  {

                                                    return ticket;

                                                  }
                                                  else return Container();
                                                }
                                                else return ticket;
                                              }

                                              else {
                                                return Container();
                                              }
                                            }
                                            else if(selected_filter_list!.isNotEmpty)
                                            {

                                              if(selected_filter_list!.contains(ticket.type))
                                              {

                                                return ticket;

                                              }
                                              else return Container();
                                            }
                                            return ticket;

                                          },
                                          controller: _hideFapController,
                                        );
                                      }
                                    }
                                }
                              }
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
                        child: (_isVisible && !search_tapped)
                            ? FloatingActionButton(
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
                                backgroundColor: GlobalStringText.whiteColor)
                            : null,
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
                child: (_isVisible && !search_tapped)
                    ? Container(
                        margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        padding: const EdgeInsets.only(left: 20),
                        child: buildBottomNavigationBar(),
                      )
                    : null,
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
              visible: (search_tapped || widget.category != "Entertainment")
                  ? false
                  : true,
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

  void addFloatingAction() {
    Navigator.of(context)
        .pushNamed('/Home/${widget.category}/Create')
        .then((value) async {
      setState(() {
        tickets = getTickets();
      });
    });
  }

  void filterTap() async {
    await FilterListDialog.display<String>(
      context,
      listData: filter_list,
      selectedTextBackgroundColor: Colors.deepPurpleAccent,
      selectedListData: selected_filter_list,
      applyButonTextBackgroundColor: Colors.deepPurpleAccent,
      height: MediaQuery.of(context).size.height * 0.55,
      width: MediaQuery.of(context).size.width * 0.75,
      headlineText: "Select Types of Entertainment",
      headerTextStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
      searchFieldHintText: "Search Here",
      choiceChipLabel: (item) {
        return item;
      },
      validateSelectedItem: (list, val) {
        return list!.contains(val);
      },
      onItemSearch: (list, text) {
        if (list!.any(
            (element) => element.toLowerCase().contains(text.toLowerCase()))) {
          return list
              .where((element) =>
                  element.toLowerCase().contains(text.toLowerCase()))
              .toList();
        } else {
          return [];
        }
      },
      onApplyButtonClick: (list) {
        setState(() {
          tickets=getTickets();
        });
        if (list != null) {
          setState(() {
            selected_filter_list = List.from(list);
          });
        }

        Navigator.pop(context);
      },
    );
  }


  void onSearchTapUp() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        search_tapped = true;

        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          onChanged: (value) {
            setState(() {
              _searchText = value;
            });
          },
          controller: _filter,
          style: TextStyle(color: Colors.white),
          decoration: new InputDecoration(
              border: InputBorder.none,
              prefixIcon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              hintText: 'Search...'),
        );
      } else {
        search_tapped = false;
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text('Student Hub');
        _searchText = "";
        tickets=getTickets();
        _filter.clear();
      }
    });
  }


  Stream getTickets() {
    user_favorites.clear();
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final User? user = Provider.of<AuthRepository>(context, listen: false).user;
    favoritesReady = _firestore
        .collection("users/${user?.uid}/favorites")
        .get()
        .then((value) => {
              value.docs.forEach((element) {
                user_favorites[element.data()['ref']] = element.data()['id'];
              })
            });
    switch (widget.category) {
      case GlobalStringText.tagFood:
        {
          return _firestore.collection("Food").orderBy('Time').snapshots();
        }
      case GlobalStringText.tagEntertainment:
        {
          return _firestore.collection("Entertainment").orderBy('Time').snapshots();
        }
      case GlobalStringText.tagCarPool:
        {
          return _firestore.collection("CarPool").orderBy('Time').snapshots();
        }
      case GlobalStringText.tagAcademicSupport:
        {
          return _firestore
              .collection("AcademicSupport")
              .orderBy('Time').snapshots();
        }
      case GlobalStringText.tagStudyBuddy:
        {
          return _firestore.collection("StudyBuddy").orderBy('Time').snapshots();
        }
      case GlobalStringText.tagMaterial:
        {
          return _firestore.collection("Material").orderBy('Time').snapshots();
        }
      default:
        {
          return const Stream.empty();
        }
    }
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
                    case 0 :
                      Navigator.of(context).pushNamedAndRemoveUntil('/Home/Favorites', (route) => route.isFirst);
                      break;
                    case 1 :
                      Navigator.of(context).pushNamedAndRemoveUntil('/Home', (route) => false);
                      break;
                    case 2 :
                      Navigator.of(context).pushNamedAndRemoveUntil('/Home/Inbox', (route) => route.isFirst);
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
  int? notif_id;

  Ticket(this._ticketId, this._userID, this._title, this._desc, this._time,
      this._color, this._location, this._owner,
      {Key? key,
      this.dest,
      this.type,
      this.course,
      this.isOpenedTicket,
      this.ref,
      this.isLoved,
      this.update,
      this.category,
      this.notif_id})
      : super(key: key);

  factory Ticket.fromJson(DocumentSnapshot<Map<String,dynamic>> e, String category, Map<DocumentReference<Object?>, int> userFavorites) {
    final Color catColor = getCategoryColor(category);
    Map<String,dynamic> data = e.data()!;
    switch (category) {
      case GlobalStringText.tagFood:
        {
          return Ticket(
            data['groupId'],
            data['uid'],
            data['Title'],
            data['Description'],
            data['Time'],
            catColor,
            data['Location'],
            data['Owner'],
            type: data['Type'],
            ref: e.reference,
            isLoved: userFavorites.containsKey(e.reference),
            notif_id: userFavorites[e.reference] ?? -1,
          );
        }
      case GlobalStringText.tagEntertainment:
        {
          return Ticket(
                  data['groupId'],
                  data['uid'],
                  data['Title'],
                  data['Description'],
                  data['Time'],
                  catColor,
                  data['Location'],
                  data['Owner'],
                  type: data['Type'],
                  ref: e.reference,
                  isLoved: userFavorites.containsKey(e.reference),
                  notif_id: userFavorites[e.reference] ?? -1,
                );
        }
      case GlobalStringText.tagCarPool:
        {
          return Ticket(
                  data['groupId'],
                  data['uid'],
                  data['Title'],
                  data['Description'],
                  data['Time'],
                  catColor,
                  data['Location'],
                  data['Owner'],
                  dest: data['Destination'],
                  ref: e.reference,
                  isLoved: userFavorites.containsKey(e.reference),
                  notif_id: userFavorites[e.reference] ?? -1,
                );
        }
      case GlobalStringText.tagAcademicSupport:
        {
          return Ticket(
                  data['groupId'],
                  data['uid'],
                  data['Title'],
                  data['Description'],
                  data['Time'],
                  catColor,
                  data['Location'],
                  data['Owner'],
                  course: data['CourseNum'],
                  ref: e.reference,
                  isLoved: userFavorites.containsKey(e.reference),
                  notif_id: userFavorites[e.reference] ?? -1,
                );
        }
      case GlobalStringText.tagStudyBuddy:
        {
          return Ticket(
                  data['groupId'],
                  data['uid'],
                  data['Title'],
                  data['Description'],
                  data['Time'],
                  catColor,
                  data['Location'],
                  data['Owner'],
                  course: data['CourseNum'],
                  ref: e.reference,
                  isLoved: userFavorites.containsKey(e.reference),
                  notif_id: userFavorites[e.reference] ?? -1,
                );
        }
      case GlobalStringText.tagMaterial:
        {
          return Ticket(
                  data['groupId'],
                  data['uid'],
                  data['Title'],
                  data['Description'],
                  data['Time'],
                  catColor,
                  data['Location'],
                  data['Owner'],
                  course: data['CourseNum'],
                  ref: e.reference,
                  isLoved: userFavorites.containsKey(e.reference),
                  notif_id: userFavorites[e.reference] ?? -1,
                );
        }
      default:
        {
          return Ticket('_ticketId', '_userID', '_title', '_desc', '_time', Colors.white, '_location', '_owner');
        }
    }
  }

  @override
  _TicketState createState() => _TicketState();
}

class _TicketState extends State<Ticket> {
  bool _isSaved = false;
  bool _isExpanded = false;

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
              overflow: TextOverflow.fade,
              softWrap: true,
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
              overflow: TextOverflow.fade,
              softWrap: true,
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
                  overflow: TextOverflow.fade,
                  maxLines: 5,
                  softWrap: true,
                  style: const TextStyle(fontSize: 18, color: Colors.black)),
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
                overflow: TextOverflow.fade,
                maxLines: 2,
                softWrap: true,
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
                      overflow: TextOverflow.clip,
                      maxLines: 6,
                      softWrap: true,
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
                    child: Text(
                      widget._owner,
                      style: const TextStyle(
                          fontSize: 17,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                      overflow: TextOverflow.fade,
                      maxLines: 2,
                      softWrap: true,
                    ),
                    onTap: () {
                      Navigator.of(context).pushNamed('/Home/Profile', arguments: widget._userID);
                    },
                  ),
                )
              ],
            ),
            SizedBox(height: 3),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Location : ",
                  style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                          fontSize: 15,
                          color: GlobalStringText.purpleColor,
                          fontWeight: FontWeight.bold)),
                ),
                Expanded(child:
                Text(
                  widget._location,
                  style: const TextStyle(
                      fontSize: 17,
                      color: Colors.black,
                     ),
                  overflow: TextOverflow.fade,
                  maxLines: 2,
                  softWrap: true,
                ),)
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
                Expanded(child:                 Text(widget._time,
                    overflow: TextOverflow.fade,
                    maxLines: 2,
                    softWrap: true,
                    style: TextStyle(fontSize: 17, color: Colors.black))
                )
              ],
            ),
            SizedBox(height: 5),
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
                Expanded(child:  Text(
                  extra_info_data,
                  style: TextStyle(fontSize: 17, color: Colors.black),
                  overflow: TextOverflow.fade,
                  maxLines: 2,
                  softWrap: true,
                )
                )
              ],
            ),
            SizedBox(height: 3),
            Row(
              children: [
                Visibility(child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/Home/Inbox/Chat', arguments: {
                        'uid' : widget._userID,
                        'isGroup' : false,
                        'name' : widget._owner
                      });
                    },
                    icon: Image.asset('images/icons8-sent.png'))
                  ,visible: widget._userID != Chat.user!.uid,),
                IconButton(
                    onPressed: () {
                      Chat.firestore.collection('users/${Chat.user!.uid}/groups').doc(widget._ticketId).get().then((value) {
                        Navigator.of(context).pushNamed('/Home/Inbox/Chat', arguments: {
                          'uid' : widget._ticketId,
                          'isGroup' : true,
                          'name' : widget._title,
                          'mute' : value.data()?['mute'] ?? false
                        });
                      });
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
      widget.notif_id=Ticket.id;

      _firestore.collection("users/${user?.uid}/favorites").add({
        'ref': widget.ref,
        'id': Ticket.id++,

      });
    } else {
      _firestore
          .collection("users/${user?.uid}/favorites")
          .where('id', isEqualTo: widget.notif_id)
          .get()
          .then((collection) => {
                collection.docs.forEach((element) {
                  element.reference.delete();
                })
              });
      notifsPlugin.cancel(widget.notif_id!);


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

    Navigator.of(context).pushNamed('/Home/Opened/Edit', arguments: {
      'category' : widget.category,
      'data' : data,
    }).then((value) {
      widget.update!();
    });
  }

  void deleteOpened() {
    (widget.ref as DocumentReference<Map<String,dynamic>>).get().then((value) {
      deleteTicket(value);
    });
    widget.update!();
  }

  void expand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }
}


Color getCategoryColor(String category) {
  switch (category) {
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

void deleteTicket(DocumentSnapshot<Map<String, dynamic>> element) {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  _firestore.collection('chats').doc(element.data()!['groupId']).get().then((value) {
    List<dynamic> subs = value.get('subs');
    for (var sub in subs) {
      _firestore.collection('users/${sub as String}/groups').doc(element.data()!['groupId']).delete();
    }
    _firestore.collection('chats').doc(element.data()!['groupId']).delete();
  });
  _firestore.collection('users/${element.data()!['uid']}/tickets').where('ref', isEqualTo: element.reference).get().then((value) {
    for (var element in value.docs) {
      element.reference.delete();
    }});
  element.reference.delete();
}

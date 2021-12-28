import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:studenthub/ScreenTags.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:badges/badges.dart';
import 'package:studenthub/CatogryHomePage.dart';
import 'package:studenthub/GenericPageCreation.dart';
import 'GenericPageCreation.dart';

import 'package:intl/intl.dart';
import 'main.dart';
import 'notificationHelper.dart';

import 'MaintainceScreen.dart';


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
              child: getCategoryIcon(),
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
                          return ListView(
                            children: snapshot.data as List<Widget>,
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
        opacity: _isVisible ? 1 : 0,
          duration: const Duration(milliseconds: 500),
          child: Container(
            margin: const EdgeInsets.fromLTRB(5, 0, 0, 0),
            padding: const EdgeInsets.only(left:20),
            child: SizedBox(
                width: 70,
                height: 70,
                child: FittedBox(child:FloatingActionButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewPostScreen(widget.category)));
                    },
                    child:Tab(
                      icon: Container(
                        child:  Image(
                          image: AssetImage(
                            GlobalStringText.ImagesAddTicket,
                          ),
                          fit: BoxFit.contain,
                        ),
                        height: 60,
                        width: 60,
                      ),

                    ),
                    backgroundColor: GlobalStringText.whiteColor
                ),)
            ),),),
            SizedBox(height: 10.0,),
            AnimatedOpacity(
              opacity: _isVisible ? 1 : 0,
              duration: const Duration(milliseconds: 500),
              child: Container(
                margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                padding: const EdgeInsets.only(left:20),
                child: buildBottomNavigationBar(),
              ),),
                ],
              ),
          appBar: const SearchAppBar(),
          backgroundColor: Colors.transparent,
          body: Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
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

  Future<List<Ticket>> getTickets() async {
    var tickets = <Ticket>[];
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final Color catColor = getCategoryColor();
    switch (widget.category) {
      case GlobalStringText.tagFood:
        {
          await _firestore.collection("Food").get().then((collection) {
            collection.docs.forEach((element) {
              var data = element.data();
              var ticket = Ticket(
                data['Title'],
                data['Description'],
                data['Time'],
                catColor,
                data['Location'],
                data['Owner'],
                type: data['Type'],
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
                data['Title'],
                data['Description'],
                data['Time'],
                catColor,
                data['Location'],
                data['Owner'],
                type: data['Type'],
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
                data['Title'],
                data['Description'],
                data['Time'],
                catColor,
                data['Location'],
                data['Owner'],
                dest: data['Destination'],
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
                data['Title'],
                data['Description'],
                data['Time'],
                catColor,
                data['Location'],
                data['Owner'],
                course: data['CourseNum'],
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
                data['Title'],
                data['Description'],
                data['Time'],
                catColor,
                data['Location'],
                data['Owner'],
                course: data['CourseNum'],
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
                data['Title'],
                data['Description'],
                data['Time'],
                catColor,
                data['Location'],
                data['Owner'],
                course: data['CourseNum'],
              );
              tickets.add(ticket);
            });
          });
        }
        break;
      default:
        {
          tickets.add(Ticket(
              "_title",
              "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
              "14:30",
              getCategoryColor(),
              '',
              ''));
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

  Widget getCategoryIcon() {
    switch (widget.category) {
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
}

class SearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  const SearchAppBar({Key? key}) : super(key: key);

  @override
  _SearchAppBarState createState() => _SearchAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(56);
}

class _SearchAppBarState extends State<SearchAppBar>
    with SingleTickerProviderStateMixin {
  late double rippleStartX, rippleStartY;
  late AnimationController _controller;
  late Animation _animation;

  @override
  initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: const Text("Student HUB"),
          actions: [
            Visibility(
              child: GestureDetector(
                child: IconButton(
                  icon: const Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  onPressed: () {},
                ),
                onTapUp: onSearchTapUp,
              ),
              visible: false,
            ),
          ],
        )
      ],
    );
  }

  void onSearchTapUp(TapUpDetails details) {
    setState(() {
      rippleStartX = details.globalPosition.dx;
      rippleStartY = details.globalPosition.dy;
    });

    print("pointer location $rippleStartX, $rippleStartY");
    _controller.forward();
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

class Ticket extends StatefulWidget {
  final String _time;
  final String _title;
  final String _desc;
  final String _location;
  final Color _color;
  final String _owner;
  String? dest;
  String? type;
  String? course;
  bool? isOpenedTicket;

  Ticket(this._title, this._desc, this._time, this._color, this._location,
      this._owner,
      {Key? key, this.dest, this.type, this.course, this.isOpenedTicket})
      : super(key: key);

  @override
  _TicketState createState() => _TicketState();
}

class _TicketState extends State<Ticket> {
  bool _isSaved = false;
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    var titleSave = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget._title,
          maxLines: 1,
          style:GoogleFonts.montserrat(textStyle: TextStyle(fontSize: 28, color: GlobalStringText.purpleColor , fontWeight: FontWeight.bold  )),
        ),
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
        Text(
          widget._title,
          maxLines: 1,
          style: const TextStyle(fontSize: 25, color: Color(0xFF6769EC)),
        ),
        Spacer(),
        IconButton(
          icon: Image.asset("images/edit.png"),
          onPressed: () {},
        ),
        IconButton(onPressed: () {}, icon: Image.asset("images/del.png"))
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
      if(widget.isOpenedTicket != null && widget.isOpenedTicket == true) {
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
    SizedBox(
    height: 5,
    ),
    Text(
    "Description:",
    style: TextStyle(fontSize: 19, color: Colors.black),
    ),
    Text(widget._desc,
    style: const TextStyle(
    fontSize: 17, color: Colors.indigoAccent)),
    SizedBox(
    height: 5,
    ),
    Row(
    children: const [
    Text(
    "Ticket Owner : ",
    style:
    TextStyle(fontSize: 19, color: Colors.black),
    ),
    Text("<TICKET OWNER>",
    style:
    TextStyle(fontSize: 17, color: Colors.indigoAccent))
    ],
    ),   SizedBox(
    height: 5,
    ),
    Row(
    children: const [
    Text(
    "Location : ",
    style:
    TextStyle(fontSize: 19, color: Colors.black),
    ),
    Text("<LOCATION>",
    style:
    TextStyle(fontSize: 17, color: Colors.indigoAccent))
    ],
    ),
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
            style:   GoogleFonts.montserrat(textStyle: TextStyle(fontSize: 15, color: GlobalStringText.purpleColor , fontWeight: FontWeight.bold  )),
          ),
          Expanded(
              child: Text(widget._desc,
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
            style:   GoogleFonts.montserrat(textStyle: TextStyle(fontSize: 15, color: GlobalStringText.purpleColor , fontWeight: FontWeight.bold  )),

          ),
          Expanded(child: Text(widget._owner,
            style: TextStyle(fontSize: 17, color: Colors.black),
            overflow: TextOverflow.fade,
            maxLines: 1,
            softWrap: false,))
        ],
      ),
      SizedBox(height: 3),
      Row(
        children: [
          Text(
            "Location : ",
            style:   GoogleFonts.montserrat(textStyle: TextStyle(fontSize: 15, color: GlobalStringText.purpleColor , fontWeight: FontWeight.bold  )),
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
            style:   GoogleFonts.montserrat(textStyle: TextStyle(fontSize: 15, color: GlobalStringText.purpleColor , fontWeight: FontWeight.bold  )),
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
            style:   GoogleFonts.montserrat(textStyle: TextStyle(fontSize: 15, color: GlobalStringText.purpleColor , fontWeight: FontWeight.bold  )),
          ),
          Text(extra_info_data,
              style: TextStyle(fontSize: 17, color: Colors.black))
        ],

      ),
      SizedBox(height: 3),
      Row(
        children: [
          IconButton(onPressed: () {                                          Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) =>
                      MaintaincePage()));}, icon: Image.asset('images/icons8-sent.png')),
          IconButton(onPressed: () {                                          Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) =>
                      MaintaincePage()));}, icon: Image.asset('images/icons8-messaging-96.png')),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
      SizedBox(height: 3),
    ],
    );
    }

    } else {
    if(widget.isOpenedTicket != null && widget.isOpenedTicket as bool == true) {
    childTicket = Container(
    margin: const EdgeInsets.fromLTRB(5, 10, 5, 0),
    padding: const EdgeInsets.all(16),
    height: 147,
    width: 384,
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
    ],
    ),
    );
    } else {
    childTicket = Column(
        children: [
          titleSave,
          Text(widget._desc,
              maxLines: 2,
              overflow: TextOverflow.fade,
              style:  TextStyle(fontSize: 17, color: GlobalStringText.textFieldGrayColor )),
          Container(
            child: Align(
              alignment: Alignment.bottomRight,
              child: Text(widget._time,
                style:   GoogleFonts.montserrat(textStyle: TextStyle(fontSize: 25, color: GlobalStringText.purpleColor , fontWeight: FontWeight.bold  )),),
            ),
            margin: const EdgeInsets.only(top: 10),
          )
        ],
      ); }
    }
    if(widget.isOpenedTicket != null && widget.isOpenedTicket as bool == true) {
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
    if(_isSaved == false)
      {
        var datetime = DateFormat('d.M.yyyy , HH:mm').parse(widget._time);

        scheduleNotification(notifsPlugin,DateTime.now().toString(),widget._title,"you have event soon!",datetime.subtract(Duration(minutes: 10)));
      }
    setState(() {
      _isSaved = !_isSaved;
    });
  }

  void expand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }
}

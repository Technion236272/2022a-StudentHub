import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:studenthub/ScreenTags.dart';

import 'GenericPageCreation.dart';

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
          floatingActionButton: AnimatedOpacity(
            opacity: _isVisible ? 1 : 0,
            duration: const Duration(milliseconds: 500),
            child: FloatingActionButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(
                        builder: (context) => NewPostScreen(widget.category)))
                    .then((value) {
                  tickets = getTickets();
                  setState(() {});
                });
              },
              child: const Icon(
                Icons.post_add_rounded,
                color: Colors.black,
                size: 40,
              ),
              backgroundColor: Colors.deepPurpleAccent,
            ),
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
          )),
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [Colors.white, Colors.deepPurpleAccent])),
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

  Color getCategoryColor() {
    switch (widget.category) {
      case GlobalStringText.tagEntertainment:
        {
          return Colors.deepOrangeAccent;
        }
      case GlobalStringText.tagFood:
        {
          return Colors.redAccent;
        }
      case GlobalStringText.tagStudyBuddy:
        {
          return Colors.orangeAccent;
        }
      case GlobalStringText.tagMaterial:
        {
          return Colors.blue;
        }
      case GlobalStringText.tagCarPool:
        {
          return Colors.yellow;
        }
      case GlobalStringText.tagAcademicSupport:
        {
          return Colors.lightGreen;
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
  var dest;
  var type;
  var course;

  Ticket(this._title, this._desc, this._time, this._color, this._location,
      this._owner,
      {Key? key, this.dest, this.type, this.course})
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
          style: const TextStyle(fontSize: 25, color: Colors.white),
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
    Column childTicket;
    if (_isExpanded) {
      String extra_info = '';
      String extra_info_data = '';
      if (widget.dest != null) {
        extra_info = "Destination : ";
        extra_info_data = widget.dest;
      } else if (widget.course != null) {
        extra_info = "Course Number : ";
        extra_info_data = widget.course;
      } else if (widget.type != null) {
        extra_info = "Type : ";
        extra_info_data = widget.type;
      }
      childTicket = Column(
        children: [
          titleSave,
          Text(widget._desc,
              style: const TextStyle(fontSize: 17, color: Colors.white)),
          Row(
            children: [
              const Text(
                "Ticket Owner : ",
                style: TextStyle(fontSize: 19, color: Colors.amberAccent),
              ),
              Text(widget._owner,
                  style: TextStyle(fontSize: 17, color: Colors.white))
            ],
            mainAxisAlignment: MainAxisAlignment.spaceAround,
          ),
          Row(
            children: [
              const Text(
                "Location : ",
                style: TextStyle(fontSize: 19, color: Colors.amberAccent),
              ),
              Text(widget._location,
                  style: TextStyle(fontSize: 17, color: Colors.white))
            ],
            mainAxisAlignment: MainAxisAlignment.spaceAround,
          ),
          Row(
            children: [
              const Text(
                "Time : ",
                style: TextStyle(fontSize: 19, color: Colors.amberAccent),
              ),
              Text(widget._time,
                  style: TextStyle(fontSize: 17, color: Colors.white))
            ],
            mainAxisAlignment: MainAxisAlignment.spaceAround,
          ),
          Row(
            children: [
              Text(
                extra_info,
                style: TextStyle(fontSize: 19, color: Colors.amberAccent),
              ),
              Text(extra_info_data,
                  style: TextStyle(fontSize: 17, color: Colors.white))
            ],
            mainAxisAlignment: MainAxisAlignment.spaceAround,
          ),
          Row(
            children: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.chat)),
              IconButton(
                  onPressed: () {}, icon: const Icon(Icons.send_outlined)),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
        ],
      );
    } else {
      childTicket = Column(
        children: [
          titleSave,
          Text(widget._desc,
              maxLines: 2,
              overflow: TextOverflow.fade,
              style: const TextStyle(fontSize: 17, color: Colors.white)),
          Container(
            child: Align(
              alignment: Alignment.bottomRight,
              child: Text(widget._time,
                  style: TextStyle(fontSize: 20, color: Colors.white)),
            ),
            margin: const EdgeInsets.only(top: 10),
          )
        ],
      );
    }

    return InkWell(
      child: Container(
        margin: const EdgeInsets.fromLTRB(5, 10, 5, 0),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white.withOpacity(0.1), widget._color],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            ),
            borderRadius: BorderRadius.circular(30.0),
            boxShadow: [
              BoxShadow(
                color: widget._color,
                blurRadius: 3.0,
              )
            ]),
        child: childTicket,
      ),
      onTap: expand,
    );
  }

  void love() {
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Auth.dart';
import 'ScreenTags.dart';
import 'events_page.dart';
import 'package:studenthub/Auth.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OpenedTicketsPage extends StatefulWidget {
  const OpenedTicketsPage({Key? key}) : super(key: key);

  @override
  _OpenedTicketsPage createState() => _OpenedTicketsPage();
}

class _OpenedTicketsPage extends State<OpenedTicketsPage> {
  late var tickets;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tickets = getOpenedTickets(context);
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final user = Provider.of<AuthRepository>(context);
    return Scaffold(
      body: Column(
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
                    .height * 0.2,
                color: Color(0xFF8C88F9),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            )),
                        new Spacer(),
                        IconButton(
                          onPressed: () async {
                            await user.signOut();
                            Navigator.popUntil(context, (route) =>
                            route.isFirst);
                          },
                          icon: Image.asset("images/logout.png"),
                          iconSize: 40,
                        ),
                      ],
                    ),
                    Container(
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text("Hi Yair",
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Quicksand-Bold.ttf',
                                    color: Colors.white,
                                  )),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                "Welcome Back!",
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Quicksand-Bold.ttf',
                                  color: Colors.white,
                                ),
                              ),
                              new Image.asset(GlobalStringText.ImageWavingTest)
                            ],
                          )
                        ],
                      ),
                      margin: EdgeInsets.only(left: 15),
                    )
                  ],
                ),
              )),
          Flexible(
            child: Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.8,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              decoration: BoxDecoration(
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
                      children: <Widget>[
                        Image.asset(
                          "images/Ticketsicon.png",
                          height: 64,
                          width: 64,
                        ),
                        Text(
                          "Opened Tickets",
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat',
                              color: Color(0xFF6769EC)),
                        )
                      ],
                    ),
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
                                  return Center(
                                      child: Text("Error ${snapshot.error}"));
                                } else {
                                  final List<Ticket> tickets =
                                  snapshot.data as List<Ticket>;
                                  return ListView.separated(
                                    separatorBuilder: (_, __) =>
                                    const Divider(),
                                    itemBuilder: (_, i) => tickets[i],
                                    itemCount: tickets.length,
                                  );
                                }
                              }
                          }
                        },
                      ),
                    )
                  ],
                ),
                margin: EdgeInsets.only(left: 15, right: 15),
              ),
            ),
          )
        ],
      ),
    );
  }

  void updateList() {
    tickets = getOpenedTickets(context);
    setState(() {

    });
  }

  Future<List<Ticket>> getOpenedTickets(BuildContext context) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final User? user = Provider
        .of<AuthRepository>(context, listen: false)
        .user;
    var tickets = <Ticket>[];

    await _firestore
        .collection("${user?.uid} tickets")
        .get()
        .then((collection) async {
      for (var element in collection.docs) {
        try {
          await element.data()['ref'].get().then((value) {
            if (value == null) return;
            var data = value.data();
            switch (element.data()['category']) {
              case GlobalStringText.tagFood:
                {
                  var ticket = Ticket(
                    data['Title'],
                    data['Description'],
                    data['Time'],
                    Colors.white,
                    data['Location'],
                    data['Owner'],
                    type: data['Type'],
                    isOpenedTicket: true,
                    ref: element.data()['ref'],
                    update: updateList,
                  );
                  tickets.add(ticket);
                }
                break;
              case GlobalStringText.tagEntertainment:
                {
                  var ticket = Ticket(
                    data['Title'],
                    data['Description'],
                    data['Time'],
                    Colors.white,
                    data['Location'],
                    data['Owner'],
                    type: data['Type'],
                    isOpenedTicket: true,
                    ref: element.data()['ref'],
                    update: updateList,
                  );
                  tickets.add(ticket);
                }
                break;
              case GlobalStringText.tagCarPool:
                {
                  var ticket = Ticket(
                    data['Title'],
                    data['Description'],
                    data['Time'],
                    Colors.white,
                    data['Location'],
                    data['Owner'],
                    dest: data['Destination'],
                    isOpenedTicket: true,
                    ref: element.data()['ref'],
                    update: updateList,
                  );
                  tickets.add(ticket);
                }
                break;
              case GlobalStringText.tagAcademicSupport:
                {
                  var ticket = Ticket(
                    data['Title'],
                    data['Description'],
                    data['Time'],
                    Colors.white,
                    data['Location'],
                    data['Owner'],
                    course: data['CourseNum'],
                    isOpenedTicket: true,
                    ref: element.data()['ref'],
                    update: updateList,
                  );
                  tickets.add(ticket);
                }
                break;
              case GlobalStringText.tagStudyBuddy:
                {
                  var ticket = Ticket(
                    data['Title'],
                    data['Description'],
                    data['Time'],
                    Colors.white,
                    data['Location'],
                    data['Owner'],
                    course: data['CourseNum'],
                    isOpenedTicket: true,
                    ref: element.data()['ref'],
                    update: updateList,
                  );
                  tickets.add(ticket);
                }
                break;
              case GlobalStringText.tagMaterial:
                {
                  var ticket = Ticket(
                    data['Title'],
                    data['Description'],
                    data['Time'],
                    Colors.white,
                    data['Location'],
                    data['Owner'],
                    course: data['CourseNum'],
                    isOpenedTicket: true,
                    ref: element.data()['ref'],
                    update: updateList,
                  );
                  tickets.add(ticket);
                }
                break;
              default:
                {
                  tickets.add(
                      Ticket("_title", "_desc", "14:30", Colors.white, '', ''));
                }
            }
          });
        } catch (e) {}
      }
    });
    return tickets;
  }
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'ScreenTags.dart';
import 'package:studenthub/Auth.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'events_page.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  _FavoritesPage createState() => _FavoritesPage();
}

class _FavoritesPage extends State<FavoritesPage> {
  late Future<List<favoriteTicket>> tickets;
  late List<favoriteTicket> local_tickets;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tickets = getFavoriteTickets(context);
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
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.2,
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
                        Navigator.popUntil(context, (route) => route.isFirst);

                      },
                      icon: Image.asset("images/logout.png"),
                      iconSize: 40,
                    )
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
              height: MediaQuery.of(context).size.height * 0.8,
              width: MediaQuery.of(context).size.width,
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
                          "images/favorites.png",
                          height: 72,
                          width: 72,
                        ),
                        Text(
                          "Favorites",
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
                                  return Center(child: Text("Error ${snapshot.error}"));
                                } else {
                                  local_tickets = snapshot.data as List<favoriteTicket>;
                                  return ListView.separated(
                                    itemBuilder: (context, i) {
                                      return local_tickets[i];
                                    },
                                    itemCount: local_tickets.length,
                                    separatorBuilder: (BuildContext context, int index) => const Divider(),
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

  void updatelist(int id) {
    setState(() {
      local_tickets.removeWhere((element) {
        return element.notification_id == id;
      });
    });
  }

  Future<List<favoriteTicket>> getFavoriteTickets(BuildContext context) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final User? user = Provider.of<AuthRepository>(context, listen: false).user;
    var tickets = <favoriteTicket>[];

    await _firestore
        .collection("${user?.uid} favorites")
        .get()
        .then((collection) async {
      for (var element in collection.docs) {
        try {
          await element.data()['ref'].get().then((value) {
            var data = value.data();
            tickets.add(
                favoriteTicket(data['Title'], data['Time'], data['Location'], element.data()['id'], updatelist)
            );
          });
        } catch (e) {}
      }
    });
    return tickets;
  }
}

typedef Void2IntFunc = void Function(int);

///Add the structure of the favorites tickets
class favoriteTicket extends StatefulWidget {
  final String _time;
  final String _title;
  final String _location;
  final int notification_id;
  final Void2IntFunc removeFromList;

  const favoriteTicket(this._title, this._time, this._location, this.notification_id, this.removeFromList, {Key? key})
      : super(key: key);

  @override
  _favoriteTicketState createState() => _favoriteTicketState();
}

class _favoriteTicketState extends State<favoriteTicket> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
          Text(
            widget._title,
            maxLines: 2,
            style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6769EC)),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Event at " + widget._time ,
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            widget._location,
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
            height: 5,
          ),
          Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Image.asset("images/delete.png"),
                onPressed: removeFavorite,
              )),
        ],
      ),
    );
  }

  void removeFavorite() {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final User? user = Provider.of<AuthRepository>(context, listen: false).user;
    _firestore.collection("${user?.uid} favorites").where('id', isEqualTo: widget.notification_id).get().then((collection) => {
      collection.docs.forEach((element) {
        element.reference.delete();
      })
    });
    widget.removeFromList(widget.notification_id);
  }
}





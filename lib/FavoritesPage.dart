import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'ScreenTags.dart';
import 'package:studenthub/Auth.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  _FavoritesPage createState() => _FavoritesPage();
}

class _FavoritesPage extends State<FavoritesPage> {
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
                      child: getfavoriteTickets(),
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
}

///Add the structure of the favorites tickets
class favoriteTicket extends StatefulWidget {
  final String _time;
  final String _title;

  const favoriteTicket(this._title, this._time,  {Key? key})
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
          Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Image.asset("images/delete.png"),
                onPressed: () {},
              )),
        ],
      ),
    );
  }
}

Widget getfavoriteTickets() {
  return ListView.separated(
    itemBuilder: (context, i) {
      return favoriteTicket("_title", "14:30");
    },
    itemCount: 10,separatorBuilder: (BuildContext context, int index) => const Divider(),
  );
}



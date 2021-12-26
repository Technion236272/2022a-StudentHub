
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'ScreenTags.dart';
import 'events_page.dart';

class OpenedTicketsPage extends StatefulWidget {
  const OpenedTicketsPage({Key? key}) : super(key: key);

  @override
  _OpenedTicketsPage createState() => _OpenedTicketsPage();
}

class _OpenedTicketsPage extends State<OpenedTicketsPage> {
  @override
  Widget build(BuildContext context) {
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
                          onPressed: () {},
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
                      child: getOpenedTickets(),
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

///
Widget getOpenedTickets() {
  return ListView.separated(
    separatorBuilder: (BuildContext context, int index) => const Divider(),
    itemBuilder: (context, i) {
      return Ticket("title","aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa","14:30",Colors.blue,"22.02.2022",true);
    },
    itemCount: 10,
  );
}

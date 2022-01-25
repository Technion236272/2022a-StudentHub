import 'package:badges/badges.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter/services.dart';
import 'package:line_icons/line_icons.dart';
import 'ScreenTags.dart';
import 'package:google_fonts/google_fonts.dart';
import 'chatScreen.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'FavoritesPage.dart';
import 'package:studenthub/CatogryHomePage.dart';

import 'chat_backend.dart';



class ChatModel {
  String name;
  bool isGroup;
  String time;
  String currentMessage;
  bool isRead;
  String uid;
  bool? mute;

  ChatModel({
    required this.name,
    required this.isGroup,
    required this.time,
    required this.currentMessage,
    required this.isRead,
    required this.uid,
    this.mute
  });

  factory ChatModel.fromJson(dynamic json) {
    var time = DateTime.fromMillisecondsSinceEpoch((json['time'] as Timestamp).millisecondsSinceEpoch, isUtc: true).toLocal();
    var now = DateTime.now();
    String timePrefix = '';
    if(time.day < now.day) {
      timePrefix = '${time.day.toString().padLeft(2,'0')}/${time.month.toString().padLeft(2,'0')} , ';
    }
    String timeFormat = '$timePrefix${time.hour.toString().padLeft(2,'0')}:${time.minute.toString().padLeft(2,'0')}';
    return ChatModel(
        name: json['name'], isGroup: false, isRead: json['isRead'] ?? true, time: timeFormat, currentMessage: json['lastMessage'], uid: (json as DocumentSnapshot).id);
  }

  factory ChatModel.group(DocumentSnapshot snapshot) {
    var time = DateTime.fromMillisecondsSinceEpoch((snapshot['time'] as Timestamp).millisecondsSinceEpoch, isUtc: true).toLocal();
    var now = DateTime.now();
    String timePrefix = '';
    if(time.day < now.day) {
      timePrefix = '${time.day.toString().padLeft(2,'0')}/${time.month.toString().padLeft(2,'0')} , ';
    }
    String timeFormat = '$timePrefix${time.hour.toString().padLeft(2,'0')}:${time.minute.toString().padLeft(2,'0')}';
    return ChatModel(
        mute: snapshot['mute'], name: snapshot['title'], isGroup: true, isRead: snapshot['isRead'] ?? true, time: timeFormat, currentMessage: snapshot['lastMessage'], uid: snapshot.id);
  }
}

class inboxScreen extends StatefulWidget {

 bool? group;
 inboxScreen({bool? this.group});

  @override
  _inboxScreen createState() => _inboxScreen();
}

class _inboxScreen extends State<inboxScreen>
    with SingleTickerProviderStateMixin {
  late TabController _controller;
  double gap = 10;
  int selectedIndex = 2;
  int badge = 0;
  final padding = EdgeInsets.symmetric(horizontal: 18, vertical: 12);
  bool _isVisible = true;
  ScrollController scrollController = ScrollController();


  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this, initialIndex: widget.group == null? 0:1);
    Chat.init(context);
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent == scrollController.position.pixels) {
        if (_isVisible == true) {
          setState(() {
            _isVisible = false;
          });
        }
      } else if (scrollController.position.maxScrollExtent != scrollController.position.pixels) {
        if (_isVisible == false) {
          setState(() {
            _isVisible = true;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,

      appBar: appBarComponent(context),
      body: body(context),
      floatingActionButton: Visibility(child: buildBottomNavigationBar(), visible: _isVisible,),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

    ), onWillPop: () {
      Navigator.of(context).pushNamedAndRemoveUntil('/Home', (route) => false);
      return Future.value(false);
    },);
  }

  PreferredSizeWidget appBarComponent(context) {
    return PreferredSize(child:
    SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.2,
          color: Color(0xFF8C88F9),
          child: Column(
            children: <Widget>[
              Padding(child : Row(
                children: <Widget>[
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil('/Home', (route) => route.isFirst);
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      )),
                  //  new Spacer(),
                  Text(
                    "Your Inbox",
                    maxLines: 1,
                    textAlign: TextAlign.left,
                    style: GoogleFonts.quicksand(textStyle:TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 25,
                        color: GlobalStringText.whiteColor),),
                  )
                ],
              ), padding: EdgeInsets.only(top: 5, right: 60)),



            ],
          ),
        )),

      preferredSize:const Size.square(kToolbarHeight),

    );
  }

  Widget body(context)
  {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
      color: Theme.of(context).canvasColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: TabBar(
              controller: _controller,
              indicatorColor: Colors.white60,
              indicatorWeight: 5,
              tabs: const [
                Tab(text: 'Chats'),
                Tab(text: 'Group Chats',)

              ] ), color: Color(0xFF8C88F9),),
         Expanded(child: TabBarView(
             controller: _controller,
             children: <Widget> [
               StreamBuilder(stream: Chat.getChats(), builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                 switch (snapshot.connectionState) {
                   case ConnectionState.waiting:
                     {
                       return const Center(child: Text("Loading"));
                     }
                   default:
                     {
                       if (snapshot.hasError) {
                         return Center(child: Text("Error: ${snapshot.error}"));
                       } else {
                         List list = (snapshot.data as QuerySnapshot).docs;
                         return ListView.builder(
                           itemCount: list.length,
                           reverse: false,
                           physics: const BouncingScrollPhysics(),
                           itemBuilder: (context, i) => chatItemComponent(ChatModel.fromJson(list[i]), context),
                         );
                       }
                     }
                 }
               },),
               StreamBuilder(stream: Chat.getGroupChats(), builder: (context, snapshot) {
                 switch (snapshot.connectionState) {
                   case ConnectionState.waiting:
                     {
                       return const Center(child: Text("Loading"));
                     }
                   default:
                     {
                       if (snapshot.hasError) {
                         return Center(child: Text("Error: ${snapshot.error}"));
                       } else {
                         List list = (snapshot.data as QuerySnapshot).docs;
                         list.removeWhere((element) {
                           if ((element as DocumentSnapshot<Map<String,dynamic>>).data() == null) return true;
                           return !((element as DocumentSnapshot<Map<String,dynamic>>).data()!.containsKey('isRead'));
                         });
                         return ListView.builder(
                           itemCount: list.length,
                           reverse: false,
                           physics: const BouncingScrollPhysics(),
                           itemBuilder: (context, i) => chatItemComponent(ChatModel.group(list[i]), context),
                         );
                       }
                     }
                 }
               }),
             ]))


      ],) ,
    );
  }

  Widget chatListComponent(List<ChatModel> chats) {
    return ListView.builder(
        itemCount: chats.length,
        reverse: false,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, i) => chatItemComponent(chats[i], context),
    );
  }


  Widget chatItemComponent(ChatModel chat, context) {
    final group = false; // this is for testing only

    final mWidth = MediaQuery.of(context).size.width;
    final width = chat.currentMessage.length > mWidth / 7 ? mWidth / 1.3 : null;
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed('/Home/Inbox/Chat', arguments: {
          'uid' : chat.uid,
          'isGroup' : chat.isGroup,
          'name' : chat.name,
          'mute' : chat.mute
        });
      },

      child:
      Column(children: [
        ListTile(
          leading:  CircleAvatar(
            radius: 30,
            child: showIcon(chat.isGroup),
            backgroundColor:   Color.fromRGBO(143, 148, 251, 1),

          ),
          title: Text(
            chat.name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Row(
            children: [
              Icon(Icons.done),
              SizedBox(
                width: 3,
              ),
              Text(
                chat.currentMessage,
                style: TextStyle(
                  fontWeight: chat.isRead? FontWeight.normal : FontWeight.bold,
                  fontSize: chat.isRead? 14 : 16,
                ),
              ),
            ],
          ),
          trailing: Text(chat.time),
        ),
        const Padding(
          padding: EdgeInsets.only(right: 20, left: 20),
          child: Divider(
            thickness: 1,
          ),
        ),
      ],),
    );

  }

  Widget showIcon(flag)
  {
    if(flag) {
      return Icon(LineIcons.userFriends,size: 30,color :Colors.white);
    } else {
      return Icon(LineIcons.user,size: 30,color: Colors.white,);
    }
  }

  Widget buildBottomNavigationBar() {
    return SafeArea(
      top: true,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
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
                    Navigator.of(context).pushNamedAndRemoveUntil('/Home/Favorites', (route) => false);
                    break;
                  case 1 :
                    Navigator.of(context).pushNamedAndRemoveUntil('/Home', (route) => route.isFirst);
                    break;
                  case 2 :
                    break;
                }
              });
            },
          ),
        ),
      ),
    );
  }


}
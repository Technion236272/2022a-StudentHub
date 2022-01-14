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

final _firestore = FirebaseFirestore.instance;
User? loggedInuser;
final focusNode = FocusNode();

class ChatScreen extends StatefulWidget {
  static String id = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  bool isEmojiVisible = false;
  bool isKeyboardVisible = false;
  var messageText;

  @override
  void initState() {
    super.initState();
    var keyboardVisibilityController = KeyboardVisibilityController();
    keyboardVisibilityController.onChange.listen((bool isKeyboardVisible) {
      setState(() {
        this.isKeyboardVisible = isKeyboardVisible;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBarComponent(context),
      body: body(context),
    );
  }

  PreferredSizeWidget appBarComponent(context) {
   // final theme = Theme.of(context);
    return PreferredSize(
      preferredSize: const Size.square(kToolbarHeight),
      child: Container(
        height: 90,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 16,
              color: GlobalStringText.purpleColor.withOpacity(.24),
              offset: Offset(0, 4),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 90,
              width: 90,
              padding: EdgeInsets.only(top: 20, right: 100),
              child: IconButton(
                icon: Icon(Icons.arrow_back,
                    size: 28, color: GlobalStringText.purpleColor),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 25, right: 60),
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: Row(children:
                [
                  Icon(LineIcons.user),
                  SizedBox(width: 5,),
                  Text(
                  "Raja Zidane",
                  maxLines: 1,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: GlobalStringText.purpleColor),
                ),],)
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget body(context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
      color: Theme.of(context).canvasColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          messageListComponent([
            MessageModel(id: '1', sender: 'Raja', text: 'Hi', me: true),
            MessageModel(id: '2', sender: 'Mostafa', text: 'Hi', me: false),
            MessageModel(
                id: '3',
                sender: 'Mostafa',
                text:
                    'Hi , when are we meeting aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa ? ',
                me: false),
            MessageModel(id: '4', sender: 'Mostafa', text: 'message3', me: false),
            MessageModel(id: '5', sender: 'Mostafa', text: 'message 4', me: true),
            MessageModel(id: '5', sender: 'Mostafa', text: 'message 5', me: false),
            MessageModel(
                id: '6',
                sender: 'Mostafa',
                text:
                'Hi , when are we meeting aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa ? ',
                me: true),
            MessageModel(
                id: '6',
                sender: 'Mostafa',
                text:
                'Hi , when are we meeting aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa ? ',
                me: true),
            MessageModel(
                id: '6',
                sender: 'Mostafa',
                text:
                'Hi , when are we meeting aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa ? ',
                me: true),
            MessageModel(
                id: '6',
                sender: 'Mostafa',
                text:
                'Hi , when are we meeting aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa ? ',
                me: true),
            MessageModel(
                id: '6',
                sender: 'Mostafa',
                text:
                'Hi , when are we meeting aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa ? ',
                me: true),
          ]),
          createMessageInputComponent(context)
        ],
      ),
    );
  }

  Widget messageListComponent(List<MessageModel> messages) {
    return Expanded(
      flex: 1,
      child: ListView.builder(
        itemCount: messages.length,
        reverse: false,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, i) => messageItemComponent(messages[i], context),
      ),
    );
  }

  Widget messageItemComponent(MessageModel message, context) {
    final group = false; // this is for testing only
    double marginL = message.me ? 25 : 15;
    double marginR = message.me ? 15 : 25;
    final mWidth = MediaQuery.of(context).size.width;
    final width = message.text.length > mWidth / 7 ? mWidth / 1.3 : null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment:
          message.me ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.fromLTRB(marginL, 10, marginR, 10),
          decoration: BoxDecoration(
            color: message.me ? GlobalStringText.purpleColor : Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            width: width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (group && !message.me) ...[
                  Text(
                    "Raja", // should be ${message.sender.name}
                    style: TextStyle(color: Colors.grey[800]),
                  ),
                  Container(margin: EdgeInsets.only(top: 5))
                ],
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      message.text,
                      style: TextStyle(
                        color: message.me ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                  ],
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget createMessageInputComponent(context) {

    return Align(

      child: Container(
        color: Colors.transparent,
        padding: EdgeInsets.fromLTRB(15, 10, 5, 1),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: TextField(
                controller: messageController,
                style: GoogleFonts.roboto(
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                decoration: InputDecoration(
                    filled: true,
                    fillColor: GlobalStringText.textFieldColor,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(30.0),
                      borderSide:  BorderSide(color: GlobalStringText.textFieldGrayColor ),

                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(30.0),
                      borderSide:  BorderSide(color: GlobalStringText.textFieldGrayColor  ),

                    ),
                    hintText: "Tap to send a message",
                    hintStyle: GoogleFonts.roboto(
                      textStyle: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 18,
                        fontFamily: "Roboto",
                        fontWeight: FontWeight.w400,
                      ),
                    )),
              ),
            ),
           Padding(child :  FloatingActionButton(
               onPressed: null,
               backgroundColor: GlobalStringText.textFieldColor,
               child:  const Icon(
                 Icons.send_sharp,
                 color: Colors.deepPurpleAccent,
                 size: 30,
               )),padding: const EdgeInsets.only(left: 10.0),
      )
            // createMessageMutationComponent(context)
          ],
        ),

      ),
    );
  }
}

class MessageListModel {
  final String chatId;

  final List<MessageModel> messages;

  MessageListModel({required this.chatId, required this.messages});

  factory MessageListModel.fromJson(Map<String, dynamic> json) {
    List msg = json['messages'];
    var messages = msg.map((item) => MessageModel.fromJson(item));
    return MessageListModel(chatId: json['id'], messages: messages.toList());
  }
}

class MessageModel {
  final String id;
  final String sender;
  final String text;
  final bool me;

  MessageModel(
      {required this.id,
      required this.sender,
      required this.text,
      required this.me});

  factory MessageModel.fromJson(dynamic json) {
    // User sender = User.fromJson(json['sender']);
    return MessageModel(
        id: json['id'], text: json['text'], me: json['me'], sender: 'raja');
  }
}

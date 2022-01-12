


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

import 'Auth.dart';

class Chat {
  static List chats = [];
  static List messages = [];
  static late User? user;
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  static void init(context) {
    user = Provider.of<AuthRepository>(context, listen: false).user;
  }

  static Future<void> send(String message, String receiverUid, {String? name}) async {
    final ref = await firestore.collection('messages').add({
      'sender' : user!.uid,
      'message' : message,
      'timeStamp' : Timestamp.now()
    });
    if(name != null) {
      firestore.collection('${user!.uid} chats').doc(receiverUid).set({'name': name});
      firestore.collection('${receiverUid} chats').doc(user!.uid).set({'name': user!.displayName});
    }
    firestore.collection('${user!.uid} chats').doc(receiverUid).collection(name!).add({
      'ref' : ref
    });
    firestore.collection('${receiverUid} chats').doc(user!.uid).collection(user!.displayName!).add({
      'ref' : ref
    });
  }

  static Future<void> getChats() async {
    if (user == null) {
      //do something
      return;
    }
    chats = [];
    await firestore.collection('${user!.uid} chats').get().then((value) {
      var i = 0;
      for (var element in value.docs) {
        i++;
        chats.add({
          'uid' : element.id,
          'name' : element.data()['name'],
          'messages' : element.reference.collection('message refs')
        });
      }
    });
  }


  static Future<void> getMessages(CollectionReference collection) async {
    messages = [];
    await collection.get().then((value) async {
      for (var element in value.docs) {
        Map<String, dynamic> ref = element.data() as Map<String, dynamic>;
        await ref['ref'].get().then((value) {
          messages.add(value.data() as Map<String, dynamic>);
        });
      }
    }).then((value) {
    });

  }

}
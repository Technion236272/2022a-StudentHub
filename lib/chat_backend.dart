


import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:studenthub/inboxScreen.dart';

import 'Auth.dart';

class Chat {
  static List chats = [];
  static List groups = [];
  static List messages = [];
  static late User? user;
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  static void init(context) {
    user = Provider.of<AuthRepository>(context, listen: false).user;
  }

  static void send(String message, String receiverUid, String name) {
    final timeStamp = Timestamp.now();
    var ids = [user!.uid, receiverUid];
    ids.sort();
    firestore.collection('chats/${ids[0]}-${ids[1]}/messages').add({
      'senderId' : user!.uid,
      'senderName' : user!.displayName,
      'message' : message,
      'timeStamp' : timeStamp,
    });
    firestore.collection('users/${user!.uid}/chats').doc(receiverUid).set({'name': name, 'lastMessage' : message, 'time' : timeStamp, 'isRead' : true});
    firestore.collection('users/$receiverUid/chats').doc(user!.uid).set({'name': user!.displayName, 'lastMessage' : message, 'time' : timeStamp, 'isRead' : false});
  }

  static Stream<QuerySnapshot<Map<String,dynamic>>> getChats()  {
    return firestore.collection('users/${user!.uid}/chats').orderBy('time').snapshots();
  }


  static Stream<QuerySnapshot<Map<String,dynamic>>> getMessages(String uid) {
    var ids = [user!.uid, uid];
    ids.sort();
    firestore.collection('users/${user!.uid}/chats').doc(uid).set({'isRead' : true});
    return firestore.collection('chats/${ids[0]}-${ids[1]}/messages').orderBy('timeStamp', descending: true).snapshots();
  }

  static void sendGroup(String message, String groupId) {
    final timeStamp = Timestamp.now();
    firestore.collection('chats/$groupId/messages').add({
      'senderId' : user!.uid,
      'senderName' : user!.displayName,
      'message' : message,
      'timeStamp' : timeStamp,
    });
    firestore.collection('chats').doc(groupId).set({'subs' : FieldValue.arrayUnion([user!.uid])}, SetOptions(merge: true));
    firestore.collection('chats').doc(groupId).get().then((value) {
      List<dynamic> subs = value.data()?['subs'];
      for (var element in subs) {
        firestore.collection('users/${element as String}/groups').doc(groupId).set({'lastMessage' : message, 'time' : timeStamp, 'isRead' : false});
      }
    });
    firestore.collection('users/${user!.uid}/groups').doc(groupId).set({'isRead' : true});
  }

  static Stream<QuerySnapshot<Map<String,dynamic>>> getGroupChats()  {
    return firestore.collection('users/${user!.uid}/groups').orderBy('time').snapshots();
  }


  static Stream<QuerySnapshot<Map<String,dynamic>>> getGroupMessages(String groupId) {
    return firestore.collection('chats/$groupId/messages').snapshots();
  }

}
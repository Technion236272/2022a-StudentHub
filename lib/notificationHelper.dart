import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'as notifs;
import 'package:rxdart/subjects.dart' as rxSub;
import 'main.dart';

class NotificationClass{
  final int id;
  final String? title;
  final String? body;
  final String? payload;
  NotificationClass({required this.id, required this.body, required this.payload, required this.title});
}

final rxSub.BehaviorSubject<NotificationClass> didReceiveLocalNotificationSubject =
rxSub.BehaviorSubject<NotificationClass>();
final rxSub.BehaviorSubject<String> selectNotificationSubject =
rxSub.BehaviorSubject<String>();

Future<void> initNotifications(
    notifs.FlutterLocalNotificationsPlugin
    notifsPlugin) async {
  var initializationSettingsAndroid =
  notifs.AndroidInitializationSettings('icon');
  var initializationSettingsIOS = notifs.IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {
        didReceiveLocalNotificationSubject
            .add(NotificationClass(id: id, title: title, body: body, payload: payload));
      });
  var initializationSettings = notifs.InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  await notifsPlugin.initialize(initializationSettings,
      onSelectNotification: (String? payload) async {
        selectNotificationSubject.add(payload!);
      });
}


Future<void> scheduleNotification(
    notifs.FlutterLocalNotificationsPlugin notifsPlugin,
      String id,
      String title,
      String body,
      DateTime scheduledTime,
      int not_id) async {
  var androidSpecifics = notifs.AndroidNotificationDetails(
    id, // This specifies the ID of the Notification
    'Scheduled notification', // This specifies the name of the notification channel
    channelDescription: 'A scheduled notification', //This specifies the description of the channel
    icon: 'icon',
    priority: Priority.high,
    importance: Importance.max
  );
  var iOSSpecifics = notifs.IOSNotificationDetails();
  var platformChannelSpecifics = notifs.NotificationDetails(
      android: androidSpecifics, iOS: iOSSpecifics);
  await notifsPlugin.schedule(not_id, title, body,
      scheduledTime, platformChannelSpecifics); // This literally schedules the notification
  ///the id is a global int from main check if there is other solution to identify the notification

}

Future<void> turnOffNotification(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
  await flutterLocalNotificationsPlugin.cancelAll();
}

Future<void> turnOffNotificationById(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    int id) async {
  await flutterLocalNotificationsPlugin.cancel(id);
}
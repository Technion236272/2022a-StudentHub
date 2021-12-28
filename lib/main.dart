import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'CatogryHomePage.dart';
import 'HomePage.dart';
import 'Auth.dart';
import 'GenericPageCreation.dart';
import 'notificationHelper.dart';
import 'events_page.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin notifsPlugin =
    FlutterLocalNotificationsPlugin();

int notification_id = 0;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationAppLaunchDetails? notifLaunch =
      await notifsPlugin.getNotificationAppLaunchDetails();
  await initNotifications(notifsPlugin);

  runApp(App());
}

class App extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
              body: Center(
                  child: Text(snapshot.error.toString(),
                      textDirection: TextDirection.ltr)));
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return MyApp();
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthRepository.instance(),
      child: Consumer<AuthRepository>(
          builder: (context, auth, _) => MaterialApp(
                home: HomePage(),
              )),
    );
  }
}

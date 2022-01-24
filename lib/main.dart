import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studenthub/FavoritesPage.dart';
import 'package:studenthub/Login.dart';
import 'package:studenthub/ScreenTags.dart';
import 'package:studenthub/SignUp.dart';
import 'package:studenthub/openedTicketsPage.dart';
import 'package:studenthub/ticket_form_screen.dart';
import 'CatogryHomePage.dart';
import 'HomePage.dart';
import 'Auth.dart';
import 'notificationHelper.dart';
import 'events_page.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:studenthub/chatScreen.dart';
import 'inboxScreen.dart';
import 'profilePage.dart';

final FlutterLocalNotificationsPlugin notifsPlugin =
    FlutterLocalNotificationsPlugin();
String? currentChatId;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationAppLaunchDetails? notifLaunch =
      await notifsPlugin.getNotificationAppLaunchDetails();
  await initNotifications(notifsPlugin);
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    importance: Importance.max,
  );
  await notifsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.getToken();
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    // If `onMessage` is triggered with a notification, construct our own
    // local notification to show to users using the created channel.
    if (notification != null && android != null && message.data['chatId'] != currentChatId) {
      notifsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              priority: Priority.max,
              icon: android.smallIcon,
            ),
          ));
    }
  });
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
            onGenerateRoute: (settings) {
                  switch (settings.name) {
                    case '/Home/Profile' : {
                      return MaterialPageRoute(builder: (_) => profilePage(userID: settings.arguments as String,));
                    }
                    case '/Home/Opened/Edit' : {
                      Map<String,dynamic> args = settings.arguments as Map<String,dynamic>;
                      return MaterialPageRoute(builder: (_) => NewPostScreen(args['category'], data: args['data'],));
                    }
                    case '/Home/Inbox/Chat' : {
                      Map<String,dynamic> args = settings.arguments as Map<String,dynamic>;
                      return MaterialPageRoute(builder: (_) => ChatScreen(args['uid'], args['isGroup'], args['name']));
                    }
                  }
            },
            routes:   {
                '/Auth' : (context) => HomePage(),
                '/Auth/Login' : (context) => LoginScreen(),
                '/Auth/Signup' : (context) => SignUpScreen(),
                '/Home' : (context) => const CategoryPageScreen(),
                '/Home/Favorites' : (context) => const FavoritesPage(),
                '/Home/Inbox' : (context) => inboxScreen(),
                '/Home/Opened' : (context) => const OpenedTicketsPage(),
                '/Home/Entertainment' : (context) => const EventsPage(category: GlobalStringText.tagEntertainment,),
                '/Home/CarPool' : (context) => const EventsPage(category: GlobalStringText.tagCarPool,),
                '/Home/Food' : (context) => const EventsPage(category: GlobalStringText.tagFood,),
                '/Home/AcademicSupport' : (context) => const EventsPage(category: GlobalStringText.tagAcademicSupport,),
                '/Home/StudyBuddy' : (context) => const EventsPage(category: GlobalStringText.tagStudyBuddy,),
                '/Home/Material' : (context) => const EventsPage(category: GlobalStringText.tagMaterial,),
                '/Home/Entertainment/Create' : (context) => NewPostScreen(GlobalStringText.tagEntertainment,),
                '/Home/CarPool/Create' : (context) => NewPostScreen(GlobalStringText.tagCarPool,),
                '/Home/Food/Create' : (context) => NewPostScreen(GlobalStringText.tagFood,),
                '/Home/AcademicSupport/Create' : (context) => NewPostScreen(GlobalStringText.tagAcademicSupport,),
                '/Home/StudyBuddy/Create' : (context) => NewPostScreen(GlobalStringText.tagStudyBuddy,),
                '/Home/Material/Create' : (context) => NewPostScreen(GlobalStringText.tagMaterial,),

            },
              )),
    );
  }
}

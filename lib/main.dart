import 'dart:async';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:thirdeyesmanagmentadmin/decision.dart';
import 'package:thirdeyesmanagmentadmin/messaging/permissions.dart';
import 'package:thirdeyesmanagmentadmin/screens/admin_home.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await setupFlutterNotifications();
  showFlutterNotification(message);

}

/// Create a [AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel channel;

bool isFlutterLocalNotificationsInitialized = false;

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }
  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
    'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  isFlutterLocalNotificationsInitialized = true;
}

void showFlutterNotification(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null && !kIsWeb) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          sound: const RawResourceAndroidNotificationSound('android_beep'),
          channelDescription: channel.description,
          icon: '@mipmap/ic_launcher',
        ),
      ),
    );
  }

}

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await FirebaseAppCheck.instance
      .activate(androidProvider: AndroidProvider.debug);
  if (!kIsWeb) {
    await setupFlutterNotifications();
  }

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MaterialApp(home: MyApp()));
  });
}


class MyApp extends StatefulWidget {


  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    const Permissions();
    FirebaseMessaging.onMessage.listen(showFlutterNotification);
    WidgetsBinding.instance.addPostFrameCallback(
            (_) => Future.delayed(const Duration(seconds: 3), () {
          userState();
        }));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return const MaterialApp(
      home: Scaffold(
          body: Center(child: CircularProgressIndicator())
      ),
    );
  }
  Future<void> userState() async {
    try {
      await FirebaseAuth.instance.currentUser?.reload();
      if (FirebaseAuth.instance.currentUser != null) {
        if(mounted){
          goAdminHome();
        }
      } else {
        if(mounted){
          moveToDecision();
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-disabled") {
        showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text("Account is disabled",
                  style: TextStyle(color: Colors.red)),
              content: const Text(
                  "Your account is disabled by admin or something went wrong?",
                  style: TextStyle(fontFamily: "Montserrat")),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                    },
                    child: const Text(
                      "Try again",
                      style: TextStyle(color: Colors.green),
                    ))
              ],
            ));
      }
    }
  }

  moveToDecision() {
    if (mounted) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const Decision(),
      ));
    }
  }

  void goAdminHome() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const AdminHome(),
        ),
            (route) => false);
  }
}




import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:thirdeyesmanagmentadmin/decision.dart';
import 'package:thirdeyesmanagmentadmin/screens/admin_home.dart';

import 'messaging/message.dart';


@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await setupFlutterNotifications();
  showFlutterNotification(message);
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  if (kDebugMode) {
    print('Handling a background message ${message.messageId}');
  }
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
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  if (!kIsWeb) {
    await setupFlutterNotifications();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      routes: {
        '/': (context) => const Application(),
        '/message': (context) => const MessageView(),
      },
    );
  }
}

// Crude counter to make messages unique
int _messageCount = 0;

String constructFCMPayload(String? token) {
  _messageCount++;
  return jsonEncode({
    'token': token,
    'data': {
      'via': 'FlutterFire Cloud Messaging!!!',
      'count': _messageCount.toString(),
    },
    'notification': {
      'title': 'Hello FlutterFire!',
      'body': 'This notification (#$_messageCount) was created via FCM!',
    },
  });
}

/// Renders the example application.
class Application extends StatefulWidget {
  const Application({super.key});

  @override
  State<StatefulWidget> createState() => _Application();
}

class _Application extends State<Application> {
  String? _token;
  String? initialMessage;
  bool resolved = false;

  @override
  void initState() {
    super.initState();

    FirebaseMessaging.instance.getInitialMessage().then(
          (value) => setState(
            () {
          resolved = true;
          initialMessage = value?.data.toString();
        },
      ),
    );

    FirebaseMessaging.onMessage.listen(showFlutterNotification);

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('A new onMessageOpenedApp event was published!');
      }
      Navigator.pushNamed(
        context,
        '/message',
        arguments: MessageArguments(message, true),
      );
    });
  }

  Future<void> sendPushMessage() async {
    if (_token == null) {
      if (kDebugMode) {
        print('Unable to send FCM message, no token exists.');
      }
      return;
    }

    try {
      await http.post(
        Uri.parse('https://api.rnfirebase.io/messaging/send'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: constructFCMPayload(_token),
      );
      if (kDebugMode) {
        print('FCM request for device sent!');
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> onActionSelected(String value) async {
    switch (value) {
      case 'subscribe':
        {
          if (kDebugMode) {
            print(
            'FlutterFire Messaging Example: Subscribing to topic "fcm_test".',
          );
          }
          await FirebaseMessaging.instance.subscribeToTopic('fcm_test');
          if (kDebugMode) {
            print(
            'FlutterFire Messaging Example: Subscribing to topic "fcm_test" successful.',
          );
          }
        }
        break;
      case 'unsubscribe':
        {
          if (kDebugMode) {
            print(
            'FlutterFire Messaging Example: Unsubscribing from topic "fcm_test".',
          );
          }
          await FirebaseMessaging.instance.unsubscribeFromTopic('fcm_test');
          if (kDebugMode) {
            print(
            'FlutterFire Messaging Example: Unsubscribing from topic "fcm_test" successful.',
          );
          }
        }
        break;
      case 'get_apns_token':
        {
          if (defaultTargetPlatform == TargetPlatform.iOS ||
              defaultTargetPlatform == TargetPlatform.macOS) {

            String? token = await FirebaseMessaging.instance.getAPNSToken();
            if (kDebugMode) {
              print('FlutterFire Messaging Example: Got APNs token: $token');
            }
          } else {
            if (kDebugMode) {
              print(
              'FlutterFire Messaging Example: Getting an APNs token is only supported on iOS and macOS platforms.',
            );
            }
          }
        }
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
            (_) => Future.delayed(const Duration(seconds: 2), () {
userState();
        }));
    return const Scaffold(
      body: Center(child: CircularProgressIndicator())
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


/// UI Widget for displaying metadata.
class MetaCard extends StatelessWidget {
  final String _title;
  final Widget _children;

  const MetaCard(this._title, this._children, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(left: 8, right: 8, top: 8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: Text(_title, style: const TextStyle(fontSize: 18)),
              ),
              _children,
            ],
          ),
        ),
      ),
    );
  }
}

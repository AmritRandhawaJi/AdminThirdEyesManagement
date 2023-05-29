import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:thirdeyesmanagmentadmin/decision.dart';
import 'package:thirdeyesmanagmentadmin/screens/admin_home.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await setupFlutterNotifications();

}

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

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  isFlutterLocalNotificationsInitialized = true;
}



/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await FirebaseAppCheck.instance
      .activate(webRecaptchaSiteKey: "6LcyEQMlAAAAAEnTIRZQiFDyeUzHJFVMYxFzIJ1l",
      androidProvider: AndroidProvider.debug);
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

 final db = FirebaseFirestore.instance;
  late Stream<String> _tokenStream;


  Future<void> setToken(String? token) async {
    try{
      await db.collection("accounts").doc("support@3rdeyesmanagement.in").update({
        "token" : token
      }).whenComplete(() => {
        goAdminHome()
      });
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Check Internet")));

    }


  }
@override
  void dispose() {
    db.terminate();
    super.dispose();
  }
  @override
  void initState() {
userState();
super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
          body: Center(child: CircularProgressIndicator(strokeWidth: 1,backgroundColor: Colors.black87,))
      ),
    );
  }
 void messaging() {

   try{
     FirebaseMessaging.instance
         .getToken(
         vapidKey:
         'BNKkaUWxyP_yC_lki1kYazgca0TNhuzt2drsOrL6WrgGbqnMnr8ZMLzg_rSPDm6HKphABS0KzjPfSqCXHXEd06Y')
         .then(setToken);
     _tokenStream = FirebaseMessaging.instance.onTokenRefresh;
     _tokenStream.listen(setToken);

   }catch(e){
     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Check Internet")));
   }


 }
  Future<void> userState() async {
    try {
      await FirebaseAuth.instance.currentUser?.reload();
      if (FirebaseAuth.instance.currentUser != null) {
        if(mounted){
        messaging();
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




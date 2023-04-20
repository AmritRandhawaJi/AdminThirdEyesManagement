import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:thirdeyesmanagmentadmin/screens/admin_login.dart';

class Decision extends StatefulWidget {
  const Decision({Key? key}) : super(key: key);

  @override
  State<Decision> createState() => _DecisionState();
}

class _DecisionState extends State<Decision> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: LayoutBuilder(
            builder:
                (BuildContext context, BoxConstraints viewportConstraints) {
              return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text("Welcome\n ",
                              style: TextStyle(
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22)),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text("3rd Eyes Management",
                              style: TextStyle(
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset("assets/decisionLogo.png"),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children:  [
                              AnimatedTextKit(
                                animatedTexts:  [
                                  TypewriterAnimatedText(
                                    'One\nApp\nFor\nAll Solution.',
                                    textStyle: const TextStyle(
                                      fontSize: 32.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    speed: const Duration(milliseconds: 100),
                                  ),
                                ],
                                totalRepeatCount: 1,
                                pause: const Duration(milliseconds: 100),
                                displayFullTextOnTap: true,
                                stopPauseOnTap: true,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 50),

                        const SizedBox(
                          height: 30,
                        ),
                        DelayedDisplay(
                          child: CupertinoButton(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.redAccent,
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const AdminLogin(),
                                    ));
                              },
                              child: const Text("Admin Login",style: TextStyle(fontFamily: "Montserrat"),)),
                        )
                      ]));
            },
          ),
        ),
      ),
    );
  }
}

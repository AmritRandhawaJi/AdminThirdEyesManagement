import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thirdeyesmanagmentadmin/screens/admin_home.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({Key? key}) : super(key: key);

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  var emailController = TextEditingController();
  final GlobalKey<FormState> _emailKey = GlobalKey<FormState>();
  var passwordController = TextEditingController();
  final GlobalKey<FormState> _passwordKey = GlobalKey<FormState>();
  bool showPassword = true;
  List<dynamic> list = [];
  final db = FirebaseFirestore.instance;
  bool loading = false;

  bool loader = false;

  @override
  void dispose() {
    db.terminate();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: DelayedDisplay(
            slidingCurve: Curves.bounceOut,
            child: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                colors: [Colors.blueGrey, Colors.white],
                begin: Alignment.topCenter,
                    end: Alignment.bottomCenter
              )),
              child: Column(
                children: <Widget>[
                  Image.asset("assets/admin.png",
                      height: MediaQuery.of(context).size.width - 50,
                      width: MediaQuery.of(context).size.width - 50),
                  Column(
                    children: [
                      Form(
                        key: _emailKey,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: TextFormField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Enter your email";
                              } else if (!EmailValidator.validate(
                                  emailController.value.text)) {
                                return "Email invalid";
                              } else {
                                return null;
                              }
                            },
                            showCursor: true,
                            decoration: InputDecoration(
                                filled: true,
                                hintText: "Email",
                                prefixIcon: const Icon(Icons.email_outlined,
                                    color: Colors.black54, size: 20),
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                )),
                          ),
                        ),
                      ),
                      Form(
                        key: _passwordKey,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: TextFormField(
                            obscureText: showPassword,
                            controller: passwordController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Enter password";
                              } else if (value.length < 8) {
                                return "8 characters required";
                              } else {
                                return null;
                              }
                            },
                            showCursor: true,
                            decoration: InputDecoration(
                                filled: true,
                                hintText: "Password",
                                prefixIcon: const Icon(Icons.lock_outline,
                                    color: Colors.black54, size: 20),
                                fillColor: Colors.white,
                                suffixIcon: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (showPassword) {
                                          showPassword = false;
                                        } else {
                                          showPassword = true;
                                        }
                                      });
                                    },
                                    child: Icon(
                                      Icons.remove_red_eye,
                                      color: showPassword
                                          ? Colors.grey
                                          : Colors.blueAccent,
                                    )),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                  loading
                      ? const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.blueAccent,
                        )
                      : Container(
                          height: 20,
                        ),
                  const SizedBox(height: 5),
                  CupertinoButton(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.green,
                      onPressed: loading
                          ? null
                          : () {
                              _authenticateUser();
                            },
                      child: const Text("Admin Login",
                          style: TextStyle(color: Colors.white))),
                ],
              ),
            )));
  }

  void _authenticateUser() {
    setState(() {
      loader = true;
    });

    if (_passwordKey.currentState!.validate() &
        _emailKey.currentState!.validate()) {
      setState(() {
        loading = true;
      });
      db
          .collection("accounts")
          .doc(emailController.value.text.toLowerCase())
          .get()
          .then((value) => {
                if (value.exists)
                  {
                    if (value.get("adminAccess"))
                      {
                        _login(emailController.value.text,
                            passwordController.value.text)
                      }
                  }
                else
                  {
                    showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                              title: const Text("No Admin",
                                  style: TextStyle(color: Colors.red)),
                              content: const Text(
                                  "You are not admin please use admin account to login or something went wrong?",
                                  style: TextStyle(fontFamily: "Montserrat")),
                              actions: <Widget>[
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(ctx);
                                      setState(() {
                                        loading = false;
                                      });
                                    },
                                    child: const Text(
                                      "Try again",
                                      style: TextStyle(color: Colors.green),
                                    ))
                              ],
                            ))
                  }
              });
    }
  }

  Future<void> _login(String emailAddress, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailAddress, password: password);
      _loggedIn();
    } on FirebaseAuthException catch (e) {
      setState(() {
        loading = false;
      });
      if (e.code == 'user-not-found') {
        error("User not found", "Your account is not registered");
      } else if (e.code == 'user-disabled') {
        error("User Disabled", 'User is disabled by admin');
      } else if (e.code == "wrong-password") {
        error("Wrong Password", 'Password is incorrect');
      } else if (e.code == "too-many-requests") {
        error("Too many attempts",
            "Account is temporary disabled\nto activate your account again Reset your password");
      }
    }
  }

  Future error(String title, String description) {
    return showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text(title),
              content: Text(description),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                      },
                      child: const Text("OK"),
                    )),
              ],
            ));
  }

  void _loggedIn() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const AdminHome(),
        ),
        (route) => false);
  }
}

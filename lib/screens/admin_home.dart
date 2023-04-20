import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:thirdeyesmanagmentadmin/all_sale.dart';
import 'package:thirdeyesmanagmentadmin/decision.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  final searchController = TextEditingController();
  final GlobalKey<FormState> searchKey = GlobalKey<FormState>();
  String dropDownValue = 'Azon Spa';

  String month = DateFormat.MMMM().format(DateTime.now());
  DateTime years = DateTime.now();

  bool panelLoad = false;

  bool panelLoading = false;
  int walkinCash = 0;
  int walkinCard = 0;
  int walkinUPI = 0;
  int walkinWallet = 0;
  int membershipCash = 0;
  int memberShipCard = 0;
  int memberShipUPI = 0;
  int memberShipWallet = 0;
  int members = 0;

  var items = [
    'Azon Spa',
    'Heritage Spa',
    'The Annandam Unisex Spa',
    'Wave Spa',
  ];

  final dateController = TextEditingController();

  final db = FirebaseFirestore.instance;

  bool loadingIndicator = false;

  DateTime selectedDate = DateTime.now();

  @override
  void dispose() {
    db.terminate();
    super.dispose();
  }

  @override
  void initState() {
    dateController.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double panelHeightOpen = MediaQuery
        .of(context)
        .size
        .height / 2;
    double panelHeightClosed = MediaQuery
        .of(context)
        .size
        .height / 7;
    return Scaffold(
        backgroundColor: CupertinoColors.lightBackgroundGray,
        resizeToAvoidBottomInset: false,
        body: Stack(children: <Widget>[
          SlidingUpPanel(
            maxHeight: panelHeightOpen,
            minHeight: panelHeightClosed,
            parallaxEnabled: true,
            parallaxOffset: .5,
            body: _body(),
            collapsed: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(30)),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    children: const [
                      Icon(Icons.graphic_eq_outlined, color: Colors.green),
                      Text(
                        "Today's Sale",
                        style:
                        TextStyle(fontSize: 18, fontFamily: "Montserrat"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            panelBuilder: (sc) => _panel(sc),
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18.0),
                topRight: Radius.circular(18.0)),
            onPanelSlide: (double pos) => setState(() {}),
          )
        ]));
  }

  _body() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Hello, Admin",
                    style: TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                      onTap: () async {
                        showDialog(
                          context: context,
                          builder: (context) =>
                              AlertDialog(
                                title: const Text("Sign-Out"),
                                content: const Text(
                                    "Would you like to Sign-out?",
                                    style: TextStyle(color: Colors.red)),
                                actions: [
                                  TextButton(
                                      onPressed: () async {
                                        try {
                                          await FirebaseAuth.instance
                                              .signOut()
                                              .whenComplete(() =>
                                          {
                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                  const Decision(),
                                                ),
                                                    (route) => false)
                                          });
                                        } catch (e) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                              content: Text(
                                                  "Something went wrong")));
                                        }
                                      },
                                      child: const Text("Yes",
                                          style: TextStyle(color: Colors.red))),
                                  TextButton(
                                      onPressed: () async {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("No",
                                          style: TextStyle(
                                              color: Colors.green)))
                                ],
                              ),
                        );
                      },
                      child: const Icon(
                        Icons.power_settings_new_rounded,
                        size: 30,
                      ))
                ],
              ),
            ),
            DelayedDisplay(
              child: Form(
                key: searchKey,
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: TextFormField(
                    showCursor: false,
                    maxLength: 10,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    controller: searchController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter number";
                      } else if (value.length < 10) {
                        return "Enter 10 digits";
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        counterText: "",
                        suffixIcon: Stack(
                          alignment: Alignment.center,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  if (searchKey.currentState!.validate()) {}
                                },
                                child: const CircleAvatar(
                                  backgroundColor: Colors.green,
                                  child:
                                  Icon(Icons.search, color: Colors.white),
                                ))
                          ],
                        ),
                        filled: true,
                        hintText: "Search Clients",
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                          borderSide: BorderSide.none,
                        )),
                  ),
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          GestureDetector(
                              onTap: () async {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      actions: [
                                        DropdownButton(
                                          // Initial Value
                                          value: dropDownValue,

                                          icon: const Icon(
                                              Icons.keyboard_arrow_down),

                                          // Array list of items
                                          items: items.map((String items) {
                                            return DropdownMenuItem(
                                              value: items,
                                              child: Text(items),
                                            );
                                          }).toList(),
                                          // After selecting the desired option,it will
                                          // change button value to selected value
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              dropDownValue = newValue!;
                                              getData();
                                              Navigator.of(context).pop();
                                            });
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Text(dropDownValue,
                                  style: const TextStyle(
                                      fontFamily: "Montserrat"))),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          GestureDetector(
                              onTap: () async {
                                DateTime? date =
                                await showMonthPicker(context: context);
                                if (date != null) {
                                  setState(() {
                                    month = DateFormat.MMMM().format(date);
                                    getData();
                                  });
                                }
                              },
                              child: Text(month,
                                  style: const TextStyle(
                                      fontFamily: "Montserrat"))),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          GestureDetector(
                              onTap: () async {
                                DateTime? date =
                                await showMonthPicker(context: context);
                                if (date != null) {
                                  setState(() {
                                    years = date;
                                    getData();
                                  });
                                }
                              },
                              child: Text(years.year.toString(),
                                  style: const TextStyle(
                                      fontFamily: "Montserrat"))),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            loadingIndicator
                ? const CircularProgressIndicator(
              strokeWidth: 2,
            )
                : Container(),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text("Till Month Sale",
                          style: TextStyle(
                              fontFamily: "Montserrat",
                              color: Colors.green,
                              fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
                panelLoad
                    ? DelayedDisplay(
                  child: Column(
                    children: [
                      Card(
                        child: Column(
                          children: [
                            Row(
                              children: const [
                                Text(
                                  "Walkin Clients",
                                  style: TextStyle(
                                      fontFamily: "Montserrat",
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                Icon(
                                  Icons.show_chart,
                                  color: Colors.green,
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Text("Cash- Rs.",
                                          style: TextStyle(
                                              color: Colors.black54)),
                                      Text(walkinCash.toString(),
                                          style: const TextStyle(
                                              fontFamily: "Montserrat",
                                              fontSize: 22)),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Text("Card- Rs.",
                                          style: TextStyle(
                                              color: Colors.black54)),
                                      Text(walkinCard.toString(),
                                          style: const TextStyle(
                                              fontFamily: "Montserrat",
                                              fontSize: 22)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Text("UPI- Rs.",
                                          style: TextStyle(
                                              color: Colors.black54)),
                                      Text(walkinUPI.toString(),
                                          style: const TextStyle(
                                              fontFamily: "Montserrat",
                                              fontSize: 22)),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Text("Wallet- Rs.",
                                          style: TextStyle(
                                              color: Colors.black54)),
                                      Text(walkinWallet.toString(),
                                          style: const TextStyle(
                                              fontFamily: "Montserrat",
                                              fontSize: 22)),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      Card(
                        child: Column(
                          children: [
                            Row(
                              children: const [
                                Text(
                                  "Membership Sold",
                                  style: TextStyle(
                                      fontFamily: "Montserrat",
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                Icon(
                                  Icons.graphic_eq,
                                  color: Colors.orange,
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Text("Cash- Rs.",
                                          style: TextStyle(
                                              color: Colors.black54)),
                                      Text(membershipCash.toString(),
                                          style: const TextStyle(
                                              fontFamily: "Montserrat",
                                              fontSize: 22)),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Text("Card- Rs.",
                                          style: TextStyle(
                                              color: Colors.black54)),
                                      Text(memberShipCard.toString(),
                                          style: const TextStyle(
                                              fontFamily: "Montserrat",
                                              fontSize: 22)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Text("UPI- Rs.",
                                          style: TextStyle(
                                              color: Colors.black54)),
                                      Text(memberShipUPI.toString(),
                                          style: const TextStyle(
                                              fontFamily: "Montserrat",
                                              fontSize: 22)),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Text("Wallet- Rs.",
                                          style: TextStyle(
                                              color: Colors.black54)),
                                      Text(memberShipWallet.toString(),
                                          style: const TextStyle(
                                              fontFamily: "Montserrat",
                                              fontSize: 22)),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Card(
                        child: Column(
                          children: [
                            Row(
                              children: const [
                                Text(
                                  "Members Visit",
                                  style: TextStyle(
                                      fontFamily: "Montserrat",
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                Icon(
                                  Icons.directions_walk,
                                  color: Colors.blue,
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Text("Count.",
                                          style: TextStyle(
                                              color: Colors.black54)),
                                      Text(members.toString(),
                                          style: const TextStyle(
                                              fontFamily: "Montserrat",
                                              fontSize: 22)),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )
                    : Container(),
                panelLoad
                    ? Container()
                    : Image.asset(
                  "assets/noSale.png",
                  height: MediaQuery
                      .of(context)
                      .size
                      .width - 100,
                ),
                SizedBox(height: MediaQuery
                    .of(context)
                    .size
                    .height / 3,)
              ],
            )
          ],
        ),
      ),
    );
  }

  _panel(ScrollController sc) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(30)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: DropdownButton(
                // Initial Value
                value: dropDownValue,

                // Down Arrow Icon
                icon: const Icon(Icons.keyboard_arrow_down),

                // Array list of items
                items: items.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(items),
                  );
                }).toList(),
                // After selecting the desired option,it will
                // change button value to selected value
                onChanged: (String? newValue) {
                  setState(() {
                    dropDownValue = newValue!;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width / 2,
                    child: TextField(
                        controller: dateController,
                        //editing controller of this TextField
                        decoration: InputDecoration(
                            counterText: "",
                            filled: true,
                            prefixIcon: const Icon(
                                Icons.calendar_month_outlined,
                                color: Colors.black54,
                                size: 20),
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide: BorderSide.none,
                            )),
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2023),
                              lastDate: DateTime(2030));
                          if (pickedDate != null) {
                            selectedDate = pickedDate;
                            String formattedDate = DateFormat('dd-MM-yyyy')
                                .format(
                                pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                            setState(() {
                              dateController.text = formattedDate;
                            });
                          }
                        }),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: CupertinoButton(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.green,
                  child: const Text("Request"),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) =>
                          AllSale(spaName: dropDownValue,
                              month: DateFormat('MMMM')
                                  .format(
                                  selectedDate),
                              date: dateController.value.text,
                              year: selectedDate.year.toString()),));
                  }),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Icon(
                Icons.bar_chart_sharp,
                color: Colors.green[400],
                size: MediaQuery
                    .of(context)
                    .size
                    .height / 10,
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> getData() async {
    setState(() {
      loadingIndicator = true;
    });

    try {
      await db
          .collection(years.year.toString())
          .doc(dropDownValue)
          .collection(month)
          .doc("till Sale")
          .get()
          .then((DocumentSnapshot documentSnapshot) async {
        if (documentSnapshot.exists) {
          walkinCash = documentSnapshot.get("Walkin Cash");
          walkinCard = documentSnapshot.get("Walkin Card");
          walkinUPI = documentSnapshot.get("Walkin UPI");
          walkinWallet = documentSnapshot.get("Walkin Wallet");
          membershipCash = documentSnapshot.get("Membership Cash");
          memberShipCard = documentSnapshot.get("Membership Card");
          memberShipUPI = documentSnapshot.get("Membership UPI");
          memberShipWallet = documentSnapshot.get("Membership Wallet");
          members = documentSnapshot.get("Members");
          setState(() {
            panelLoad = true;
            loadingIndicator = false;
          });
        } else {
          setState(() {
            panelLoad = false;
            loadingIndicator = false;
          });
        }
      });
    } catch (e) {
      setState(() {
        panelLoad = false;
        loadingIndicator = false;
      });
    }
  }
}

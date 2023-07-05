import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thirdeyesmanagmentadmin/sale_nav/custom_request.dart';

class UPI extends StatefulWidget {
  const UPI({Key? key}) : super(key: key);

  @override
  State<UPI> createState() => _UPIState();
}

class _UPIState extends State<UPI> {
  bool loaded = false;

  int total = 0;

  bool loading = true;

  bool indicator = false;

  bool image = false;
  FirebaseFirestore db = FirebaseFirestore.instance;
  List<dynamic> upiListed = [];

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => Future.delayed(const Duration(seconds: 2), () {
              todayUPI();
            }));
    return Scaffold(
      body: SingleChildScrollView(
          child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Column(
                children: [
                  CupertinoButton(
                      onPressed: () {
                        todayUPI();
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.refresh,
                            color: Colors.green,
                          ),
                          Text("Refresh",
                              style: TextStyle(color: Colors.green)),
                        ],
                      ))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text("Till Sale : ",
                      style: TextStyle(color: Colors.black38)),
                  Text(
                    "Rs.$total",
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.green),
                  )
                ],
              ),
              if (loaded)
                ListView.separated(
                  itemBuilder: (context, index) {
                    int sNo = index + 1;
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(upiListed[index]["date"],
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400)),
                              Text(upiListed[index]["time"],
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text("$sNo.",
                                      style: const TextStyle(fontSize: 16)),
                                  Text("${upiListed[index]["clientName"]}",
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontFamily: "Montserrat",
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              Text(upiListed[index]["clientId"],
                                  style: const TextStyle(
                                      fontSize: 18, fontFamily: "Montserrat")),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(upiListed[index]["massageName"],
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontFamily: "Montserrat",
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54)),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text(
                                  "Rs.${upiListed[index]["amountPaid"].toString()}/-",
                                  style: const TextStyle(
                                      fontSize: 22, color: Colors.green)),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: Text(
                                "Offer Applied: ",
                                style: TextStyle(),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text(
                                upiListed[index]["offerApplied"]
                                    ? "Yes"
                                    : "Not Applied",
                                style: const TextStyle(),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: Text(
                                "Offer Amount: ",
                                style: TextStyle(),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text(
                                upiListed[index]["offerAmount"].toString(),
                                style: const TextStyle(color: Colors.green),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: Text("Mode of payment:  ",
                                  style: TextStyle(fontSize: 16)),
                            ),
                            Text(upiListed[index]["modeOfPayment"],
                                style: const TextStyle(fontSize: 22)),
                          ],
                        ),
                        const Row(
                          children: [
                            Icon(Icons.account_circle, color: Colors.blue),
                            Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: Text("Booking Manager",
                                  style: TextStyle(
                                      fontFamily: "Montserrat",
                                      fontWeight: FontWeight.w800)),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text(upiListed[index]["manager"],
                                  style: const TextStyle(
                                      fontFamily: "Montserrat")),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                  itemCount: upiListed.length,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  separatorBuilder: (context, index) => const Divider(),
                )
              else
                loading
                    ? const CircularProgressIndicator(
                        color: Colors.green,
                        strokeWidth: 2,
                      )
                    : Container(),
              image
                  ? SizedBox(
                      width: MediaQuery.of(context).size.width / 1.1,
                      height: MediaQuery.of(context).size.width / 1.1,
                      child: Image.asset("assets/noSale.png"))
                  : Container(),
            ],
          ),
        ),
      )),
    );
  }

  Future<void> todayUPI() async {
    await db
        .collection(CustomRequest.getYear)
        .doc(CustomRequest.getSpaName)
        .collection(CustomRequest.getMonth)
        .doc(CustomRequest.getDate)
        .collection("today")
        .doc("Walkin Clients")
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      if (documentSnapshot.exists) {
        upiListed = await documentSnapshot.get("UPI");
        calculate();
      } else {
        if (mounted) {
          setState(() {
            total = 0;
            image = true;
            loaded = false;
            loading = false;
          });
        }
      }
    });
  }

  refresh() {
    if (mounted) {
      setState(() {
        loaded = true;
      });
    }
  }

  calculate() {
    List<int> array = [];
    for (int i = 0; i < upiListed.length; i++) {
      array.add(upiListed[i]["amountPaid"]);
    }
    total = array.fold(0, (p, c) => p + c);
    refresh();
  }
}

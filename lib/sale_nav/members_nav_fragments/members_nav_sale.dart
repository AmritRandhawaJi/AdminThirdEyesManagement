import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thirdeyesmanagmentadmin/sale_nav/custom_request.dart';

class MembersNavSale extends StatefulWidget {
  const MembersNavSale({Key? key}) : super(key: key);

  @override
  State<MembersNavSale> createState() => _WalkinNavSaleState();
}

class _WalkinNavSaleState extends State<MembersNavSale> {
  bool loaded = false;

  int total = 0;

  bool loading = true;

  bool indicator = false;

  bool image = false;
  FirebaseFirestore db = FirebaseFirestore.instance;
  List<dynamic> memberListed = [];

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => Future.delayed(const Duration(seconds: 2), () {
              todayCash();
            }));
    return Scaffold(
      body: SingleChildScrollView(
          child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 30),
                      child: Text("Members",
                          style: TextStyle(
                              fontFamily: "Montserrat", fontSize: 22)),
                    ),
                    CupertinoButton(
                        onPressed: () {
                          todayCash();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
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
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text("Members visit : ",
                            style: TextStyle(color: Colors.black38)),
                        Text(
                          "Count.$total",
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Colors.green),
                        )
                      ],
                    ),
                  ),
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
                                Text(memberListed[index]["date"],
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400)),
                                Text(memberListed[index]["time"],
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400)),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text("$sNo.",
                                      style: const TextStyle(fontSize: 16)),
                                  Text("${memberListed[index]["clientId"]}",
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontFamily: "Montserrat",
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              Text("${memberListed[index]["clientType"]}",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontFamily: "Montserrat",
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8,bottom: 5),
                            child: Row(
                              children: [
                                const Text("Client Name :",
                                    style: TextStyle(fontFamily: "Montserrat")),
                                Text(memberListed[index]["serviceClientName"],
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontFamily: "Montserrat",
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ), Row(
                            children: [
                              const Text("Therapist :",
                                  style: TextStyle(fontFamily: "Montserrat")),
                              Text(memberListed[index]["therapistName"],
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontFamily: "Montserrat",
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                  "Massages.${memberListed[index]["totalMassages"].toString()}",
                                  style: const TextStyle(
                                      fontSize: 22, color: Colors.green)),
                            ],
                          ),
                          Row(
                            children:  [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  softWrap: false,
                                  memberListed[index]["massageName"].toString(),
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),

                          const Icon(Icons.account_circle, color: Colors.blue),
                          const Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: Text("Booking Manager",
                                style: TextStyle(
                                    fontFamily: "Montserrat",
                                    fontWeight: FontWeight.w800)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Text(memberListed[index]["manager"],
                                style:
                                    const TextStyle(fontFamily: "Montserrat")),
                          ),
                        ],
                      );
                    },
                    itemCount: memberListed.length,
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
        ),
      )),
    );
  }

  Future<void> todayCash() async {

    await db
        .collection(CustomRequest.getYear)
        .doc(CustomRequest.getSpaName)
        .collection(CustomRequest.getMonth)
        .doc(CustomRequest.getDate)
        .collection("today")
        .doc("Members")
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      if (documentSnapshot.exists) {
        try {
          memberListed = await documentSnapshot.get("all");
          calculate();
        } catch (e) {
          if (mounted) {
            setState(() {
              total = 0;
              image = true;
              loaded = false;
              loading = false;
            });
          }
        }
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
    for (int i = 0; i < memberListed.length; i++) {
      array.add(memberListed[i]["totalMassages"]);
    }
    total = array.fold(0, (p, c) => p + c);
    refresh();
  }
}

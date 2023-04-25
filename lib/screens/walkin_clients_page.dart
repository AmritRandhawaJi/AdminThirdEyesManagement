import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class WalkingDetailsPage extends StatefulWidget {
  final String age;
  final bool member;
  final String name;
  final List<dynamic> pastServices;
  final String phone;
  final String registration;

  const WalkingDetailsPage(
      {super.key,
        required this.age,
        required this.member,
        required this.name,
        required this.phone,
        required this.registration,
        required this.pastServices});

  @override
  State<WalkingDetailsPage> createState() => _WalkingDetailsPageState();
}

class _WalkingDetailsPageState extends State<WalkingDetailsPage> {
  PanelController pc = PanelController();

  double panelHeightOpen = 0;
  double panelHeightClosed = 0;

  final db = FirebaseFirestore.instance;

  bool loader = false;

  @override
  Widget build(BuildContext context) {
    panelHeightOpen = MediaQuery.of(context).size.height - 100;
    panelHeightClosed = MediaQuery.of(context).size.height / 4;

    return Scaffold(
      backgroundColor: const Color(0xff2b6747),
      body: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              pc.open();
            },
            child: SlidingUpPanel(
              onPanelClosed: () {
                pc.close();
              },
              maxHeight: panelHeightOpen,
              minHeight: panelHeightClosed,
              parallaxEnabled: true,
              parallaxOffset: .5,
              color: const Color(0xFFedfff6),
              body: _body(),
              controller: pc,
              panelBuilder: (sc) => _panel(sc),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18.0),
                  topRight: Radius.circular(18.0)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _body() {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const CircleAvatar(
                    backgroundColor: Colors.white,
                    maxRadius: 30,
                    child: Icon(
                      Icons.account_circle,
                      size: 60,
                    )),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Welcome,",
                        style: TextStyle(fontSize: 16, color: Colors.white60)),
                    Row(
                      children: [
                        Text(widget.name,
                            style: const TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontFamily: "Montserrat")),
                        const SizedBox(width: 10),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(30)),
              height: 30,
              width: MediaQuery.of(context).size.width / 2,
              child: Center(
                  child: Text(widget.phone,
                      style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 18,
                          fontFamily: "Montserrat")))),
          const SizedBox(height: 20),
          const Text("Registration",
              style: TextStyle(
                  fontSize: 16, color: Colors.white60, fontFamily: "Dosis")),
          const SizedBox(height: 5),
          Text(
            widget.registration,
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 30),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Membership",
                  style: TextStyle(fontSize: 18, color: Colors.white)),
              const SizedBox(
                height: 5,
              ),
              Container(
                  width: MediaQuery.of(context).size.width - 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white),
                  child: Center(
                    child: widget.member
                        ? Container()
                        : const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("You have no membership",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green)),
                    ),
                  )),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset("assets/welcome.png"),
          ),

        ],
      ),
    );
  }

  Widget _panel(ScrollController sc) {
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: widget.pastServices.isEmpty
            ? Column(
          children: [
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 30,
                  height: 5,
                  decoration: const BoxDecoration(
                      color: Colors.black54,
                      borderRadius:
                      BorderRadius.all(Radius.circular(12.0))),
                ),
              ],
            ),
            const SizedBox(height: 20),
            loader
                ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  CircularProgressIndicator(
                    strokeWidth: 1,
                  ),
                ],
              ),
            )
                : Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () {
                        setState(() {
                          loader = true;
                        });
                        checkOffer();
                      },
                      child: const Text("Offers",
                          style: TextStyle(color: Colors.black)))
                ]),
            const Text("You haven't taken any service yet",
                style: TextStyle(fontSize: 16, fontFamily: "Montserrat")),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Image.asset("assets/clientSlider.png"),
            ),
          ],
        )
            : SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 15),
              Container(
                width: 30,
                height: 5,
                decoration: const BoxDecoration(
                    color: Colors.grey,
                    borderRadius:
                    BorderRadius.all(Radius.circular(12.0))),
              ),
              loader
                  ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    CircularProgressIndicator(
                      strokeWidth: 1,
                    ),
                  ],
                ),
              )
                  : Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {
                          setState(() {
                            loader = true;
                          });
                          checkOffer();
                        },
                        child: const Text(
                          "Offers",
                          style: TextStyle(color: Colors.black),
                        ))
                  ]),
              ListView.builder(
                itemCount: widget.pastServices.length,
                itemBuilder: (BuildContext context, int index) {
                  int sNo = index + 1;
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text("$sNo. "),
                                Text(
                                    widget.pastServices[index]["spaName"],
                                    style: const TextStyle(
                                        fontFamily: "Montserrat",
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            Text(widget.pastServices[index]["date"],
                                style: const TextStyle(
                                    fontFamily: "Montserrat",
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 5),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Text("Paid : "),
                                Text(
                                    widget.pastServices[index]
                                    ["modeOfPayment"],
                                    softWrap: true,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Montserrat")),
                              ],
                            ),
                            Row(
                              children: [
                                const Text("Time : "),
                                Text(widget.pastServices[index]["time"],
                                    softWrap: true,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Montserrat")),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            const Text("Massage : "),
                            Text(
                                widget.pastServices[index]["massageName"],
                                softWrap: true,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Montserrat")),
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
                                const Text("Client : "),
                                Text(
                                    widget.pastServices[index]
                                    ["clientName"],
                                    softWrap: true,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Montserrat")),
                              ],
                            ),
                            Row(
                              children: [
                                const Text("Therapist : "),
                                Text(
                                    widget.pastServices[index]
                                    ["therapist"],
                                    softWrap: true,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Montserrat")),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        thickness: 2,
                      )
                    ],
                  );
                },
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
              ),
            ],
          ),
        ));
  }

  void checkOffer() {
    List<dynamic> list = [];
    db.collection("clients").doc(widget.phone).get().then((value) async => {
      list = await value.get("offers"),
      if (list.isEmpty)
        {
          setState(() {
            loader = false;
          }),
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("No Offers")))
        }
      else
        {
          setState(() {
            loader = false;
          }),
          showDialog(
            context: context,
            builder: (context) {
              return Card(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                              onTap: () {},
                              child: const Icon(
                                Icons.close,
                                size: 35,
                              ))
                        ],
                      ),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  const Text("Your Offers",style: TextStyle(fontSize: 18,fontFamily: "Montserrat")),
                                  Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(children: [

                                        Row(
                                          children: [
                                            const Text("Offer Code : "),
                                            Text(list[index]["offerCode"],style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                                          ],
                                        ),

                                        Row(children: [
                                          const Text("Offer Amount : "),
                                          Text("Rs.${list[index]["offerAmount"]}",style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                                        ],),
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              TextButton(onPressed: (){
                                                Clipboard.setData( ClipboardData(text: list[index]["offerCode"]));
                                                Navigator.of(context).pop();
                                              }, child: const Text("Copy Code"))
                                            ]),
                                      ],),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        itemCount: list.length, separatorBuilder: (BuildContext context, int index) {
                        return const Divider();
                      },)
                    ],
                  ));
            },
          )
        }
    });
  }
}

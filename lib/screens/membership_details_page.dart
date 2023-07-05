import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MemberDetailsPage extends StatefulWidget {
  const MemberDetailsPage({
    Key? key,
    required this.name,
    required this.validity,
    required this.member,
    required this.paymentType,
    required this.massages,
    required this.pendingMassage,
    required this.package,
    required this.age,
    required this.phoneNumber,
    required this.registration,
    required this.pastServices,
    required this.paid,
  }) : super(key: key);
  final String name;
  final String validity;

  final int massages;
  final int pendingMassage;

  final int paid;
  final String age;
  final String paymentType;
  final String package;
  final bool member;
  final String phoneNumber;
  final String registration;
  final List<dynamic> pastServices;

  @override
  State<MemberDetailsPage> createState() => _MemberDetailsPageState();
}

class _MemberDetailsPageState extends State<MemberDetailsPage> {
  bool loaded = false;
  final pc = PanelController();

  @override
  Widget build(BuildContext context) {
    final double panelHeightClosed = MediaQuery.of(context).size.height / 4.5;

    var panelHeightOpen = MediaQuery.of(context).size.height/1.3;
    return Scaffold(
      resizeToAvoidBottomInset: false,
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

  Widget _body() {
    return SafeArea(
      child: SingleChildScrollView(
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
                          style:
                          TextStyle(fontSize: 16, color: Colors.white60)),
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
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30)),
                height: 30,
                width: MediaQuery.of(context).size.width / 2,
                child: Center(
                    child: Text(widget.phoneNumber,
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
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text("Membership",
                          style: TextStyle(fontSize: 18, color: Colors.white,fontFamily: "Montserrat")),
                    ],
                  ),
                ),
                const Text("Validity", style: TextStyle(color: Colors.white)),
                Text(widget.validity,
                    style: const TextStyle(color: Colors.white, fontSize: 18)),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Container(
                      height: 30,
                      width: MediaQuery.of(context).size.width / 4,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.white),
                      child: Center(
                        child: widget.pendingMassage == 0
                            ? const Text("Inactive",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red))
                            : const Text("Active",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green)),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text("Paid : ",
                          style: TextStyle(color: Colors.white)),
                      Text("${widget.paid}/-",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18)),

                      const Text("Massages:",
                          style: TextStyle(color: Colors.white)),
                      Text(widget.massages.toString(),
                          style: const TextStyle(
                              fontSize: 22, color: Colors.white)),

                    ],
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Package:",
                          style: TextStyle(color: Colors.white)),
                      Text(widget.package.toString(),
                          style: const TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                          )),

                      const Text("Massages Left: ",
                          style: TextStyle(color: Colors.white)),
                      Text(widget.pendingMassage.toString(),
                          style: const TextStyle(
                              fontSize: 22, color: Colors.white)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

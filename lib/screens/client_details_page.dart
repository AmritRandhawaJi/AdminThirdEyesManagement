import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thirdeyesmanagmentadmin/screens/membership_details_page.dart';
import 'package:thirdeyesmanagmentadmin/screens/walkin_clients_page.dart';

class ClientDetailsPage extends StatefulWidget {
  final String number;

  const ClientDetailsPage({Key? key, required this.number}) : super(key: key);

  @override
  State<ClientDetailsPage> createState() => _ClientDetailsPageState();
}

class _ClientDetailsPageState extends State<ClientDetailsPage> {
  final db = FirebaseFirestore.instance;
  late DocumentSnapshot databaseData;

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => Future.delayed(const Duration(seconds: 1), () {
              _searchClient(widget.number);
            }));
    return const Scaffold(
        body: Center(
      child: CircularProgressIndicator(strokeWidth: 1),
    ));
  }

  Future<void> _searchClient(String query) async {
    await db
        .collection('clients')
        .doc(query)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      databaseData = documentSnapshot;
      if (documentSnapshot.exists) {
        goForClient();
      } else {
        setState(() {
          loading = false;
        });
        showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: const Text(
                    "No Client Found",
                    style: TextStyle(color: Colors.red),
                  ),
                  content: const Text(
                    "Client not registered with us.",
                    style: TextStyle(fontFamily: "Montserrat"),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                        },
                        child: const Text("Try Again"))
                  ],
                ));
      }
    });
  }

  goForClient() {
    if (databaseData["member"]) {
      setState(() {
        loading = false;
      });
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MemberDetailsPage(
              phoneNumber: databaseData["phone"],
              member: databaseData["member"],
              age: databaseData["age"],
              name: databaseData.get("name"),
              registration: databaseData.get("registration"),
              pastServices: databaseData.get("pastServices"),
              validity: databaseData.get("validity"),
              package: databaseData.get("package"),
              massages: databaseData.get("massages"),
              pendingMassage: databaseData.get("pendingMassage"),
              paid: databaseData.get("paid"),
              paymentType: databaseData.get("paymentMode"),
            ),
          ));
    } else if (databaseData["member"] == false) {
      setState(() {
        loading = false;
      });
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => WalkingDetailsPage(
                    name: databaseData.get("name"),
                    age: databaseData.get("ageEligible"),
                    member: databaseData.get("member"),
                    pastServices: databaseData.get("pastServices"),
                    phone: databaseData.get("phone"),
                    registration: databaseData.get("registration"),
                  )));
    }
  }
}

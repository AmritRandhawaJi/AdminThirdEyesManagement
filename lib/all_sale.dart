import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thirdeyesmanagmentadmin/sale_nav/custom_request.dart';
import 'package:thirdeyesmanagmentadmin/sale_nav/members_nav_fragments/members_nav_sale.dart';
import 'package:thirdeyesmanagmentadmin/sale_nav/membership_nav_sale_fragments/membership_nav_sale.dart';
import 'package:thirdeyesmanagmentadmin/sale_nav/walkin_nav_sale_fragments/walkin_nav_sale.dart';

class AllSale extends StatefulWidget {
  const AllSale({Key? key, required this.spaName,  required this.date, required this.month, required this.year}) : super(key: key);

  final String spaName;
  final String date;
  final String month;
  final String year;

  @override
  State<AllSale> createState() => _AllSaleState();
}

class _AllSaleState extends State<AllSale> {

  int _selectedIndex = 0;

  @override
  void initState() {
 CustomRequest.setSpaName = widget.spaName;
 CustomRequest.setDate = widget.date;
 CustomRequest.setMonth = widget.month;
 CustomRequest.setYear = widget.year;
    super.initState();
  }
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static const List<Widget> _widgetOptions = <Widget>[
    WalkinNavSale(),
    MembershipNavSale(),
    MembersNavSale(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.systemGrey5,
      bottomNavigationBar: createBottomBar(context),
      body: SafeArea(
          child: _widgetOptions.elementAt(_selectedIndex)
      ),
    );
  }


  BottomNavigationBar createBottomBar(BuildContext context) {
    return BottomNavigationBar(
      unselectedFontSize: 14,
      selectedFontSize: 16,
      backgroundColor: Colors.white,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.directions_walk),
          label: 'Walkin Clients',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.card_membership),
          label: 'Membership',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people_alt_outlined),
          label: 'Members',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: const Color(0XFF2B6747),
      onTap: _onItemTapped,
    );
  }
}


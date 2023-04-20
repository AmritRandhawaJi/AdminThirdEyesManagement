import 'package:flutter/material.dart';
import 'package:thirdeyesmanagmentadmin/sale_nav/membership_nav_sale_fragments/membership_card.dart';
import 'package:thirdeyesmanagmentadmin/sale_nav/membership_nav_sale_fragments/membership_cash.dart';
import 'package:thirdeyesmanagmentadmin/sale_nav/membership_nav_sale_fragments/membership_upi.dart';
import 'package:thirdeyesmanagmentadmin/sale_nav/membership_nav_sale_fragments/membership_wallet.dart';


class MembershipNavSale extends StatefulWidget {
  const MembershipNavSale({Key? key}) : super(key: key);

  @override
  State<MembershipNavSale> createState() => _WalkinNavSaleState();
}

class _WalkinNavSaleState extends State<MembershipNavSale> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(

      length: 4,
      child: Scaffold(

        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.black,
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              TabBar(
                indicatorColor: Colors.white,
                physics: BouncingScrollPhysics(),
                tabs: [
                  Tab(
                    text: 'Cash',
                  ),
                  Tab(
                    text: 'Card',
                  ),
                  Tab(

                    text: 'UPI',
                  ),
                  Tab(
                    text: 'Wallet',
                  ),
                ],
              )
            ],
          ),
        ),
        body:  const TabBarView(
          children: [
           MembershipCash(),
           MembershipCard(),
           MembershipUPI(),
           MembershipWallet(),
          ],
        ),
      ),
    );
  }
}

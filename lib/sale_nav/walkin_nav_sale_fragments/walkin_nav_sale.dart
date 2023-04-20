import 'package:flutter/material.dart';
import 'package:thirdeyesmanagmentadmin/sale_nav/walkin_nav_sale_fragments/card.dart';
import 'package:thirdeyesmanagmentadmin/sale_nav/walkin_nav_sale_fragments/cash.dart';
import 'package:thirdeyesmanagmentadmin/sale_nav/walkin_nav_sale_fragments/upi.dart';
import 'package:thirdeyesmanagmentadmin/sale_nav/walkin_nav_sale_fragments/wallet.dart';


class WalkinNavSale extends StatefulWidget {
  const WalkinNavSale({Key? key}) : super(key: key);

  @override
  State<WalkinNavSale> createState() => _WalkinNavSaleState();
}

class _WalkinNavSaleState extends State<WalkinNavSale> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(

      length: 4,
      child: Scaffold(

        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0XFF2B6747),
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
        body: const TabBarView(

          children: [
            Cash(),
            CardSale(),
            UPI(),
            Wallet(),
          ],
        ),
      ),
    );
  }
}

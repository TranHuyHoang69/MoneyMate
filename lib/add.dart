import 'package:flutter/material.dart';
import 'package:money_mate/page/income_page.dart';
import 'package:money_mate/page/spend_page.dart';

class TransactionScreenStateless extends StatelessWidget {
  const TransactionScreenStateless({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight + 48),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
            child: AppBar(
              backgroundColor: Colors.blue,
              title: const Text(
                  'Thêm giao dịch',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              bottom: const TabBar(
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white60,
                indicatorColor: Colors.white,
                tabs: [
                  Tab(text: 'Chi tiêu', icon: Icon(Icons.shopping_cart)),
                  Tab(text: 'Thu nhập', icon: Icon(Icons.attach_money)),
                ],
              ),
              leading: IconButton(
                icon: Icon(Icons.arrow_back,color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            SpendPage(),
            IncomePage()
          ],
        ),
      ),
    );
  }
}

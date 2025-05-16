import 'package:flutter/material.dart';
import 'package:money_mate/main-thuNhap.dart';
import 'main-chiPhi.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ThuChiPage(),
    );
  }
}

class ThuChiPage extends StatefulWidget {
  @override
  _ThuChiPageState createState() => _ThuChiPageState();
}

class _ThuChiPageState extends State<ThuChiPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade800,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.account_balance_wallet),
            SizedBox(width: 8),
            Text("Tổng cộng", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: [Tab(text: 'Chi phí'), Tab(text: 'Thu Nhập')],
        ),
      ),

      body: TabBarView(
        controller: _tabController,
        children: [ChiPhiTab(), Text('Thu nhập')],
      ),
    );
  }
}

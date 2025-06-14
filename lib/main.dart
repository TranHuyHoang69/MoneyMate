import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:money_mate/add.dart';
import 'package:money_mate/model/spend_model.dart';
import 'package:money_mate/main-thuNhap.dart';
import 'package:money_mate/model/spend_service.dart';
import 'constant/type_transaction.dart';
import 'main-chiPhi.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(SpendModelAdapter());
  await Hive.openBox<SpendModelAdapter>('spend');

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
  ValueNotifier<bool> reloadNotifier = ValueNotifier(false);
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
        title:
        Column(
          children: [

            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.account_balance_wallet),
                SizedBox(width: 8),
                Text("Tổng cộng", style: TextStyle(fontWeight: FontWeight.bold)),

              ],
            ),
            ValueListenableBuilder(
              valueListenable: reloadNotifier,
              builder: (context, value, _) {
                return FutureBuilder<String>(
                  future: calculateNetAmountFromHive(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text("Đang tải...", style: TextStyle(fontSize: 14)),
                      );
                    } else if (snapshot.hasError) {
                      return Text("Lỗi dữ liệu", style: TextStyle(color: Colors.red));
                    } else {
                      return Text(
                        snapshot.data!,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      );
                    }
                  },
                );
              },
            ),
          ],
        ),


        bottom: TabBar(
          controller: _tabController,
          tabs: [Tab(text: 'Chi phí'), Tab(text: 'Thu Nhập')],
        ),
      ),

      body: TabBarView(
        controller: _tabController,
        children: [
          ChiPhiTab(reloadNotifier: reloadNotifier),
          ThuNhapTab(reloadNotifier: reloadNotifier)
        ],
      ),
    );
  }
  Future<String> calculateNetAmountFromHive() async {
    // final box = await Hive.openBox<SpendModel>('spend_box');
    List<SpendModel> list=await SpendService().getAllSpends();
    int totalIncome = 0;
    int totalSpend = 0;

    for (var spend in list) {
      if (spend.type == TypeTransaction.INCOME) {
        totalIncome += spend.amount;
      } else if (spend.type == TypeTransaction.SPEND) {
        totalSpend += spend.amount;
      }
    }

    int netAmount = totalIncome - totalSpend;
    final formatter = NumberFormat('#,###', 'vi_VN');
    String formattedAmount = formatter.format(netAmount.abs());
    // Thêm dấu trừ nếu âm
    if (netAmount < 0) {
      return '-$formattedAmount VNĐ';
    } else {
      return '$formattedAmount VNĐ';
    }
  }
}

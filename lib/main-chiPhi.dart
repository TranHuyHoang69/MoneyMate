import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:money_mate/constant/type_transaction.dart';
import 'package:money_mate/model/spend_service.dart';
import 'add.dart';
import 'chiTietGiaoDich/chiTietGiaoDich.dart';
import 'model/spend_model.dart';

class ChiPhiTab extends StatefulWidget {
  @override
  State<ChiPhiTab> createState() => _ChiPhiTabState();
}

class _ChiPhiTabState extends State<ChiPhiTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> tabs = ["Ngày", "Tháng", "Năm"];

  Map<String, List<Map<String, dynamic>>>? dataByTab; // dữ liệu động

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
    loadData();
  }

  Future<void> loadData() async {
    // Ví dụ lấy dữ liệu từ Hive box
    // final box = Hive.box<SpendModel>('spends');
    // List<SpendModel> spends = box.values.toList();

    // Tạm thời giả lập lấy dữ liệu async
    List<SpendModel> spends = await fetchSpendsFromService();

    final convertedData = convertSpendModelsToDataByTab(spends);
    setState(() {
      dataByTab = convertedData;
    });
  }

  // Giả lập hàm async lấy dữ liệu (bạn thay bằng lấy từ Hive thực tế)
  Future<List<SpendModel>> fetchSpendsFromService() async {
    // await Future.delayed(const Duration(milliseconds: 500)); // giả lập delay
    return SpendService().getAllSpends();
    // return []; // trả về danh sách SpendModel thực tế của bạn
  }

  Widget _buildPieChartContent(String tabKey) {
    if (dataByTab == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final data = dataByTab![tabKey]!;
    final total = data.fold(0, (sum, item) => sum + item['amount'] as int);
    final formatter = NumberFormat.decimalPattern();

    if (data.isEmpty) {
      return const Center(child: Text('Không có dữ liệu'));
    }

    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1.4,
          child: PieChart(
            PieChartData(
              centerSpaceRadius: 50,
              sectionsSpace: 2,
              sections:
                  data.map((item) {
                    return PieChartSectionData(
                      color: item['color'],
                      value: item['amount'].toDouble(),
                      title: '',
                      radius: 50,
                    );
                  }).toList(),
            ),
          ),
        ),
        Text(
          '${formatter.format(total)} ₫',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: ListView(
            children:
                data.map((item) {
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: item['color'],
                        child: Icon(item['icon'], color: Colors.white),
                      ),
                      title: Text(item['label']),
                      subtitle: Text('${item['percent']}%'),
                      trailing: Text('${formatter.format(item['amount'])} ₫'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => TransactionDetailScreen(
                                  transaction: {
                                    'amount': item['amount'].toString(),
                                    'category': item['label'],
                                    'date': DateFormat(
                                      'dd/MM/yyyy',
                                    ).format(DateTime.now()),
                                    'time': DateFormat(
                                      'HH:mm',
                                    ).format(DateTime.now()),
                                    'type': 'Chi tiêu',
                                  },
                                ),
                          ),
                        );
                      },
                    ),
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                color: Colors.white,
                child: TabBar(
                  controller: _tabController,
                  labelColor: Colors.green.shade800,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Colors.green.shade800,
                  tabs: tabs.map((tab) => Tab(text: tab)).toList(),
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children:
                      tabs.map((tab) => _buildPieChartContent(tab)).toList(),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TransactionScreenStateless(),
                  ),
                ).then((result) {
                  if (result == true) {
                    loadData();
                  }
                });
              },
              backgroundColor: Colors.yellow.shade700,
              child: const Icon(Icons.add, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}

Map<String, List<Map<String, dynamic>>> convertSpendModelsToDataByTab(
  List<SpendModel> spends,
) {
  final now = DateTime.now();

  bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
  bool isSameMonth(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month;
  bool isSameYear(DateTime a, DateTime b) => a.year == b.year;

  final categoryMap = {
    1: {
      'label': 'Ăn uống',
      'color': Colors.redAccent,
      'icon': Icons.restaurant,
    },
    2: {
      'label': 'Đi lại',
      'color': Colors.indigoAccent,
      'icon': Icons.directions_car,
    },
    3: {
      'label': 'Mua sắm',
      'color': Colors.pinkAccent,
      'icon': Icons.shopping_cart,
    },
    4: {
      'label': 'Học tập',
      'color': Colors.deepPurpleAccent,
      'icon': Icons.school,
    },
    5: {
      'label': 'Sức khỏe',
      'color': Colors.tealAccent.shade700,
      'icon': Icons.healing,
    },
    6: {'label': 'Cà phê', 'color': Colors.brown, 'icon': Icons.coffee},
    7: {'label': 'Giải trí', 'color': Colors.orangeAccent, 'icon': Icons.movie},
    8: {'label': 'Công việc', 'color': Colors.blueAccent, 'icon': Icons.work},
    9: {'label': 'Khác', 'color': Colors.grey, 'icon': Icons.more_horiz},
  };

  // Lọc spends theo type == 1 trước
  final filteredSpends =
      spends.where((s) => s.type == TypeTransaction.SPEND).toList();

  // Lọc chi tiêu theo từng tab dựa trên filteredSpends
  Map<String, List<SpendModel>> spendsByTab = {
    'Ngày': filteredSpends.where((s) => isSameDay(s.date, now)).toList(),
    'Tháng': filteredSpends.where((s) => isSameMonth(s.date, now)).toList(),
    'Năm': filteredSpends.where((s) => isSameYear(s.date, now)).toList(),
  };

  Map<String, List<Map<String, dynamic>>> dataByTab = {};

  for (String tab in spendsByTab.keys) {
    final tabSpends = spendsByTab[tab]!;

    final totalAmount = tabSpends.fold(0, (sum, s) => sum + s.amount);

    final Map<int, int> amountByCategory = {};
    for (var s in tabSpends) {
      amountByCategory[s.category] =
          (amountByCategory[s.category] ?? 0) + s.amount;
    }

    final List<Map<String, dynamic>> categoryList =
        amountByCategory.entries.map((entry) {
          final id = entry.key;
          final amount = entry.value;
          final percent =
              totalAmount > 0 ? (amount * 100 / totalAmount).round() : 0;
          final category = categoryMap[id] ?? categoryMap[9]!; // fallback: Khác
          return {
            'label': category['label'],
            'percent': percent,
            'amount': amount,
            'color': category['color'],
            'icon': category['icon'],
          };
        }).toList();

    dataByTab[tab] = categoryList;
  }

  return dataByTab;
}

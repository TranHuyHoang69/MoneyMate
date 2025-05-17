import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'add.dart';
import 'chiTietGiaoDich/chiTietGiaoDich.dart';

class ChiPhiTab extends StatefulWidget {
  @override
  State<ChiPhiTab> createState() => _ChiPhiTabState();
}

class _ChiPhiTabState extends State<ChiPhiTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> tabs = ["Ngày", "Tháng", "Năm"];

  final Map<String, List<Map<String, dynamic>>> dataByTab = {
    'Ngày': [
      {
        'label': 'Ăn',
        'percent': 50,
        'amount': 100000,
        'color': Colors.red,
        'icon': Icons.restaurant,
      },
      {
        'label': 'Cafe',
        'percent': 20,
        'amount': 40000,
        'color': Colors.purple,
        'icon': Icons.coffee,
      },
      {
        'label': 'Xăng',
        'percent': 30,
        'amount': 60000,
        'color': Colors.green,
        'icon': Icons.local_gas_station,
      },
    ],
    'Tháng': [
      {
        'label': 'Ăn',
        'percent': 40,
        'amount': 800000,
        'color': Colors.red,
        'icon': Icons.restaurant,
      },
      {
        'label': 'Sức khỏe',
        'percent': 25,
        'amount': 500000,
        'color': Colors.pink,
        'icon': Icons.favorite,
      },
      {
        'label': 'Xăng',
        'percent': 15,
        'amount': 300000,
        'color': Colors.green,
        'icon': Icons.local_gas_station,
      },
      {
        'label': 'Cafe',
        'percent': 10,
        'amount': 200000,
        'color': Colors.purple,
        'icon': Icons.coffee,
      },
      {
        'label': 'Khác',
        'percent': 10,
        'amount': 200000,
        'color': Colors.grey,
        'icon': Icons.more_horiz,
      },
    ],
    'Năm': [
      {
        'label': 'Ăn',
        'percent': 47,
        'amount': 1110000,
        'color': Colors.red,
        'icon': Icons.restaurant,
      },
      {
        'label': 'Sức khỏe',
        'percent': 18,
        'amount': 440000,
        'color': Colors.pink,
        'icon': Icons.favorite,
      },
      {
        'label': 'Xăng',
        'percent': 10,
        'amount': 245000,
        'color': Colors.green,
        'icon': Icons.local_gas_station,
      },
      {
        'label': 'Cafe',
        'percent': 9,
        'amount': 225000,
        'color': Colors.purple,
        'icon': Icons.coffee,
      },
      {
        'label': 'Tạp phẩm',
        'percent': 6,
        'amount': 150000,
        'color': Colors.lightGreen,
        'icon': Icons.shopping_bag,
      },
      {
        'label': 'Khác',
        'percent': 3,
        'amount': 75000,
        'color': Colors.grey,
        'icon': Icons.more_horiz,
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildPieChartContent(String tabKey) {
    final data = dataByTab[tabKey]!;
    final total = data.fold(0, (sum, item) => sum + item['amount'] as int);
    final formatter = NumberFormat.decimalPattern(); // Ex: 1,200,000

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
                );
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

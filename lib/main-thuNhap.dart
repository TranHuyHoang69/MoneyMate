import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:money_mate/constant/type_transaction.dart';
import 'package:money_mate/model/spend_service.dart';
import 'add.dart';
import 'chiTietGiaoDich/chiTietGiaoDich.dart';
import 'model/spend_model.dart';

class ThuNhapTab extends StatefulWidget {
  @override
  State<ThuNhapTab> createState() => _ChiPhiTabState();
}

class _ChiPhiTabState extends State<ThuNhapTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> tabs = ["Ngày", "Tháng", "Năm"];

  Map<String, Map<String, List<Map<String, dynamic>>>>? dataByTab;

  DateTime selectedDateNgay = DateTime.now();
  DateTime selectedDateThang = DateTime.now();
  DateTime selectedDateNam = DateTime.now();

  List<DateTime> availableDatesNgay = [];
  List<DateTime> availableDatesThang = [];
  List<DateTime> availableDatesNam = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
    loadData();
  }

  Future<void> loadData() async {
    List<SpendModel> spends = await fetchSpendsFromService();
    final convertedData = convertSpendModelsToDataByTab(spends);
    setState(() {
      dataByTab = convertedData;

      availableDatesNgay =
          convertedData['Ngày']!.keys
              .map((key) => DateFormat('yyyy-MM-dd').parse(key))
              .toList()
            ..sort();

      availableDatesThang =
          convertedData['Tháng']!.keys
              .map((key) => DateFormat('yyyy-MM').parse(key))
              .toList()
            ..sort();

      availableDatesNam =
          convertedData['Năm']!.keys
              .map((key) => DateFormat('yyyy').parse(key))
              .toList()
            ..sort();

      if (availableDatesNgay.isNotEmpty)
        selectedDateNgay = availableDatesNgay.last;
      if (availableDatesThang.isNotEmpty)
        selectedDateThang = availableDatesThang.last;
      if (availableDatesNam.isNotEmpty)
        selectedDateNam = availableDatesNam.last;
    });
  }

  Future<List<SpendModel>> fetchSpendsFromService() async {
    return SpendService().getAllSpends();
  }

  void goToPreviousDay() {
    final currentIndex = availableDatesNgay.indexOf(selectedDateNgay);
    if (currentIndex > 0) {
      setState(() => selectedDateNgay = availableDatesNgay[currentIndex - 1]);
    }
  }

  void goToNextDay() {
    final currentIndex = availableDatesNgay.indexOf(selectedDateNgay);
    if (currentIndex < availableDatesNgay.length - 1) {
      setState(() => selectedDateNgay = availableDatesNgay[currentIndex + 1]);
    }
  }

  void goToPreviousMonth() {
    final currentIndex = availableDatesThang.indexOf(selectedDateThang);
    if (currentIndex > 0) {
      setState(() => selectedDateThang = availableDatesThang[currentIndex - 1]);
    }
  }

  void goToNextMonth() {
    final currentIndex = availableDatesThang.indexOf(selectedDateThang);
    if (currentIndex < availableDatesThang.length - 1) {
      setState(() => selectedDateThang = availableDatesThang[currentIndex + 1]);
    }
  }

  void goToPreviousYear() {
    final currentIndex = availableDatesNam.indexOf(selectedDateNam);
    if (currentIndex > 0) {
      setState(() => selectedDateNam = availableDatesNam[currentIndex - 1]);
    }
  }

  void goToNextYear() {
    final currentIndex = availableDatesNam.indexOf(selectedDateNam);
    if (currentIndex < availableDatesNam.length - 1) {
      setState(() => selectedDateNam = availableDatesNam[currentIndex + 1]);
    }
  }

  Widget _buildPieChart(
    String tabKey,
    DateTime selectedDate,
    VoidCallback onPrev,
    VoidCallback onNext,
    String Function(DateTime) formatter,
  ) {
    if (dataByTab == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final dateKey =
        tabKey == 'Ngày'
            ? DateFormat('yyyy-MM-dd').format(selectedDate)
            : tabKey == 'Tháng'
            ? DateFormat('yyyy-MM').format(selectedDate)
            : DateFormat('yyyy').format(selectedDate);

    final data = dataByTab![tabKey]?[dateKey] ?? [];
    final total = data.fold(0, (sum, item) => sum + item['amount'] as int);
    final formatterMoney = NumberFormat.decimalPattern();

    return Column(
      children: [
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(onPressed: onPrev, icon: Icon(Icons.arrow_left)),
            Text(
              formatter(selectedDate),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            IconButton(onPressed: onNext, icon: Icon(Icons.arrow_right)),
          ],
        ),
        if (data.isEmpty)
          const Expanded(child: Center(child: Text('Không có dữ liệu')))
        else ...[
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
            '${formatterMoney.format(total)} ₫',
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
                        trailing: Text(
                          '${formatterMoney.format(item['amount'])} ₫',
                        ),
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
                                      ).format(selectedDate),
                                      'time': DateFormat(
                                        'HH:mm',
                                      ).format(DateTime.now()),
                                      'type': 'Thu nhập',
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
                  children: [
                    _buildPieChart(
                      'Ngày',
                      selectedDateNgay,
                      goToPreviousDay,
                      goToNextDay,
                      (d) => DateFormat('dd/MM/yyyy').format(d),
                    ),
                    _buildPieChart(
                      'Tháng',
                      selectedDateThang,
                      goToPreviousMonth,
                      goToNextMonth,
                      (d) => DateFormat('MM/yyyy').format(d),
                    ),
                    _buildPieChart(
                      'Năm',
                      selectedDateNam,
                      goToPreviousYear,
                      goToNextYear,
                      (d) => d.year.toString(),
                    ),
                  ],
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

Map<String, Map<String, List<Map<String, dynamic>>>>
convertSpendModelsToDataByTab(List<SpendModel> spends) {
  final categoryMap = {
    1: {'label': 'Phiếu lương', 'color': Colors.redAccent, 'icon': Icons.paid},
    2: {
      'label': 'Quà tặng',
      'color': Colors.indigoAccent,
      'icon': Icons.card_giftcard,
    },
    3: {
      'label': 'Sở thích',
      'color': Colors.pinkAccent,
      'icon': Icons.interests,
    },
    4: {'label': 'Khác', 'color': Colors.grey, 'icon': Icons.help},
  };

  final filteredSpends =
      spends.where((s) => s.type == TypeTransaction.INCOME).toList();

  final result = {
    'Ngày': <String, List<Map<String, dynamic>>>{},
    'Tháng': <String, List<Map<String, dynamic>>>{},
    'Năm': <String, List<Map<String, dynamic>>>{},
  };

  for (var s in filteredSpends) {
    final date = s.date;
    final category = categoryMap[s.category] ?? categoryMap[4]!;

    final entry = {
      'label': category['label'],
      'amount': s.amount,
      'color': category['color'],
      'icon': category['icon'],
      'date': s.date,
      'percent': 0, // cập nhật sau
    };

    final ngayKey = DateFormat('yyyy-MM-dd').format(date);
    final thangKey = DateFormat('yyyy-MM').format(date);
    final namKey = DateFormat('yyyy').format(date);

    result['Ngày']!.putIfAbsent(ngayKey, () => []).add(entry);
    result['Tháng']!.putIfAbsent(thangKey, () => []).add(entry);
    result['Năm']!.putIfAbsent(namKey, () => []).add(entry);
  }

  // Tính phần trăm
  for (var tab in ['Ngày', 'Tháng', 'Năm']) {
    result[tab]!.forEach((_, list) {
      final total = list.fold(0, (sum, item) => sum + item['amount'] as int);
      for (var item in list) {
        item['percent'] =
            total > 0 ? (((item['amount'] as int) * 100) / total).round() : 0;
      }
    });
  }

  return result;
}

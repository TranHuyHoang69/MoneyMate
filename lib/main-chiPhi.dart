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
  DateTime selectedDate = DateTime.now();
  DateTime selectedMonth = DateTime.now();
  int selectedYear = DateTime.now().year;

  List<String> getAvailableDays() {
    return groupedData?['Ngày']?.keys.toList() ?? [];
  }

  List<String> getAvailableMonths() {
    return groupedData?['Tháng']?.keys.toList() ?? [];
  }

  List<String> getAvailableYears() {
    return groupedData?['Năm']?.keys.toList() ?? [];
  }

  void goToPreviousDay() {
    final days = getAvailableDays();
    int currentIndex = days.indexOf(
      DateFormat('yyyy-MM-dd').format(selectedDate),
    );
    if (currentIndex + 1 < days.length) {
      setState(() {
        selectedDate = DateTime.parse(days[currentIndex + 1]);
      });
    }
  }

  void goToNextDay() {
    final days = getAvailableDays();
    int currentIndex = days.indexOf(
      DateFormat('yyyy-MM-dd').format(selectedDate),
    );
    if (currentIndex - 1 >= 0) {
      setState(() {
        selectedDate = DateTime.parse(days[currentIndex - 1]);
      });
    }
  }

  void goToPreviousMonth() {
    final months = getAvailableMonths();
    int currentIndex = months.indexOf(
      DateFormat('yyyy-MM-01').format(selectedMonth),
    );
    if (currentIndex + 1 < months.length) {
      setState(() {
        selectedMonth = DateTime.parse(months[currentIndex + 1]);
      });
    }
  }

  void goToNextMonth() {
    final months = getAvailableMonths();
    int currentIndex = months.indexOf(
      DateFormat('yyyy-MM-01').format(selectedMonth),
    );
    if (currentIndex - 1 >= 0) {
      setState(() {
        selectedMonth = DateTime.parse(months[currentIndex - 1]);
      });
    }
  }

  void goToPreviousYear() {
    final years = getAvailableYears();
    int currentIndex = years.indexOf(selectedYear.toString());
    if (currentIndex + 1 < years.length) {
      setState(() {
        selectedYear = int.parse(years[currentIndex + 1]);
      });
    }
  }

  void goToNextYear() {
    final years = getAvailableYears();
    int currentIndex = years.indexOf(selectedYear.toString());
    if (currentIndex - 1 >= 0) {
      setState(() {
        selectedYear = int.parse(years[currentIndex - 1]);
      });
    }
  }

  late TabController _tabController;
  final List<String> tabs = ["Ngày", "Tháng", "Năm"];

  Map<String, Map<String, List<Map<String, dynamic>>>>? groupedData;
  List<String> availableDays = [];
  int currentDayIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
    loadData();
  }

  Future<void> loadData() async {
    List<SpendModel> spends = await SpendService().getAllSpends();
    spends = spends.where((s) => s.type == TypeTransaction.SPEND).toList();
    final data = groupSpendModelsByTime(spends);

    setState(() {
      groupedData = data;
      if (groupedData!["Ngày"] != null && groupedData!["Ngày"]!.isNotEmpty) {
        availableDays =
            groupedData!["Ngày"]!.keys.toList()..sort((a, b) => b.compareTo(a));
        currentDayIndex = 0;
      }
    });
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
                      tabs.map((tab) {
                        if (groupedData == null) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (tab == 'Ngày') {
                          String key = DateFormat(
                            'yyyy-MM-dd',
                          ).format(selectedDate);
                          List<Map<String, dynamic>> data =
                              groupedData![tab]?[key] ?? [];

                          return Column(
                            children: [
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: goToPreviousDay,
                                    icon: const Icon(Icons.arrow_left),
                                  ),
                                  Text(
                                    DateFormat(
                                      'dd/MM/yyyy',
                                    ).format(selectedDate),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: goToNextDay,
                                    icon: const Icon(Icons.arrow_right),
                                  ),
                                ],
                              ),
                              Expanded(child: _buildPieChart(data)),
                            ],
                          );
                        }
                        if (tab == 'Tháng') {
                          String key = DateFormat(
                            'yyyy-MM-01',
                          ).format(selectedMonth);
                          List<Map<String, dynamic>> data =
                              groupedData![tab]?[key] ?? [];

                          return Column(
                            children: [
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: goToPreviousMonth,
                                    icon: const Icon(Icons.arrow_left),
                                  ),
                                  Text(
                                    DateFormat('MM/yyyy').format(selectedMonth),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: goToNextMonth,
                                    icon: const Icon(Icons.arrow_right),
                                  ),
                                ],
                              ),
                              Expanded(child: _buildPieChart(data)),
                            ],
                          );
                        }

                        if (tab == 'Năm') {
                          String key = selectedYear.toString();
                          List<Map<String, dynamic>> data =
                              groupedData![tab]?[key] ?? [];

                          return Column(
                            children: [
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: goToPreviousYear,
                                    icon: const Icon(Icons.arrow_left),
                                  ),
                                  Text(
                                    '$selectedYear',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: goToNextYear,
                                    icon: const Icon(Icons.arrow_right),
                                  ),
                                ],
                              ),
                              Expanded(child: _buildPieChart(data)),
                            ],
                          );
                        }

                        // Với Tháng & Năm giữ nguyên
                        return ListView(
                          children:
                              groupedData![tab]!.entries.map((entry) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Text(
                                        tab == 'Tháng'
                                            ? DateFormat(
                                              'MM/yyyy',
                                            ).format(DateTime.parse(entry.key))
                                            : entry.key,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    _buildPieChart(entry.value),
                                  ],
                                );
                              }).toList(),
                        );
                      }).toList(),
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

  Widget _buildPieChart(List<Map<String, dynamic>> data) {
    final total = data.fold(0, (sum, item) => sum + item['amount'] as int);
    final formatter = NumberFormat.decimalPattern();

    if (data.isEmpty) {
      return const Center(child: Text('Không có dữ liệu'));
    }

    return ListView(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(12),
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
        Center(
          child: Text(
            '${formatter.format(total)} ₫',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 10),
        ...data.map(
          (item) => Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: item['color'],
                child: Icon(item['icon'], color: Colors.white),
              ),
              title: Text(item['label']),
              subtitle: Text('${item['percent']}%'),
              trailing: Text('${formatter.format(item['amount'])} ₫'),
            ),
          ),
        ),
        const SizedBox(height: 80), // tránh bị che bởi FAB
      ],
    );
  }
}

Map<String, Map<String, List<Map<String, dynamic>>>> groupSpendModelsByTime(
  List<SpendModel> spends,
) {
  final Map<int, Map<String, dynamic>> categoryMap = {
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

  Map<String, Map<String, List<SpendModel>>> grouped = {
    'Ngày': {},
    'Tháng': {},
    'Năm': {},
  };

  for (var s in spends) {
    String dayKey = DateFormat('yyyy-MM-dd').format(s.date);
    String monthKey = DateFormat('yyyy-MM-01').format(s.date);
    String yearKey = s.date.year.toString();

    grouped['Ngày']!.putIfAbsent(dayKey, () => []).add(s);
    grouped['Tháng']!.putIfAbsent(monthKey, () => []).add(s);
    grouped['Năm']!.putIfAbsent(yearKey, () => []).add(s);
  }

  Map<String, Map<String, List<Map<String, dynamic>>>> result = {};

  grouped.forEach((tab, mapByKey) {
    Map<String, List<Map<String, dynamic>>> tabData = {};
    for (var key in mapByKey.keys) {
      List<SpendModel> items = mapByKey[key]!;
      int total = items.fold(0, (sum, s) => sum + s.amount);

      Map<int, int> amountByCategory = {};
      for (var s in items) {
        amountByCategory[s.category] =
            (amountByCategory[s.category] ?? 0) + s.amount;
      }

      List<Map<String, dynamic>> data =
          amountByCategory.entries.map((entry) {
            final id = entry.key;
            final amount = entry.value;
            final percent = total > 0 ? (amount * 100 / total).round() : 0;
            final category = categoryMap[id] ?? categoryMap[9]!;

            return {
              'label': category['label'],
              'percent': percent,
              'amount': amount,
              'color': category['color'],
              'icon': category['icon'],
            };
          }).toList();

      tabData[key] = data;
    }

    final sortedTabData = Map.fromEntries(
      tabData.entries.toList()..sort((a, b) => b.key.compareTo(a.key)),
    );

    result[tab] = sortedTabData;
  });

  return result;
}

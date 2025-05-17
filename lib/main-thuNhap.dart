// note : Hiển thị Ngày, tháng , năm, cùng với biểu đồ tròn
// các danh mục thu nhập đã thêm
// button "+" để thêm thu nhập
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'add.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quản lý chi tiêu',
      theme: ThemeData.dark(),
      home: const ExpenseTracker(),
    );
  }
}

class ExpenseTracker extends StatefulWidget {
  const ExpenseTracker({super.key});

  @override
  State<ExpenseTracker> createState() => _ExpenseTrackerState();
}

class _ExpenseTrackerState extends State<ExpenseTracker> {
  // Dữ liệu mẫu cho các tab: Ngày, Tháng, Năm
  final Map<String, double> dataMapNgay = {
    "Phiếu lương": 2000000,
    "Quà tặng": 300000,
    "Sở thích": 50000,
  };

  final Map<String, double> dataMapThang = {
    "Phiếu lương": 4000000,
    "Quà tặng": 1180000,
    "Sở thích": 164840,
  };

  final Map<String, double> dataMapNam = {
    "Phiếu lương": 45000000,
    "Quà tặng": 5200000,
    "Sở thích": 1000000,
  };

  final List<Color> colorList = [Colors.blue, Colors.pink, Colors.green];
  String selectedTab = 'Tháng';

  // Lấy đúng dữ liệu theo tab đang chọn
  Map<String, double> get selectedDataMap {
    switch (selectedTab) {
      case 'Ngày':
        return dataMapNgay;
      case 'Năm':
        return dataMapNam;
      default:
        return dataMapThang;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double total = selectedDataMap.values.fold(0, (a, b) => a + b);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Column(
          children: [
            const Text(
              'Tổng cộng',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            Text(
              '${(total + 570771).toStringAsFixed(0)} đ',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          const Text(
            'THU NHẬP',
            style: TextStyle(color: Colors.greenAccent, fontSize: 18),
          ),
          const SizedBox(height: 12),
          _buildTabSelector(),
          const SizedBox(height: 12),
          _buildChartSection(total),
          const SizedBox(height: 12),
          Expanded(child: _buildIncomeList(total)),
        ],
      ),
    );
  }

  // Widget hiển thị lựa chọn tab Ngày / Tháng / Năm
  Widget _buildTabSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children:
          ['Ngày', 'Tháng', 'Năm'].map((tab) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: ChoiceChip(
                label: Text(tab),
                selected: selectedTab == tab,
                onSelected: (_) => setState(() => selectedTab = tab),
                selectedColor: Colors.green,
              ),
            );
          }).toList(),
    );
  }

  // Widget hiển thị biểu đồ và nút + (để trống chờ người khác xử lý form thêm danh mục)
  Widget _buildChartSection(double total) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        children: [
          Expanded(
            child: PieChart(
              dataMap: selectedDataMap,
              animationDuration: const Duration(milliseconds: 800),
              chartRadius: MediaQuery.of(context).size.width / 2.5,
              colorList: colorList,
              chartType: ChartType.ring,
              ringStrokeWidth: 32,
              // TẮT hiển thị số tiền trên biểu đồ
              chartValuesOptions: const ChartValuesOptions(
                showChartValues: false,
              ),
              legendOptions: const LegendOptions(showLegends: false),
              centerText: "${(total / 1000000).toStringAsFixed(2)} Tr đ",
            ),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            backgroundColor: Colors.yellow,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TransactionScreenStateless(),
                ),
              );
            },
            child: const Icon(Icons.add, color: Colors.black),
          ),
        ],
      ),
    );
  }

  // Danh sách các danh mục thu nhập, bấm vào sẽ hiện thông tin chi tiết
  Widget _buildIncomeList(double total) {
    return ListView(
      children:
          selectedDataMap.entries.map((entry) {
            int index = selectedDataMap.keys.toList().indexOf(entry.key);
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 6,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  onTap:
                      () => _showEntryDetails(
                        entry,
                      ), // Mở dialog hiển thị thông tin
                  leading: CircleAvatar(
                    backgroundColor: colorList[index],
                    child: Icon(
                      entry.key == "Phiếu lương"
                          ? Icons.payments_outlined
                          : entry.key == "Quà tặng"
                          ? Icons.card_giftcard
                          : Icons.account_balance,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    entry.key,
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    '${((entry.value / total) * 100).toStringAsFixed(0)}%',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  trailing: Text(
                    entry.value >= 1000000
                        ? '${(entry.value / 1000000).toStringAsFixed(2)} Tr đ'
                        : '${entry.value.toStringAsFixed(0)} đ',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }

  // Dialog hiển thị thông tin danh mục khi bấm vào mục thu nhập
  void _showEntryDetails(MapEntry<String, double> entry) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(entry.key),
            content: Text(
              entry.value >= 1000000
                  ? 'Số tiền: ${(entry.value / 1000000).toStringAsFixed(2)} Tr đ'
                  : 'Số tiền: ${entry.value.toStringAsFixed(0)} đ',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Đóng'),
              ),
            ],
          ),
    );
  }
}

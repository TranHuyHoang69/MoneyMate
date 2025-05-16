import 'package:flutter/material.dart';
import 'chinhSuaGiaoDich.dart';

class TransactionDetailScreen extends StatefulWidget {
  final Map<String, String>? transaction;

  const TransactionDetailScreen({super.key, this.transaction});

  @override
  _TransactionDetailScreenState createState() =>
      _TransactionDetailScreenState();
}

class _TransactionDetailScreenState extends State<TransactionDetailScreen> {
  late Map<String, String> _transactionData;

  @override
  void initState() {
    super.initState();
    _transactionData = widget.transaction ?? {};
  }

  static Map<String, String>? getArguments(BuildContext context) {
    return ModalRoute.of(context)?.settings.arguments as Map<String, String>?;
  }

  void _handleDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận'),
          content: const Text('Bạn có chắc muốn xóa giao dịch này?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Giao dịch đã được xóa')),
                );
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Xóa'),
            ),
          ],
        );
      },
    );
  }

  void _handleEdit(BuildContext context) async {
    final transactionData =
        _transactionData.isNotEmpty ? _transactionData : getArguments(context);
    if (transactionData != null) {
      final updatedTransaction = await Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => EditTransactionScreen(transaction: transactionData),
        ),
      );

      if (updatedTransaction != null) {
        setState(() {
          _transactionData = updatedTransaction;
        });
        // TODO: Lưu dữ liệu vào cơ sở dữ liệu hoặc API tại đây
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final transactionData =
        _transactionData.isNotEmpty ? _transactionData : getArguments(context);

    if (transactionData == null || transactionData.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Chi tiết giao dịch'),
          backgroundColor: Colors.teal,
        ),
        body: const Center(child: Text('Không tìm thấy giao dịch.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết giao dịch'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildDetailRow(
                    'Số tiền',
                    transactionData['amount'] ?? 'Không có dữ liệu',
                  ),
                  const SizedBox(height: 10),
                  _buildDetailRow(
                    'Danh mục',
                    transactionData['category'] ?? 'Không có dữ liệu',
                  ),
                  const SizedBox(height: 10),
                  _buildDetailRow(
                    'Ngày',
                    transactionData['date'] ?? 'Không có dữ liệu',
                  ),
                  const SizedBox(height: 10),
                  _buildDetailRow(
                    'Thời gian',
                    transactionData['time'] ?? 'Không có dữ liệu',
                  ),
                  const SizedBox(height: 10),
                  _buildDetailRow(
                    'Ghi chú',
                    transactionData['type'] ?? 'Không có dữ liệu',
                    valueColor:
                        transactionData['type'] == 'Chi tiêu'
                            ? Colors.red
                            : Colors.green,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () => _handleEdit(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: const Text(
                    'SỬA',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _handleDelete(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: const Text(
                    'XÓA',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$label:',
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: valueColor ?? Colors.black,
          ),
        ),
      ],
    );
  }
}

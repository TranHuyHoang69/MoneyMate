import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditTransactionScreen extends StatefulWidget {
  final Map<String, String> transaction;

  const EditTransactionScreen({super.key, required this.transaction});

  @override
  _EditTransactionScreenState createState() => _EditTransactionScreenState();
}

class _EditTransactionScreenState extends State<EditTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _amountController;
  late TextEditingController _categoryController;
  late TextEditingController _dateController;
  late TextEditingController _timeController;
  late String _selectedType;

  @override
  void initState() {
    super.initState();
    _amountController =
        TextEditingController(text: widget.transaction['amount'] ?? '');
    _categoryController =
        TextEditingController(text: widget.transaction['category'] ?? '');
    _dateController =
        TextEditingController(text: widget.transaction['date'] ?? '');
    _timeController =
        TextEditingController(text: widget.transaction['time'] ?? '');
    _selectedType = widget.transaction['type'] ?? 'Chi tiêu';
  }

  @override
  void dispose() {
    _amountController.dispose();
    _categoryController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      final updatedTransaction = {
        'amount': _amountController.text,
        'category': _categoryController.text,
        'date': _dateController.text,
        'time': _timeController.text,
        'type': _selectedType,
      };

      Navigator.pop(context, updatedTransaction);
    }
  }

  Future<void> _pickDate() async {
    final initialDate = DateFormat('dd/MM/yyyy').parse(_dateController.text);
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
    }
  }

  Future<void> _pickTime() async {
    final initialTime = DateFormat('HH:mm').parse(_timeController.text);
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialTime),
    );

    if (picked != null) {
      final dt = DateFormat.jm().parse(picked.format(context));
      _timeController.text = DateFormat('HH:mm').format(dt);
    }
  }

  @override
  Widget build(BuildContext context) {
    final disabledStyle = Theme.of(context).textTheme.bodyMedium!.copyWith(
      color: Colors.grey,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chỉnh sửa giao dịch'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Số tiền'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập số tiền';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Số tiền không hợp lệ';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _categoryController,
                enabled: false,
                style: disabledStyle,
                decoration: const InputDecoration(labelText: 'Danh mục'),
              ),
              TextFormField(
                controller: _dateController,
                readOnly: true,
                decoration: const InputDecoration(labelText: 'Ngày'),
                onTap: _pickDate,
              ),
              TextFormField(
                controller: _timeController,
                readOnly: true,
                decoration: const InputDecoration(labelText: 'Thời gian'),
                onTap: _pickTime,
              ),
              const SizedBox(height: 10),
              TextFormField(
                initialValue: _selectedType,
                enabled: false,
                style: disabledStyle,
                decoration: const InputDecoration(labelText: 'Loại giao dịch'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  'Lưu thay đổi',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
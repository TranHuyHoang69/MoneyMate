import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:money_mate/model/spend_model.dart';

import '../constant/type_transaction.dart';

class SpendService{
  final String _boxName="spendBox";

  Future<Box<SpendModel>> get _box async => await Hive.openBox<SpendModel>(_boxName);

  Future<Box<SpendModel>> getBox() async {
    return await Hive.openBox<SpendModel>(_boxName);
  }


  Future<void> addSpend(SpendModel spend) async{
    var box=await _box;
    await box.add(spend);
  }

  Future<void> updateSpend(int key, SpendModel updatedModel) async {
    final box = await getBox();
    await box.put(key, updatedModel); // Cập nhật tại key
  }

  Future<void> updateSpendModelForIncome({
    required Map<String, String> oldTransaction,
    required Map<String, String> newTransaction,
  }) async {
    final List<IconOption> options = [
      IconOption(Icons.paid, "Phiếu lương", 1),
      IconOption(Icons.card_giftcard, "Quà tặng", 2),
      IconOption(Icons.interests, "Sở thích", 3),
      IconOption(Icons.help, "Khác", 4),
    ];

    final box = await getBox();
    final allSpends = box.values.toList().cast<SpendModel>();

    final oldAmount = int.tryParse(oldTransaction['amount'] ?? '');
    final oldDateStr = oldTransaction['date'];
    final oldTypeStr = oldTransaction['type'];

    if (oldAmount == null || oldDateStr == null || oldTypeStr == null) return;

    final oldType = oldTypeStr == 'Chi phí' ? TypeTransaction.SPEND : TypeTransaction.INCOME;
    final oldDate = DateTime.tryParse(oldDateStr.split('/').reversed.join('-'));

    if (oldDate == null) return;

    final spendToUpdate = allSpends.firstWhere(
          (s) =>
          s.amount == oldAmount &&
          s.type == oldType &&
          s.date.year == oldDate.year &&
          s.date.month == oldDate.month &&
          s.date.day == oldDate.day,
      orElse: () => SpendModel(
        amount: 0,
        date: DateTime(2000),
        category: 0,
        note: '',
        type: 1,
      ),
    );
    if (spendToUpdate.amount == 0){
      print("vao return r");
      return;
    }


    // Parse ngày và giờ mới
    DateTime date = DateFormat('dd/MM/yyyy').parse(newTransaction['date']!);
    DateTime time = DateFormat('HH:mm').parse(newTransaction['time']!);
    DateTime fullDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    spendToUpdate.amount = int.parse(newTransaction['amount']!);
    spendToUpdate.date = fullDateTime;
    spendToUpdate.category =options.firstWhere(
          (option) => option.label == newTransaction['category'],
      orElse: () => IconOption(Icons.help, "Khác", 4),
    ).id;
    spendToUpdate.note = newTransaction['category']!;
    spendToUpdate.type = newTransaction['type'] == 'Thu nhập' ? 2 : 1;

    await spendToUpdate.save();
  }
  Future<void> updateSpendModelForSpend({
    required Map<String, String> oldTransaction,
    required Map<String, String> newTransaction,
  }) async {
    final List<IconOption> options = [
      IconOption(Icons.fastfood, "Ăn uống",1),
      IconOption(Icons.directions_car, "Đi lại",2),
      IconOption(Icons.shopping_cart, "Mua sắm",3),
      IconOption(Icons.school, "Học tập",4),
      IconOption(Icons.healing, "Sức khỏe",5),
      IconOption(Icons.coffee, "Cafe",6),
      IconOption(Icons.movie, "Giải trí",7),
      IconOption(Icons.work, "Công việc",8),
      IconOption(Icons.help, "Khác",9),
    ];

    final box = await getBox();
    final allSpends = box.values.toList().cast<SpendModel>();

    final oldAmount = int.tryParse(oldTransaction['amount'] ?? '');
    final oldDateStr = oldTransaction['date'];
    final oldTypeStr = oldTransaction['type'];

    if (oldAmount == null || oldDateStr == null || oldTypeStr == null) return;

    final oldType = oldTypeStr == 'Chi phí' ? TypeTransaction.SPEND : TypeTransaction.INCOME;
    final oldDate = DateTime.tryParse(oldDateStr.split('/').reversed.join('-'));

    if (oldDate == null) return;

    final spendToUpdate = allSpends.firstWhere(
          (s) =>
      s.amount == oldAmount &&
          s.type == oldType &&
          s.date.year == oldDate.year &&
          s.date.month == oldDate.month &&
          s.date.day == oldDate.day,
      orElse: () => SpendModel(
        amount: 0,
        date: DateTime(2000),
        category: 0,
        note: '',
        type: 1,
      ),
    );
    if (spendToUpdate.amount == 0){
      print("vao return r");
      return;
    }


    // Parse ngày và giờ mới
    DateTime date = DateFormat('dd/MM/yyyy').parse(newTransaction['date']!);
    DateTime time = DateFormat('HH:mm').parse(newTransaction['time']!);
    DateTime fullDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    spendToUpdate.amount = int.parse(newTransaction['amount']!);
    spendToUpdate.date = fullDateTime;
    // spendToUpdate.category =options.firstWhere(
    //       (option) => option.label == newTransaction['category'],
    //   orElse: () => IconOption(Icons.help, "Khác", 4),
    // ).id;
    spendToUpdate.note = newTransaction['category']!;
    spendToUpdate.type = newTransaction['type'] == 'Thu nhập' ? 2 : 1;

    await spendToUpdate.save();
  }
  Future<List<SpendModel>> getAllSpends() async{
    var box=await _box;
    return box.values.toList();
  }

  Future<void> deleteSpend(int index) async{
    var box=await _box;
    await box.deleteAt(index);
  }


  int? getKeyFromSpendModel(SpendModel model) {
    return model.isInBox ? model.key as int : null;
  }



  // Future<void> updateSpend(int index, SpendModel spend) async{
  //   var box =await _box;
  //
  // }
}
class IconOption {
  final IconData icon;
  final String label;
  final int id;

  IconOption(this.icon, this.label, this.id);
}

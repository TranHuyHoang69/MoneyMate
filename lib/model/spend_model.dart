import 'package:hive/hive.dart';

part 'spend_model.g.dart';

@HiveType(typeId: 0)
class SpendModel extends HiveObject {
  @HiveField(0)
  int amount;

  @HiveField(1)
  int category;

  @HiveField(2)
  DateTime date;

  @HiveField(3)
  String note;

  @HiveField(4)
  int type;

  SpendModel({
    required this.amount,
    required this.category,
    required this.date,
    required this.note,
    required this.type
  });
}
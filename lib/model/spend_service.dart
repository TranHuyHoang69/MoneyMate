import 'package:hive/hive.dart';
import 'package:money_mate/model/spend_model.dart';

class SpendService{
  final String _boxName="spendBox";

  Future<Box<SpendModel>> get _box async => await Hive.openBox<SpendModel>(_boxName);


  Future<void> addSpend(SpendModel spend) async{
    var box=await _box;
    await box.add(spend);
  }

  Future<List<SpendModel>> getAllSpends() async{
    var box=await _box;
    return box.values.toList();
  }

  Future<void> deleteSpend(int index) async{
    var box=await _box;
    await box.deleteAt(index);
  }

  // Future<void> updateSpend(int index, SpendModel spend) async{
  //   var box =await _box;
  //
  // }
}

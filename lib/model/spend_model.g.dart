// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spend_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SpendModelAdapter extends TypeAdapter<SpendModel> {
  @override
  final int typeId = 0;

  @override
  SpendModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SpendModel(
      amount: fields[0] as int,
      category: fields[1] as int,
      date: fields[2] as DateTime,
      note: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SpendModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.amount)
      ..writeByte(1)
      ..write(obj.category)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.note);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpendModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'FoodNutrient.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FoodNutrient _$FoodNutrientFromJson(Map<String, dynamic> json) => FoodNutrient(
      number: json['nutrientNumber'] as String?,
      name: json['name'] as String?,
      amount: (json['value'] as num?)?.toDouble(),
      unitName: json['unitName'] as String?,
      derivationCode: json['derivationCode'] as String?,
      derivationDescription: json['derivationDescription'] as String?,
    );

Map<String, dynamic> _$FoodNutrientToJson(FoodNutrient instance) =>
    <String, dynamic>{
      'nutrientNumber': instance.number,
      'name': instance.name,
      'value': instance.amount,
      'unitName': instance.unitName,
      'derivationCode': instance.derivationCode,
      'derivationDescription': instance.derivationDescription,
    };

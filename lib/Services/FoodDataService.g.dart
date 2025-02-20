// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'FoodDataService.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FoodNutrient _$FoodNutrientFromJson(Map<String, dynamic> json) => FoodNutrient(
      number: json['number'] as String?,
      name: json['name'] as String?,
      amount: (json['amount'] as num?)?.toDouble(),
      unitName: json['unitName'] as String?,
      derivationCode: json['derivationCode'] as String?,
      derivationDescription: json['derivationDescription'] as String?,
    );

Map<String, dynamic> _$FoodNutrientToJson(FoodNutrient instance) =>
    <String, dynamic>{
      'number': instance.number,
      'name': instance.name,
      'amount': instance.amount,
      'unitName': instance.unitName,
      'derivationCode': instance.derivationCode,
      'derivationDescription': instance.derivationDescription,
    };

Food _$FoodFromJson(Map<String, dynamic> json) => Food(
      dataType: json['dataType'] as String,
      description: json['description'] as String,
      fdcId: (json['fdcId'] as num).toInt(),
      foodNutrients: (json['foodNutrients'] as List<dynamic>?)
          ?.map((e) => FoodNutrient.fromJson(e as Map<String, dynamic>))
          .toList(),
      publicationDate: json['publicationDate'] as String?,
      brandOwner: json['brandOwner'] as String?,
      gtinUpc: json['gtinUpc'] as String?,
      ndbNumber: (json['ndbNumber'] as num?)?.toInt(),
      foodCode: json['foodCode'] as String?,
    );

Map<String, dynamic> _$FoodToJson(Food instance) => <String, dynamic>{
      'dataType': instance.dataType,
      'description': instance.description,
      'fdcId': instance.fdcId,
      'foodNutrients': instance.foodNutrients?.map((e) => e.toJson()).toList(),
      'publicationDate': instance.publicationDate,
      'brandOwner': instance.brandOwner,
      'gtinUpc': instance.gtinUpc,
      'ndbNumber': instance.ndbNumber,
      'foodCode': instance.foodCode,
    };

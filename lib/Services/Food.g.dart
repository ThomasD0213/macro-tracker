// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Food.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Food _$FoodFromJson(Map<String, dynamic> json) => Food(
      id: (json['id'] as num).toInt(),
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
      'id': instance.id,
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

import "package:json_annotation/json_annotation.dart";

part 'FoodNutrient.g.dart';
/// based off of AbridgedFoodNutrient schema from https://app.swaggerhub.com/apis/fdcnal/food-data_central_api/1.0.1#/AbridgedFoodNutrient
@JsonSerializable()
class FoodNutrient {
  /// **this is a guess** used by the FDC to determine nutrient type.
  @JsonKey(name: 'nutrientNumber')
  @JsonKey(name: 'number')
  final String? number; // this is a String despite the official documentation saying its an unsigned int
  /// Name of the nutrient ie. 'Iron, Fe'
  @JsonKey(name: 'name')
  @JsonKey(name: 'nutrientName')
  final String? name;
  /// amount of the nutrient in the food item it is associated with ie. 2.0
  @JsonKey(name: 'value')
  @JsonKey(name: 'amount') // this is needed because depending on which endpoint is pinged, the name changes :(
  final double? amount;
  /// the unit associated with the amount ie. 'mg', 'g'
  final String? unitName;
  /// Unknown attribute, means nothing to us (afaik atm)
  final String? derivationCode;
  /// describes the derivation ie. 'Calculated from a daily value percentage per serving size measure'
  final String? derivationDescription;

  const FoodNutrient({this.number, this.name, this.amount, this.unitName, this.derivationCode, this.derivationDescription});

  factory FoodNutrient.fromJson(Map<String, dynamic> json) => _$FoodNutrientFromJson(json);

  Map<String, dynamic> toJson() => _$FoodNutrientToJson(this);
}

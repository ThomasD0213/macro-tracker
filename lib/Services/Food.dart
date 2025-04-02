import "package:json_annotation/json_annotation.dart";
import "package:macro_tracker/Services/FoodNutrient.dart";

part 'Food.g.dart';
/// based off of AbridgedFoodItem schema from https://app.swaggerhub.com/apis/fdcnal/food-data_central_api/1.0.1#/AbridgedFoodItem
@JsonSerializable(explicitToJson: true)
class Food {
  /// Id for our local sqlite database
  final int id;
  /// Datatype as it is stored in the FDC database. ie. 'Branded'
  final String dataType; // Datatype from https://fdc.nal.usda.gov/data-documentation
  /// Description of the food item ie. 'AMERICAN CHEESE SLICE'
  final String description;
  /// ID for the specific food item in the FDC database. ie. 1592891
  final int fdcId;
  /// Collection of FoodNutrients that are in this specific food item.
  final List<FoodNutrient>? foodNutrients;
  /// The date that this specific food item was posted to the FDC database in M/D/YYYY format ie. '2021-03-19'
  final String? publicationDate;
  /// The brand that this specific food item belongs to *only relevant to foods of type 'Branded'*  ie 'Kraft Heinz Foods Company'
  final String? brandOwner;
  /// the gtinUpc for this specific item *only relevant to foods of type 'Branded'* ie. '021000036868'
  final String? gtinUpc;
  /// Only applies to Foundation and SRLegacy Foods
  final int? ndbNumber;
  /// only applies to Survey Foods
  final String? foodCode;

  const Food({required this.id, required this.dataType, required this.description, required this.fdcId,
    this.foodNutrients, this.publicationDate, this.brandOwner, this.gtinUpc, this.ndbNumber, this.foodCode});

  factory Food.fromJson(Map<String, dynamic> json) => _$FoodFromJson(json);

  Map<String, dynamic> toJson() => _$FoodToJson(this);

  Map<String, Object?> toMap() {
    return {'dataType': dataType, 'description': description, 'fdcId': fdcId, 'foodNutrients': foodNutrients, 'publicationDate': publicationDate, 'brandOwner': brandOwner, 'gtinUpc': gtinUpc, 'ndbNumber': ndbNumber, 'foodCode': foodCode};
  }
}

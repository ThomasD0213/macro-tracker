import "package:http/http.dart" as http;
import "package:json_annotation/json_annotation.dart";

part 'FoodDataService.g.dart';

/// based off of AbridgedFoodNutrient schema from https://app.swaggerhub.com/apis/fdcnal/food-data_central_api/1.0.1#/AbridgedFoodNutrient
@JsonSerializable()
class FoodNutrient {
  /// **this is a guess** used by the FDC to determine nutrient type.
  final int? number;
  /// Name of the nutrient ie. 'Iron, Fe'
  final String? name;
  /// amount of the nutrient in the food item it is associated with ie. 2.0
  final double?amount;
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

/// based off of AbridgedFoodItem schema from https://app.swaggerhub.com/apis/fdcnal/food-data_central_api/1.0.1#/AbridgedFoodItem
@JsonSerializable(explicitToJson: true)
class Food {
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

  const Food({required this.dataType, required this.description, required this.fdcId,
    this.foodNutrients, this.publicationDate, this.brandOwner, this.gtinUpc, this.ndbNumber, this.foodCode});

  factory Food.fromJson(Map<String, dynamic> json) => _$FoodFromJson(json);

  Map<String, dynamic> toJson() => _$FoodToJson(this);
}

class FoodDataService {

  static final FoodDataService _foodDataService = FoodDataService._internal(); // initializes service as a singleton
  static final String API_URL = "https://api.nal.usda.gov/fdc";
  static final String API_KEY = "DEMO_KEY"; // TODO: figure out how to do .env or safe storage of api keys
  static final String API_KEY_PARAM = "&api_key=$API_KEY";
  FoodDataService._internal();

  factory FoodDataService() {
    return _foodDataService;
  }
  // used as an example from https://docs.flutter.dev/cookbook/networking/fetch-data
  Future<http.Response> fetchFoodFromFdcId(int fdcId) {
    return http.get(Uri.parse("$API_URL/v1/food/$fdcId?format=abridged$API_KEY_PARAM"));
  }

}
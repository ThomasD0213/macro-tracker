import "dart:convert";

import "package:http/http.dart" as http;
import "package:json_annotation/json_annotation.dart";

part 'FoodDataService.g.dart';

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

  /// Returns a Future<Food> generated from a request to https://app.swaggerhub.com/apis/fdcnal/food-data_central_api/1.0.1#/FDC/getFood
  Future<Food> fetchFoodFromFdcId(int fdcId) async {
    final response = await http.get(Uri.parse("$API_URL/v1/food/$fdcId?format=abridged$API_KEY_PARAM"));
    if(response.statusCode == 200) {
      return Food.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    }
    else {
      throw Exception("failed to load food");
    }
  }

  Future<Food> fetchFoodFromGtinUpc(String gtinUpc) async {
    String dataType = "Branded"; // it is assumed that if a gtinUpc (barcode) is being read that it's a branded item
    final response = await http.get(Uri.parse("$API_URL/v1/foods/search?query=$gtinUpc&dataType=$dataType$API_KEY_PARAM"));
    if(response.statusCode == 200) {
      var prRaw = jsonDecode(response.body) as Map<String, dynamic>; //parsedResponse as raw json
      var pr = prRaw['foods'][0];
      /* if this is true, then they are using differently named keys, and we have to map them back
      * to the regular names for the jsonSerializer to instantiate the foodNutrients
      * properly. We can't just use @JsonKey('nutrientNumber') because it would
      * break fetchFoodFromFdcId(). I wish their naming was consistent :(
      * */
      if(pr['foodNutrients'].first.containsKey("nutrientNumber")) {
        for(var nutrient in pr['foodNutrients']) {
          nutrient['number'] = nutrient['nutrientNumber'];
          nutrient['name'] = nutrient['nutrientName'];
          nutrient['amount'] = nutrient['value'];
        }
      }
      return Food.fromJson(pr);
    }
    else {
      throw Exception("failed to load food");
    }

  }
}
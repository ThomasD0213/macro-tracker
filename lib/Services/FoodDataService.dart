import "package:http/http.dart" as http;

/// based off of AbridgedFoodNutrient schema from https://app.swaggerhub.com/apis/fdcnal/food-data_central_api/1.0.1#/AbridgedFoodNutrient
class FoodNutrient {
  /// **this is a guess** used by the FDC to determine nutrient type.
  int number = -1;
  /// Name of the nutrient ie. 'Iron, Fe'
  String name = "";
  /// amount of the nutrient in the food item it is associated with ie. 2.0
  double amount = 0.0;
  /// the unit associated with the amount ie. 'mg', 'g'
  String unitName = "";
  /// Unknown attribute, means nothing to us (afaik atm)
  String derivationCode = "";
  /// describes the derivation ie. 'Calculated from a daily value percentage per serving size measure'
  String derivationDescription = "";
}

/// based off of AbridgedFoodItem schema from https://app.swaggerhub.com/apis/fdcnal/food-data_central_api/1.0.1#/AbridgedFoodItem
class Food {
  /// Datatype as it is stored in the FDC database. ie. 'Branded'
  String dataType = ""; // Datatype from https://fdc.nal.usda.gov/data-documentation
  /// Description of the food item ie. 'AMERICAN CHEESE SLICE'
  String description = "";
  /// ID for the specific food item in the FDC database. ie. 1592891
  int fdcId = -1;
  /// Collection of FoodNutrients that are in this specific food item.
  List<FoodNutrient>? nutrients;
  /// The date that this specific food item was posted to the FDC database in M/D/YYYY format ie. '2021-03-19'
  String? publicationDate;
  /// The brand that this specific food item belongs to *only relevant to foods of type 'Branded'*  ie 'Kraft Heinz Foods Company'
  String? brandOwner;
  /// the gtinUpc for this specific item *only relevant to foods of type 'Branded'* ie. '021000036868'
  String? gtinUpc;
  /// Only applies to Foundation and SRLegacy Foods
  int? ndbNumber;
  /// only applies to Survey Foods
  String? foodCode;

}

class FoodDataService {

  static final FoodDataService _foodDataService = FoodDataService._internal(); // initializes service as a singleton
  static final String API_URL = "https://api.nal.usda.gov/fdc";
  static final String API_KEY = "DEMO_KEY"; // TODO: figure out how to do .env or safe storage of api keys
  static final String API_KEY_PARAM = "?api_key=$API_KEY";
  FoodDataService._internal();

  factory FoodDataService() {
    return _foodDataService;
  }
  // used as an example from https://docs.flutter.dev/cookbook/networking/fetch-data
  Future<http.Response> fetchFoodFromFdcId(int fdcId) {
    return http.get(Uri.parse("$API_URL/v1/food/$fdcId/$API_KEY_PARAM"));
  }

}
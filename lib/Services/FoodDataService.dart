import "dart:convert";

import "package:http/http.dart" as http;
import "package:json_annotation/json_annotation.dart";
import "package:macro_tracker/Services/Food.dart";
import "package:macro_tracker/Services/FoodNutrient.dart";

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
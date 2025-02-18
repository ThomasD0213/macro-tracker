import "package:http/http.dart" as http;

class FoodDataService {

  static final FoodDataService _foodDataService = FoodDataService._internal(); // initializes service as a singleton

  factory FoodDataService() {
    return _foodDataService;
  }
  // used as an example from https://docs.flutter.dev/cookbook/networking/fetch-data
  Future<http.Response> fetchAlbum() {
    return http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));
  }
  FoodDataService._internal();
}
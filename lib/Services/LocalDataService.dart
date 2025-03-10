import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class User {
  final int id;
  /// Current age of the user. Used to calculate BMR and TDEE
  final int? age;
  /// The users inputted name, used for dynamic greetings throughout the app
  final String name;
  /// weight in kg. Converted to Lbs or Stone depending on user settings
  final double? weight;
  /// height in cm. Converted to Meters or Imperial depending on user settings
  final double? height;
  /// Sex assigned at birth of the user. Determines which calculation to use for BMR and TDEE
  final String? sex;
  /// Basal Metabolic Rate, calculated using the Mifflin St. Jeor Formula
  final double? bmr;
  /// Total Daily Energy Expenditure, calculated using the BMR * (activity offset). The offset is derived from bodybuilding.com
  final double? tdee;

  const User({required this.id, required this.name, this.age, this.weight, this.height, this.sex, this.bmr, this.tdee});

  Map<String, Object?> toMap() {
    return {'id': id, 'name': name, 'age': age, 'weight': weight, 'height': height, 'sex': sex, 'bmr': bmr, 'tdee': tdee};
  }

  @override
  String toString() {
    return "User['id': $id, 'name': $name, 'age': $age, 'weight': $weight, 'height': $height, 'sex':$sex, 'bmr':$bmr, 'tdee':$tdee]";
  }

}

class LocalDataService {
  static final LocalDataService _localDataService = LocalDataService._internal(); // initializes service as a singleton
  static late final dynamic _database;
  static bool _initialized = false; // determines whether or not initDatabase needs to be called before executing a command to the database
  LocalDataService._internal();


  initDatabase() async {
    if(!_initialized) {
      _database = openDatabase(
        // Set the path to the database. Note: Using the `join` function from the
        // `path` package is best practice to ensure the path is correctly
        // constructed for each platform.
        join(await getDatabasesPath(), 'database.db'),
        onCreate: (db, version) {
          // Run the CREATE TABLE statement on the database.
          db.execute('CREATE TABLE users(id INTEGER PRIMARY KEY, name TEXT, age INTEGER, weight REAL, height REAL, sex TEXT, bmr REAL, tdee REAL)',);
        },
        // Set the version. This executes the onCreate function and provides a
        // path to perform database upgrades and downgrades.
        version: 1,
      );
      _initialized = true;
    }
    print("database already initialized");
  }

  Future<LocalDataService> getLocalDataService() async {
    if (!_initialized) {
      await initDatabase();
    }

    return _localDataService;
  }

  Future<dynamic> getDatabase() async {
    if(!_initialized) {
      await initDatabase();
    }
    return _database;
  }

  Future<void> insertUser(User user) async {
    // Get a reference to the database.
    final db = await getDatabase();

    // Insert the Dog into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertFood(Food food) async {

  }
  


}
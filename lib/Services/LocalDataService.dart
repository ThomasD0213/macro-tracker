import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:macro_tracker/Services/Food.dart';
import 'package:macro_tracker/Services/FoodNutrient.dart';
import 'package:macro_tracker/Services/User.dart';
import 'dart:async';


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

    // Insert the User into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same user is inserted twice.
    //
    // In this case, replace any previous data. As there should only be 1 user
    await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertFood(Food food) async {
    final db = await getDatabase();

    await db.insert('foods', food.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);

  }

  // A method that retrieves all the dogs from the dogs table.
  Future<List<Food>> foods() async {
    // Get a reference to the database.
    final db = await getDatabase();

    // Query the table for all the dogs.
    final List<Map<String, Object?>> foodMaps = await db.query('foods');

    // Convert the list of each dog's fields into a list of `Food` objects.
    return [
      for (final {
      'id': id as int,
      'dataType': dataType as String,
      'description': description as String,
      'fdicId': fdicId as int,
      'foodNutrients': foodNutrients as List<FoodNutrient>?,
      'publicationDate': publicationDate as String?,
      'brandOwner': brandOwner as String?,
      'gtinUpc': gtinUpc as String?,
      'ndbNumber': ndbNumber as int?,
      'foodCode': foodCode as String?
      }
      in foodMaps)
        Food(id: id, dataType: dataType, description: description, fdcId: fdicId, foodNutrients: foodNutrients, publicationDate: publicationDate, brandOwner: brandOwner, gtinUpc: gtinUpc, ndbNumber: ndbNumber, foodCode: foodCode)
    ];
  }


}
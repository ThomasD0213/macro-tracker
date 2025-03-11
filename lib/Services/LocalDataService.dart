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

    await db.insert('food', food.toMap(), conflictAlgorithm: ConflictAlgorithm.values);

  }
  


}
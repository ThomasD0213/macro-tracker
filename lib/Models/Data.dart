import "package:macro_tracker/Services/Food.dart";
import "package:macro_tracker/Services/FoodNutrient.dart";
import 'package:macro_tracker/Services/FoodDataService.dart';
import 'package:flutter/material.dart';

class Data {
  static final Data _data = Data._internal(); // initializes service as a singleton
  Data._internal();
  FoodDataService fds = FoodDataService();
  List<Food> foods = [];
  List<Widget> textBoxes = [];
  String gender = 'M';
  String name = "Username";
  num heightInInches = 70;
  num weightInPounds = 180;
  bool loseWeight = false;
  bool highProtein = false;
  bool veryActive = false;
  num age = 23;

  double totProtein = 0;
  double totCarbs = 0;
  double totFat = 0;
  double totCals = 0;

  double get bmr {
    if (gender == 'M') {
      return 66 + (6.23 * weightInPounds) + (12.7 * heightInInches) - (6.8 * age);
    } else {
      return 655 + (4.35 * weightInPounds) + (4.7 * heightInInches) - (4.7 * age);
    }
  }

  double get totalCalories {
    double multiplier = 1.2; // Sedentary by default
    if (veryActive) multiplier = 1.725;
    if (loseWeight) multiplier -= 0.2; // Reduce for weight loss
    return bmr * multiplier;
  }

  Map<String, int> getMacros() {
    double cals = totalCalories;
    int protein = highProtein ? ((cals * 0.30) / 4).round() : ((cals * 0.25) / 4).round();
    int carbs = ((cals * 0.45) / 4).round();
    int fats = ((cals * 0.30) / 9).round();
    return {'Protein': protein, 'Carbs': carbs, 'Fats': fats};
  }

  factory Data() {
    return _data;
  }

  List<Widget> getTextBoxes() {
    return textBoxes;
  }
  void addFood(String food) async {
    Food tmp = await fds.fetchFoodFromGtinUpc(food);
    foods.add(tmp);
    textBoxes.add(new Text(foods.last.description));
    var macros = getMacros();
    double protGrams = 0;
    double carbGrams = 0;
    double fatGrams = 0;
    for(Food f in foods) {
      for(FoodNutrient nutrient in f.foodNutrients!) {
        switch(nutrient.number) {
          case 203:
            protGrams += nutrient.amount!;
            break;
          case 204:
            fatGrams += nutrient.amount!;
            break;
          case 205:
            carbGrams += nutrient.amount!;
            break;
        }
      }
    }
    totProtein = protGrams / macros['Protein']!;
    totCarbs = carbGrams / macros['Carbs']!;
    totFat = fatGrams / macros['Fats']!;
    totCals = (totProtein * 4) + (totCarbs * 4) + (totFat * 9);
  }


}
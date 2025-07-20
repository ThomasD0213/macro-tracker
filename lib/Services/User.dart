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

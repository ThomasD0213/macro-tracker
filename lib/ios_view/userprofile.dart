import 'package:flutter/material.dart';


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: UserProfile(),
    );
  }
}

class UserProfile extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfile> {
  String gender = 'M';
  double heightInInches = 70; // 5'10"
  double weightInPounds = 180;
  int age = 23;

  bool loseWeight = false;
  bool highProtein = false;
  bool veryActive = false;

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

  @override
  Widget build(BuildContext context) {
    final macros = getMacros();

    return Scaffold(
      appBar: AppBar(title: Text("User's Goals")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // User Info Input
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DropdownButton<String>(
                  value: gender,
                  items: ['M', 'F'].map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                  onChanged: (val) => setState(() => gender = val!),
                ),
                SizedBox(width: 10),
                Text("Height:"),
                SizedBox(
                  width: 60,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (val) => setState(() => heightInInches = double.tryParse(val) ?? heightInInches),
                    decoration: InputDecoration(hintText: "${heightInInches.toInt()} in"),
                  ),
                ),
                Text("Weight:"),
                SizedBox(
                  width: 60,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (val) => setState(() => weightInPounds = double.tryParse(val) ?? weightInPounds),
                    decoration: InputDecoration(hintText: "${weightInPounds.toInt()} lbs"),
                  ),
                ),
                Text("Age:"),
                SizedBox(
                  width: 50,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (val) => setState(() => age = int.tryParse(val) ?? age),
                    decoration: InputDecoration(hintText: "$age"),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // BMR and Calories
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("BMR: ${bmr.round()}"),
                Text("Total Cals: ${totalCalories.round()}"),
              ],
            ),
            SizedBox(height: 20),

            // Macros
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MacroCard(label: 'Protein', value: macros['Protein']!),
                MacroCard(label: 'Carbs', value: macros['Carbs']!),
                MacroCard(label: 'Fats', value: macros['Fats']!),
              ],
            ),
            SizedBox(height: 20),

            // Checkboxes
            CheckboxListTile(
              title: Text("Lose Weight"),
              value: loseWeight,
              onChanged: (val) => setState(() => loseWeight = val!),
            ),
            CheckboxListTile(
              title: Text("High Protein"),
              value: highProtein,
              onChanged: (val) => setState(() => highProtein = val!),
            ),
            CheckboxListTile(
              title: Text("Very Active"),
              value: veryActive,
              onChanged: (val) => setState(() => veryActive = val!),
            ),
          ],
        ),
      ),
    );
  }
}

class MacroCard extends StatelessWidget {
  final String label;
  final int value;

  const MacroCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        Text("$value"),
      ],
    );
  }
}

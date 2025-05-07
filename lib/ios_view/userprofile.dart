import 'package:flutter/material.dart';
import 'package:macro_tracker/Models/Data.dart';

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

  @override
  Widget build(BuildContext context) {
    Data data = Data();
    final macros = data.getMacros();

    return Scaffold(
      appBar: AppBar(title: Text("${data.name}'s Goals")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // User Info Input
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DropdownButton<String>(
                  value: data.gender,
                  items: ['M', 'F'].map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                  onChanged: (val) => setState(() => data.gender = val!),
                ),
                SizedBox(width: 10),
                Text("Height:"),
                SizedBox(
                  width: 60,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (val) => setState(() => data.heightInInches = double.tryParse(val) ?? data.heightInInches),
                    decoration: InputDecoration(hintText: "${data.heightInInches.toInt()} in"),
                  ),
                ),
                Text("Weight:"),
                SizedBox(
                  width: 60,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (val) => setState(() => data.weightInPounds = double.tryParse(val) ?? data.weightInPounds),
                    decoration: InputDecoration(hintText: "${data.weightInPounds.toInt()} lbs"),
                  ),
                ),
                Text("Age:"),
                SizedBox(
                  width: 50,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (val) => setState(() => data.age = int.tryParse(val) ?? data.age),
                    decoration: InputDecoration(hintText: "${data.age}"),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // BMR and Calories
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("BMR: ${data.bmr.round()}"),
                Text("Total Cals: ${data.totalCalories.round()}"),
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
              value: data.loseWeight,
              onChanged: (val) => setState(() => data.loseWeight = val!),
            ),
            CheckboxListTile(
              title: Text("High Protein"),
              value: data.highProtein,
              onChanged: (val) => setState(() => data.highProtein = val!),
            ),
            CheckboxListTile(
              title: Text("Very Active"),
              value: data.veryActive,
              onChanged: (val) => setState(() => data.veryActive = val!),
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

import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'aboutpage.dart';
import 'calendar.dart';
import 'userprofile.dart';
import 'AddFood.dart';
import 'package:macro_tracker/Models/Data.dart';

void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final Data data = Data();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome ${data.name}"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircularPercentIndicator(
                radius: 120.0,
                lineWidth: 15.0,
                percent: calculateCaloriesPercent(), // 75% progress will change once we have actual values to trach
                center: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Divider(thickness: 2),
                    Text(
                      "Calories To go",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                progressColor: Colors.black,
                backgroundColor: Colors.grey.shade300,
                circularStrokeCap: CircularStrokeCap.round,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMacroIndicator("Protein", calculateProteinPercent(), Colors.purple),
                _buildMacroIndicator("Carbs", calculateFatPercent(), Colors.green),
                _buildMacroIndicator("Fats", calculateCarbsPercent(), Colors.orange),
              ],
            ),
            SizedBox(height: 20),
            Text("Recently Tracked", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Container(
              height: 100,
              margin: EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(child: ListView(
                children: data.getTextBoxes()
              )),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // Add this to highlight the selected tab
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ""), // Person icon
        ],
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 3) { // Person icon is at index 4
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AboutPage()),
            );
          }
          if (index == 1) { // Calendar icon is at index 1
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SecondRoute()),
            );
          }
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddFood()),
            );
          }
          if (index == 4) { // Notifications icon is at index 4
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UserProfile()),
            );
          }
        },
      ),
    );
  }
  double calculateCaloriesPercent() {
    // Replace with actual logic
    return data.totCals; //
  }

  double calculateProteinPercent() {
    // Replace with actual logic
    return data.totProtein; //
  }

  double calculateFatPercent() {
    // Replace with actual logic
    return data.totFat; //
  }

  double calculateCarbsPercent() {
    // Replace with actual logic
    return data.totCarbs; //
  }
}
  Widget _buildMacroIndicator(String label, double percent, Color color) {
    return CircularPercentIndicator(
      radius: 60.0,
      lineWidth: 10.0,
      percent: percent,
      center: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Divider(thickness: 1),
          Text("$label To go", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
      progressColor: color,
      backgroundColor: color.withOpacity(0.2),
      circularStrokeCap: CircularStrokeCap.round,
    );
}

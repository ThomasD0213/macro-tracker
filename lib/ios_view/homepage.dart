import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome <\$USER>"),
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
                percent: 0.75, // 75% progress
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
                _buildMacroIndicator("Protein", 0.6, Colors.purple),
                _buildMacroIndicator("Carbs", 0.5, Colors.green),
                _buildMacroIndicator("Fats", 0.4, Colors.orange),
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
              child: Center(child: Text("No data yet")),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle, size: 35), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
        ],
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
      ),
    );
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
          Text(label + " To go", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
      progressColor: color,
      backgroundColor: color.withOpacity(0.2),
      circularStrokeCap: CircularStrokeCap.round,
    );
  }
}

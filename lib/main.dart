import 'package:flutter/material.dart';
import 'package:macro_tracker/Services/FoodDataService.dart';
import 'package:macro_tracker/Views/Android/SignUp.dart';
import 'package:table_calendar/table_calendar.dart';
import "package:macro_tracker/Views/Android/CalendarPage.dart";
import 'Notifications.dart';
import 'User.dart';
import 'main_FoodDataServiceTest.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'Models/NavigationBar.dart';




/// Flutter code sample for [BottomAppBar].


void main() {
  runApp(MaterialApp(
    home: MacroTracker(),
    debugShowCheckedModeBanner: false, // Optional: removes the debug banner
  ));
}

final TextEditingController BarCodeId = TextEditingController();

class MacroTracker extends StatefulWidget {
  const MacroTracker({super.key});

  @override
  State createState() => _MacroTrackerState();
}

class _MacroTrackerState extends State<MacroTracker> {
  late Future<Food>? _foodFuture;
  bool _showNotch = true;

  void _onShowNotchChanged(bool value) {
    setState(() {
      _showNotch = value;
    });
  }

  void fetchFood(String barcode) {
    setState(() {
      _foodFuture = FoodDataService().fetchFoodFromGtinUpc(barcode);
    });
  }

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
                percent: 0.75,
                // 75% progress will change once we have actual values to trach
                center: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Divider(thickness: 2),
                    Text(
                      "Calories To go",
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
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
            Text("Recently Tracked",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Container(
              height: 200,
              width: 400,
              margin: EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: FutureBuilder<Food>(
                // future: _foodFuture could also work for below, but it makes the app not boot up att all currently so it will be a future fix
                future: FoodDataService().fetchFoodFromGtinUpc(BarCodeId.text).timeout(Duration(seconds: 10)),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    final food = snapshot.data!;
                    final nutrients = food.foodNutrients ?? [];

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${food.brandOwner}",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            "${food.description}",
                            style: TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 10),
                          Expanded( // ⛔ This causes issues inside FutureBuilder — use Flexible + set constraints instead
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: nutrients.map((nutrient) {
                                  return Text(
                                    "${nutrient.name ?? 'N/A'}: ${nutrient.amount?.toStringAsFixed(2) ?? 'N/A'} ${nutrient.unitName ?? ''}",
                                    style: TextStyle(fontSize: 12),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return const Text("No food data available.");
                  }
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: Colors.blue,
        child: IconTheme(
          data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(icon: const Icon(Icons.home), onPressed: () {}),
              IconButton(icon: const Icon(Icons.calendar_month), onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SecondRoute()));
              }),
              IconButton(icon: const Icon(Icons.add), onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  useRootNavigator: false,
                  builder: (BuildContext context) {
                    return Container(
                      height: 200,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            TextField(
                              controller: BarCodeId,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(), hintText: "Enter a barcode"),
                            ),
                            ElevatedButton(
                              child: const Text('Input Barcode'),
                              onPressed: () {
                                Navigator.pop(context);
                                fetchFood(BarCodeId.text); // 👈 Fetch dynamic food here
                              },
                            ),
                            ElevatedButton(
                              child: const Text('Close BottomSheet'),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
              IconButton(icon: const Icon(Icons.notifications), onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ThirdRoute()));
              }),
              IconButton(icon: const Icon(Icons.person), onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const FourthRoute()));
              }),
            ],
          ),
        ),
      ),
    );
  }

  // This code is to build the percentage icons.
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



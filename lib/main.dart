import 'package:flutter/material.dart';
import 'package:macro_tracker/Services/FoodDataService.dart';
import 'package:macro_tracker/Views/Android/CalendarPage.dart';
import 'package:macro_tracker/Views/Android/SignUp.dart';
import 'Notifications.dart';
import 'User.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'Models/NavigationBar.dart';

void main() {
  runApp(MaterialApp(
    home: MacroTracker(),
    debugShowCheckedModeBanner: false,
  ));
}

final TextEditingController BarCodeId = TextEditingController();

class MacroTracker extends StatefulWidget {
  const MacroTracker({super.key});

  @override
  State createState() => _MacroTrackerState();
}

class _MacroTrackerState extends State<MacroTracker> {
  Future<Food>? _foodFuture;

  void fetchFood(String barcode) {
    setState(() {
      _foodFuture = FoodDataService().fetchFoodFromGtinUpc(barcode).timeout(Duration(seconds: 10));
    });
  }

  FoodNutrient? getNutrientByName(List<FoodNutrient>? nutrients, String name) {
    return nutrients?.firstWhere((n) => n.name == name, orElse: () => FoodNutrient(name: name, amount: 0, unitName: ''));
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<Food>(
                future: _foodFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else if (snapshot.hasData) {
                    final food = snapshot.data!;
                    final energy = getNutrientByName(food.foodNutrients, 'Energy');
                    final protein = getNutrientByName(food.foodNutrients, 'Protein');
                    final carbs = getNutrientByName(food.foodNutrients, 'Carbohydrate, by difference');
                    final fats = getNutrientByName(food.foodNutrients, 'Total lipid');
                    // will have the percent for the 4 different percentages, just have energy for now. Will replace later on.
                    final energypercent = ((energy?.amount ?? 0) / 2000).clamp(0.0, 1.0);

                    return Column(
                      children: [
                        CircularPercentIndicator(
                          radius: 120.0,
                          lineWidth: 15.0,
                          percent: energypercent,
                          center: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Divider(thickness: 2),
                              Text("Calories To go", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          progressColor: Colors.black,
                          backgroundColor: Colors.grey.shade300,
                          circularStrokeCap: CircularStrokeCap.round,
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildMacroIndicator("Protein", protein?.amount ?? 0, Colors.purple),
                            _buildMacroIndicator("Carbs", carbs?.amount ?? 0, Colors.green),
                            _buildMacroIndicator("Fats", fats?.amount ?? 0, Colors.orange),
                          ],
                        ),
                      ],
                    );
                  } else {
                    return const Text("Enter a barcode to fetch food data.");
                  }
                },
              ),
              SizedBox(height: 20),
              Text("Recently Tracked", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Container(
                height: 200,
                width: 400,
                margin: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: FutureBuilder<Food>(
                  future: _foodFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.hasData) {
                      final food = snapshot.data!;
                      final nutrients = food.foodNutrients ?? [];

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "${food.brandOwner}\n${food.description}",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 10),
                              ...nutrients.map((n) => Text("${n.name}: ${n.amount} ${n.unitName}")),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return Center(child: Text("No food data available."));
                    }
                  },
                ),
              ),
            ],
          ),
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
                  builder: (BuildContext context) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        height: 250,
                        child: Column(
                          children: [
                            TextField(
                              controller: BarCodeId,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "Enter a barcode",
                              ),
                            ),
                            SizedBox(height: 10),
                            ElevatedButton(
                              child: const Text('Input Barcode'),
                              onPressed: () {
                                Navigator.pop(context);
                                fetchFood(BarCodeId.text);
                              },
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

  Widget _buildMacroIndicator(String label, double amount, Color color) {
    double percent = (amount / 2000).clamp(0.0, 1.0); // Assuming 2000 is your daily goal

    return CircularPercentIndicator(
      radius: 60.0,
      lineWidth: 10.0,
      percent: percent,
      center: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Divider(thickness: 1),
          Text("$label\n${amount.toStringAsFixed(1)}g", textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
      progressColor: color,
      backgroundColor: color.withOpacity(0.2),
      circularStrokeCap: CircularStrokeCap.round,
    );
  }
}

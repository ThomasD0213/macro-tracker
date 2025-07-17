import 'package:flutter/material.dart';
import 'Services/FoodDataService.dart';
import 'package:macro_tracker/main.dart';

class FirstRoute extends StatefulWidget {
  final String title;
  final String barcode;
  const FirstRoute({super.key, required this.title, required this.barcode});
  @override
  State<FirstRoute> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<FirstRoute> {
  int _counter = 0;
  late Future<Food> futureFood;
  var fds = FoodDataService();

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {
    super.initState();
    // futureFood = fds.fetchFoodFromFdcId(1592891);
    futureFood = fds.fetchFoodFromGtinUpc(widget.barcode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FutureBuilder<Food>(
              future: futureFood,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text("${snapshot.data!.brandOwner}\n${snapshot.data!.description}\n${snapshot.data!.foodNutrients!.first.name}\n${snapshot.data!.foodNutrients!.first.amount}");
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
              }

                // By default, show a loading spinner.
                return const CircularProgressIndicator();
              },
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

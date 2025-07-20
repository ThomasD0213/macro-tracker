import 'package:flutter/material.dart';
import "main.dart";
import 'Models/NavigationBar.dart';

class ThirdRoute extends StatelessWidget {
  const ThirdRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Third route (to become notification bar)"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ), // AppBar
      body: Center(
        child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.blue),
              foregroundColor: WidgetStateProperty.all(Colors.white)),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MacroTracker())
            );
          },
          child: const Text('Back from third route!'),
        ), // ElevatedButton
      ), // Center
      bottomNavigationBar: CustomBottomAppBar(),
    ); // Scaffold
  }
}

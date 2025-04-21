import 'package:flutter/material.dart';
import "main.dart";

class FourthRoute extends StatelessWidget {
  const FourthRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fourth route (to become User)"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ), // AppBar
      body: Center(
        child: const Text("Changed Area")
      ), // Centerd
      bottomNavigationBar: CustomBottomAppBar(),
    ); // Scaffold
  }
}

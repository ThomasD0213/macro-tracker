import 'package:flutter/material.dart';
import 'package:macro_tracker/Models/Data.dart';
import 'package:macro_tracker/Services/FoodDataService.dart';
import 'package:macro_tracker/ios_view/homepage.dart';

class AddFood extends StatelessWidget {
  const AddFood({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(appBar: AppBar(title: const Text('Barcode')), body: const Barcode()));
  }

}

class Barcode extends StatefulWidget {
  const Barcode({super.key});

  @override
  State<Barcode> createState() => _BarcodeState();
}

class _BarcodeState extends State<Barcode> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Data data = Data();
  FoodDataService fds = FoodDataService();
  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Food Barcode"),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              key: _formKey,
              child:
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                        decoration: const InputDecoration(hintText: 'enter barcode number'),
                        validator: (String? value) {
                          if(value == null || value.isEmpty) {
                            return 'please enter barcode value';
                          }
                          return null;
                        },
                        controller: myController
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: ElevatedButton(
                        onPressed: () {
// Validate will return true if the form is valid, or false if
// the form is invalid.
                          if (_formKey.currentState!.validate()) {
                            data.addFood(myController.text);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MyApp()),
                            );
                          }
                        },
                        child: const Text('Submit'),
                      ),
                    ),
                  ]
              ),
            ),

          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
        ],
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );

  }
}

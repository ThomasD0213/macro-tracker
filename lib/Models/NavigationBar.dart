// This is for the bottom bar with all the navigation options. If using multiple files, just copy paste this so that its everywhere.
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Notifications.dart';
import '../Views/Android/CalendarPage.dart';
import '../Views/Android/SignUp.dart';
import '../main.dart';
import '../main_FoodDataServiceTest.dart';

class CustomBottomAppBar extends StatelessWidget {
  const CustomBottomAppBar({
    this.shape = const CircularNotchedRectangle(),
  });

  final NotchedShape? shape;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: shape,
      color: Colors.blue,
      child: IconTheme(
        data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(tooltip: 'Navigation', icon: const Icon(Icons.home), onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FirstRoute(title: '', barcode: '',))
              );
            }),
            IconButton(tooltip: 'Calendar', icon: const Icon(Icons.calendar_month), onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SecondRoute())
              );
            }),
            IconButton(tooltip: 'Add', icon: const Icon(Icons.add), onPressed: () {
              {
                // Using the model sheet to get the look of the figma plus button pop up examplke.
                showModalBottomSheet(
                  context: context,  // Correct context for the bottom sheet
                  isScrollControlled: true,
                  useRootNavigator: false,
                  builder: (BuildContext context) {
                    return Container(
                      height: 200,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
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

                                }
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
              };
            }),
            IconButton(tooltip: 'Favorite', icon: const Icon(Icons.notifications), onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ThirdRoute())
              );
            }),
            IconButton(tooltip: 'User', icon: const Icon(Icons.person), onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FourthRoute())
              );
            }),
          ],
        ),
      ),
    );
  }
}


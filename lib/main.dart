import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import "Calendar.dart";
import 'Notifications.dart';
import 'User.dart';
import 'main_FoodDataServiceTest.dart';


/// Flutter code sample for [BottomAppBar].

void main() {
  runApp(MacroTracker());
}

class MacroTracker extends StatefulWidget {
  const MacroTracker({super.key});

  @override
  State createState() => _MacroTrackerState();
}

class _MacroTrackerState extends State<MacroTracker> {
  bool _showNotch = true;

  void _onShowNotchChanged(bool value) {
    setState(() {
      _showNotch = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(automaticallyImplyLeading: false, title: const Text('Bottom App Bar Demo')),
        body: ListView(
          padding: const EdgeInsets.only(bottom: 88),
          children: <Widget>[
            SwitchListTile( /// can be changed, just demo code
              title: const Text('Notch'),
              value: _showNotch,
              onChanged: _onShowNotchChanged,
            ),
          ],
        ),
        bottomNavigationBar: CustomBottomAppBar(
          shape: _showNotch ? const CircularNotchedRectangle() : null,
        ),
      ),
    );
  }


}

// This is for the bottom bar with all the navigation options. If using multiple files, just copy paste this so that its everywhere.
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
                  MaterialPageRoute(builder: (context) => FirstRoute(title: '',))
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
                            const Text('Modal BottomSheet'),
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


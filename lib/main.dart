import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';


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
        bottomNavigationBar: _BottomAppBar(
          shape: _showNotch ? const CircularNotchedRectangle() : null,
        ),
      ),
    );
  }
}

// This is for the bottom bar with all the navigation options. If using multiple files, just copy paste this so that its everywhere.
class _BottomAppBar extends StatelessWidget {
  const _BottomAppBar({
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
                  MaterialPageRoute(builder: (context) => FirstRoute())
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

class FirstRoute extends StatelessWidget {
  const FirstRoute({Key? key}) : super(key: key);

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

      ),
      bottomNavigationBar: _BottomAppBar(),
    ); // Scaffold
  }
}

// Calendar gotten from https://pub.dev/packages/table_calendar
class SecondRoute extends StatelessWidget {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calendar"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ), // AppBar
      body: TableCalendar(
        firstDay: DateTime.utc(2010, 10, 16),
        lastDay: DateTime.utc(2030, 3, 14),
        focusedDay: DateTime.now(),
        calendarFormat: _calendarFormat,
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          if (!isSameDay(_selectedDay, selectedDay)) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          }
        },
          onFormatChanged: (format) {
          if (_calendarFormat != format) {
            setState(() {
              _calendarFormat = format;
            });
          }
        },
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        }
      ), // Center
      bottomNavigationBar: _BottomAppBar(),
    ); // Scaffold
  }

  void setState(Null Function() param0) {}
}

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
      bottomNavigationBar: _BottomAppBar(),
    ); // Scaffold
  }
}

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
          child: const Text('Back from Fourth route!'),
        ), // ElevatedButton
      ), // Center
      bottomNavigationBar: _BottomAppBar(),
    ); // Scaffold
  }
}

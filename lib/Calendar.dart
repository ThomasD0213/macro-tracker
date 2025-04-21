import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import "main.dart";
import 'package:table_calendar/table_calendar.dart';

class SecondRoute extends StatefulWidget {
  @override
  State<SecondRoute> createState() => _SecondRouteState();
}

class _SecondRouteState extends State<SecondRoute> {
  DateTime _focusedMonth = DateTime.now();
  DateTime? _selectedDate;
  List<String> _weekdays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

  // Stores meals by normalized date
  Map<DateTime, List<String>> _meals = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Calendar")),
      body: Column(
        children: [
          _buildHeader(),
          _buildWeekDays(),
          _buildDaysGrid(),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: ElevatedButton.icon(
              onPressed: _selectedDate == null
                  ? null
                  : () => _showAddMealDialog(_selectedDate!),
              icon: Icon(Icons.restaurant),
              label: Text("Add Meal"),
            ),
          ),
          _buildMealList(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: Icon(Icons.chevron_left),
            onPressed: () {
              setState(() {
                _focusedMonth =
                    DateTime(_focusedMonth.year, _focusedMonth.month - 1);
              });
            },
          ),
          Text(
            "${_focusedMonth.month}/${_focusedMonth.year}",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: Icon(Icons.chevron_right),
            onPressed: () {
              setState(() {
                _focusedMonth =
                    DateTime(_focusedMonth.year, _focusedMonth.month + 1);
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWeekDays() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: _weekdays
          .map(
            (day) => Expanded(
          child: Center(
            child: Text(day,
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
      )
          .toList(),
    );
  }

  Widget _buildDaysGrid() {
    final firstDayOfMonth =
    DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    final daysInMonth =
    DateUtils.getDaysInMonth(_focusedMonth.year, _focusedMonth.month);
    final firstWeekday = firstDayOfMonth.weekday % 7;
    final totalGridCells = firstWeekday + daysInMonth;
    final weeks = (totalGridCells / 7).ceil();

    return Expanded(
      flex: 3,
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: weeks * 7,
        gridDelegate:
        SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
        itemBuilder: (context, index) {
          final dayNum = index - firstWeekday + 1;

          if (index < firstWeekday || dayNum > daysInMonth) {
            return Container();
          }

          final currentDay =
          DateTime(_focusedMonth.year, _focusedMonth.month, dayNum);
          final isToday = _isSameDay(currentDay, DateTime.now());
          final isSelected =
              _selectedDate != null && _isSameDay(currentDay, _selectedDate!);

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDate = currentDay;
              });
            },
            child: Container(
              margin: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue[200] : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: isToday ? Colors.red : Colors.grey.shade300),
              ),
              child: Center(
                child: Text(
                  '$dayNum',
                  style: TextStyle(
                    color: isToday ? Colors.red : Colors.black,
                    fontWeight:
                    isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMealList() {
    final selected = _normalizedDate(_selectedDate);
    final meals = _meals[selected] ?? [];

    return Expanded(
      flex: 2,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Meals",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            meals.isEmpty
                ? Text("No meals for selected date.")
                : Expanded(
              child: ListView.builder(
                itemCount: meals.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(meals[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  DateTime _normalizedDate(DateTime? date) {
    if (date == null) return DateTime.now();
    return DateTime(date.year, date.month, date.day);
  }

  void _showAddMealDialog(DateTime selectedDay) {
    final _mealController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add Meal"),
        content: TextField(
          controller: _mealController,
          decoration: InputDecoration(labelText: 'Meal Name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final mealText = _mealController.text.trim();
              if (mealText.isNotEmpty) {
                setState(() {
                  final dateKey = _normalizedDate(selectedDay);
                  if (_meals[dateKey] != null) {
                    _meals[dateKey]!.add(mealText);
                  } else {
                    _meals[dateKey] = [mealText];
                  }
                });
              }
              Navigator.pop(context);
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter_calendar/calendar.dart';
import 'package:flutter/material.dart';

class WeekCalendarView extends StatelessWidget {
  const WeekCalendarView({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Week calendar')),
        body: FlutterCalendar(
          minCalendarDate: DateTime.now().subtract(const Duration(days: 100)),
          itemBuilder: (context, date) {
            return Expanded(
              child: Card(
                child: Center(
                  child:
                      Column(children: [Center(child: Text(date.toString()))]),
                ),
              ),
            );
          },
        ),
      );
}

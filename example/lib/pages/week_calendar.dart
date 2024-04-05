import 'dart:developer';

import 'package:calendar/calendar.dart';
import 'package:flutter/material.dart';

class WeekCalendarView extends StatelessWidget {
  const WeekCalendarView({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Week calendar'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              BasicCalendar(
                minCalendarDate:
                    DateTime.now().subtract(const Duration(days: 100)),
                onSelectadDayChange: (date) {
                  log(date.toString());
                },
              ),
            ],
          ),
        ),
      );
}

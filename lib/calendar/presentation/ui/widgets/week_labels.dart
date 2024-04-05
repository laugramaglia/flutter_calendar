import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum DaysDisplayFormat {
  full,
  short,
  singleLetter;

  String format(DateTime date) => switch (this) {
        DaysDisplayFormat.full => DateFormat.EEEE().format(date),
        DaysDisplayFormat.short => DateFormat.E().format(date),
        DaysDisplayFormat.singleLetter => DateFormat.E().format(date)[0],
      };
}

class WeekLabels extends StatefulWidget {
  final int initialDayOfTheWeek;
  final DaysDisplayFormat
      displayDayFormat; // Display day abbreviation (e.g., Mon)
  final TextStyle? textStyle;
  final double crossAxisSpacing, mainAxisSpacing;
  const WeekLabels({
    super.key,
    this.initialDayOfTheWeek = DateTime.sunday,
    this.displayDayFormat = DaysDisplayFormat.short,
    this.textStyle,
    this.crossAxisSpacing = 8,
    this.mainAxisSpacing = 8,
  });

  @override
  State<WeekLabels> createState() => _WeekLabelsState();
}

class _WeekLabelsState extends State<WeekLabels> {
  final DateTime today = DateTime.now();
  late List<DateTime> weekDays;
  final int _daysOfWeek = 7;

  @override
  Widget build(BuildContext context) => GridView.count(
        shrinkWrap: true,
        childAspectRatio: 2,
        crossAxisSpacing: widget.crossAxisSpacing,
        mainAxisSpacing: widget.mainAxisSpacing,
        crossAxisCount: _daysOfWeek,
        children: _buildWeekDays,
      );

  List<Widget> get _buildWeekDays => List<Widget>.generate(
        _daysOfWeek,
        (index) {
          int offset = today.weekday - widget.initialDayOfTheWeek;
          final day = today.subtract(Duration(days: offset - index));
          return _buildDayCell(day);
        },
      );

  Widget _buildDayCell(DateTime day) => Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            widget.displayDayFormat
                .format(day), // Display day abbreviation (e.g., Mon)
            style: widget.textStyle ??
                Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: day.weekday == DateTime.saturday ||
                            day.weekday == DateTime.sunday
                        ? Colors.black87
                        : Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.bold),
          ),
        ),
      );
}

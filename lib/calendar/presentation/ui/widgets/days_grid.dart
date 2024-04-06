import 'package:flutter/material.dart';

enum DayDesign { square, circle, rounded }

class DaysGrid extends StatelessWidget {
  final int initialDayOfTheWeek;
  final double crossAxisSpacing, mainAxisSpacing;
  final DateTime dayOfWeekSelected, weekGenerator;
  final DayDesign dayDesign;
  final void Function(DateTime)? onSelectDay;
  final List<DateTime>? highlightedDates;
  final List<Color> highlightedDatesColors;

  const DaysGrid({
    super.key,
    this.crossAxisSpacing = 8,
    this.mainAxisSpacing = 8,
    this.initialDayOfTheWeek = DateTime.sunday,
    required this.dayOfWeekSelected,
    this.dayDesign = DayDesign.circle,
    this.onSelectDay,
    required this.weekGenerator,
    this.highlightedDates,
    required this.highlightedDatesColors,
  });

  final int _daysOfWeek = 7;
  @override
  Widget build(BuildContext context) {
    return GridView.count(
        shrinkWrap: true,
        crossAxisCount: _daysOfWeek,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
        children: List<Widget>.generate(_daysOfWeek, (index) {
          int offset =
              weekGenerator.weekday - initialDayOfTheWeek + _daysOfWeek - index;
          final DateTime date = weekGenerator.subtract(Duration(days: offset));

          final daySelected = date.day == dayOfWeekSelected.day &&
              date.month == dayOfWeekSelected.month &&
              date.year == dayOfWeekSelected.year;
          return _uiSelector(context, daySelected, date);
        }));
  }

  Widget _uiSelector(BuildContext context, daySelected, date) =>
      switch (dayDesign) {
        DayDesign.square => _squareDay(context, daySelected, date),
        DayDesign.circle => _circleDay(context, daySelected, date),
        DayDesign.rounded => _roundedDay(context, daySelected, date),
      };

  Widget _squareDay(BuildContext context, bool daySelected, DateTime date) =>
      Ink(
        decoration: BoxDecoration(
          border: _border(context, date, daySelected),
          color: _dayBackgroundColor(context, daySelected),
        ),
        child: _dayTextWidget(date, context, daySelected, 0),
      );

  Widget _roundedDay(BuildContext context, bool daySelected, DateTime date) =>
      Ink(
        decoration: BoxDecoration(
            border: _border(context, date, daySelected),
            color: _dayBackgroundColor(context, daySelected),
            borderRadius: BorderRadius.circular(8)),
        child: _dayTextWidget(date, context, daySelected, 8),
      );
  Widget _circleDay(BuildContext context, bool daySelected, DateTime date) =>
      Ink(
        decoration: BoxDecoration(
          border: _border(context, date, daySelected),
          shape: BoxShape.circle,
          color: _dayBackgroundColor(context, daySelected),
        ),
        child: _dayTextWidget(date, context, daySelected, 100),
      );

  Widget _dayTextWidget(DateTime date, BuildContext context, bool daySelected,
      [double? radius]) {
    return InkWell(
      onTap: () {
        onSelectDay?.call(date);
      },
      borderRadius: radius == null ? null : BorderRadius.circular(radius),
      child: Stack(
        children: [
          Center(
            child: Text(
              date.day.toString(),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: daySelected
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onPrimaryContainer,
                  fontWeight:
                      daySelected ? FontWeight.bold : FontWeight.normal),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: date.matchAny(highlightedDates) && !daySelected ? 1 : 0,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Icon(
                    Icons.circle,
                    size: 7,
                    color: highlightedDatesColors.first,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _dayBackgroundColor(BuildContext context, bool daySelected) {
    return Theme.of(context)
        .colorScheme
        .primary
        .withOpacity(daySelected ? 1 : 0.1);
  }

  Border? _border(BuildContext context, DateTime date, bool daySelected) =>
      date.isSameDay(DateTime.now())
          ? daySelected
              ? null
              : Border.all()
          : null;
}

extension DateTimeExtension on DateTime {
  bool isSameDay(DateTime other) =>
      day == other.day && month == other.month && year == other.year;

  bool matchAny(List<DateTime>? dates) => dates == null || dates.isEmpty
      ? false
      : dates.any((element) => isSameDay(element));
}

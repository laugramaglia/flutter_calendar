import 'package:flutter/material.dart';
import 'package:flutter_calendar/calendar/presentation/ui/widgets/days_grid.dart';
import 'package:flutter_calendar/calendar/presentation/ui/widgets/week_labels.dart';
import 'package:intl/intl.dart';

class FlutterCalendar extends StatefulWidget {
  final bool displayOptions;
  final int initialDayOfTheWeek;
  final DateTime? selectedDate;
  final DateTime minCalendarDate;
  final Function(DateTime)? onSelectadDayChange;
  final double crossAxisSpacing, mainAxisSpacing;
  final Widget Function(BuildContext context, DateTime date)? itemBuilder;
  final List<DateTime>? highlightedDates;
  final List<Color>? highlightedDatesColors;

  const FlutterCalendar({
    super.key,
    this.displayOptions = true,
    this.initialDayOfTheWeek = DateTime.sunday,
    this.onSelectadDayChange,
    this.selectedDate,
    this.crossAxisSpacing = 8,
    this.mainAxisSpacing = 8,
    required this.minCalendarDate,
    this.itemBuilder,
    this.highlightedDates,
    this.highlightedDatesColors,
  });

  factory FlutterCalendar.builder({
    required Widget Function(BuildContext context, DateTime date) itemBuilder,
    required DateTime minCalendarDate,
    Function(DateTime)? onSelectadDayChange,
    bool displayOptions = true,
    int initialDayOfTheWeek = DateTime.sunday,
    DateTime? selectedDate,
    double crossAxisSpacing = 8,
    double mainAxisSpacing = 8,
    List<DateTime>? highlightedDates,
    List<Color>? highlightedDatesColors,
  }) =>
      FlutterCalendar(
        displayOptions: displayOptions,
        initialDayOfTheWeek: initialDayOfTheWeek,
        onSelectadDayChange: onSelectadDayChange,
        selectedDate: selectedDate,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
        minCalendarDate: minCalendarDate,
        itemBuilder: itemBuilder,
        highlightedDates: highlightedDates,
        highlightedDatesColors: highlightedDatesColors,
      );

  @override
  State<FlutterCalendar> createState() => _FlutterCalendarState();
}

class _FlutterCalendarState extends State<FlutterCalendar> {
  late DateTime selectedDate;
  late final PageController _dayPageController;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.selectedDate ?? DateTime.now();

    final int initialPage =
        (selectedDate.difference(widget.minCalendarDate)).inDays ~/ 7;
    _dayPageController =
        PageController(initialPage: initialPage, keepPage: true);
  }

  @override
  Widget build(BuildContext context) => Material(
        child: Column(
          children: [
            if (widget.displayOptions)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  // currten month year
                  Text(
                      DateFormat(DateFormat.MONTH_WEEKDAY_DAY)
                          .format(selectedDate),
                      style: Theme.of(context).textTheme.bodyLarge),

                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.chevron_left),
                        onPressed: () {
                          _dayPageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right),
                        onPressed: () {
                          _dayPageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            WeekLabels(
              displayDayFormat: DaysDisplayFormat.singleLetter,
              crossAxisSpacing: widget.crossAxisSpacing,
              mainAxisSpacing: widget.mainAxisSpacing,
              initialDayOfTheWeek: widget.initialDayOfTheWeek,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: AspectRatio(
                aspectRatio: 7,
                child: PageView.builder(
                    controller: _dayPageController,
                    itemBuilder: (context, index) => DaysGrid(
                          crossAxisSpacing: widget.crossAxisSpacing,
                          mainAxisSpacing: widget.mainAxisSpacing,
                          initialDayOfTheWeek: widget.initialDayOfTheWeek,
                          dayOfWeekSelected: selectedDate,
                          weekGenerator: widget.minCalendarDate
                              .add(Duration(days: index * 7)),
                          highlightedDates: widget.highlightedDates,
                          highlightedDatesColors:
                              widget.highlightedDatesColors ??
                                  [Theme.of(context).colorScheme.secondary],
                          onSelectDay: (date) {
                            setState(() {
                              selectedDate = date;
                              widget.onSelectadDayChange?.call(selectedDate);
                            });
                          },
                        )),
              ),
            ),
            if (widget.itemBuilder case final itemBuilder?) ...[
              const Divider(),
              itemBuilder(context, selectedDate),
            ]
          ],
        ),
      );
}

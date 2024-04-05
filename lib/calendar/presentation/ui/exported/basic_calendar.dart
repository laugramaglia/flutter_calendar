import 'package:calendar/calendar/presentation/ui/widgets/days_grid.dart';
import 'package:calendar/calendar/presentation/ui/widgets/week_labels.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BasicCalendar extends StatefulWidget {
  final bool displayOptions;
  final int initialDayOfTheWeek;
  final DateTime? selectedDate, minCalendarDate;
  final Function(DateTime) onSelectadDayChange;
  final double crossAxisSpacing, mainAxisSpacing;

  const BasicCalendar({
    super.key,
    this.displayOptions = true,
    this.initialDayOfTheWeek = DateTime.sunday,
    required this.onSelectadDayChange,
    this.selectedDate,
    this.crossAxisSpacing = 8,
    this.mainAxisSpacing = 8,
    this.minCalendarDate,
  });

  @override
  State<BasicCalendar> createState() => _BasicCalendarState();
}

class _BasicCalendarState extends State<BasicCalendar> {
  late DateTime selectedDate;
  late final PageController _dayPageController;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.selectedDate ?? DateTime.now();

    final int initialPage =
        (selectedDate.difference(widget.minCalendarDate!)).inDays ~/ 7;
    _dayPageController =
        PageController(initialPage: initialPage, keepPage: true);
  }

  @override
  Widget build(BuildContext context) => Material(
          child: Container(
        padding: const EdgeInsets.all(8),
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
                          weekGenerator:
                              (widget.minCalendarDate ?? DateTime.now())
                                  .add(Duration(days: index * 7)),
                          onSelectDay: (date) {
                            setState(() {
                              selectedDate = date;
                              widget.onSelectadDayChange(selectedDate);
                            });
                          },
                        )),
              ),
            ),
          ],
        ),
      ));
}

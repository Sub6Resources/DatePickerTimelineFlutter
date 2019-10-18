library date_picker_timeline;


export 'date_picker_widget.dart';

import 'package:date_picker_timeline/date_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

/// Signature for a function that is called when selected date is changed
///
/// Used by [DatePickerTimeline] for tap detection.
typedef DateChangeListener = void Function(DateTime selectedDate);

class DatePickerTimeline extends StatefulWidget {
  final double width;
  final double height;

  final TextStyle yearTextStyle, monthTextStyle, dayTextStyle, dateTextStyle;
  final Color selectionColor;
  final DateTime currentDate;
  final DateTime startDate;
  final DateChangeListener onDateChange;
  final int daysCount;
  final String locale;

  // Creates the DatePickerTimeline Widget
  DatePickerTimeline(
    this.currentDate, {
    Key key,
    this.width,
    this.height = 100,
    this.yearTextStyle,
    this.monthTextStyle,
    this.dayTextStyle,
    this.dateTextStyle,
    this.selectionColor,
    this.startDate,
    this.daysCount = 50000,
    this.onDateChange,
    this.locale = "en_US",
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _DatePickerState();
}

class _DatePickerState extends State<DatePickerTimeline> with WidgetsBindingObserver {
  ScrollController _scrollController;

  double _width;
  DateTime _currentDate;

  @override
  void initState() {
    super.initState();
    _currentDate = widget.currentDate;
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _width = context.size.width / 2 - 35;
      _scrollController.jumpTo(
        Duration(
                  milliseconds: widget.currentDate.millisecondsSinceEpoch -
                      widget.startDate.millisecondsSinceEpoch,
                ).inDays *
                70.0 -
            _width,
      );
    });
    initializeDateFormatting(widget.locale, null);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      child: ListView.builder(
        itemCount: widget.daysCount,
        scrollDirection: Axis.horizontal,
        controller: _scrollController,
        padding: EdgeInsets.zero,
        itemBuilder: (_, index) {
          // Return the Date Widget
          DateTime _date = (widget.startDate ?? DateTime.now()).add(Duration(days: index));
          DateTime date = new DateTime(_date.year, _date.month, _date.day);
          bool isSelected = compareDate(date, _currentDate);

          return DateWidget(
            date: date,
            yearTextStyle: widget.yearTextStyle ?? Theme.of(context).textTheme.overline.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
            monthTextStyle: widget.monthTextStyle ?? Theme.of(context).textTheme.body1.copyWith(
              fontWeight: FontWeight.bold,
            ),
            dateTextStyle: widget.dateTextStyle ?? Theme.of(context).textTheme.title.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            dayTextStyle: widget.dayTextStyle ?? Theme.of(context).textTheme.body1.copyWith(
              fontWeight: FontWeight.bold,
            ),
            locale: widget.locale,
            selectionColor: isSelected ? (widget.selectionColor ?? Theme.of(context).splashColor) : Colors.transparent,
            onDateSelected: (selectedDate) {
              // A date is selected
              if (widget.onDateChange != null) {
                widget.onDateChange(selectedDate);
              }
              setState(() {
                _currentDate = selectedDate;
              });
              _width = context.size.width / 2 - 35;
              _scrollController.animateTo(
                index * 70.0 - _width,
                duration: Duration(milliseconds: 200),
                curve: Curves.easeIn,
              );
            },
          );
        },
      ),
    );
  }

  bool compareDate(DateTime date1, DateTime date2) {
    return date1.day == date2.day && date1.month == date2.month && date1.year == date2.year;
  }
}

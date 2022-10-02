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
    _currentDate = removeTime(widget.currentDate);
    _scrollController = ScrollController();
    if (_currentDate != null) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          _width = context.size.width / 2 - 35;
          final startDate = removeTime(widget.startDate ?? DateTime.now());
          _scrollController.jumpTo(_currentDate.difference(startDate).inDays * 70.0 - _width);
        },
      );
    }
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
        itemBuilder: (_, i) {
          // Return the Date Widget
          DateTime _date = removeTime(widget.startDate ?? DateTime.now()).add(Duration(days: i));
          bool isSelected = _currentDate != null && compareDate(_date, _currentDate);

          return DateWidget(
            date: _date,
            yearTextStyle: widget.yearTextStyle ??
                Theme.of(context).textTheme.overline.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
            monthTextStyle: widget.monthTextStyle ??
                Theme.of(context).textTheme.body1.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
            dateTextStyle: widget.dateTextStyle ??
                Theme.of(context).textTheme.title.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
            dayTextStyle: widget.dayTextStyle ??
                Theme.of(context).textTheme.body1.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
            locale: widget.locale,
            selectionColor: isSelected
                ? (widget.selectionColor ?? Theme.of(context).splashColor)
                : Colors.transparent,
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
                i * 70.0 - _width,
                duration: Duration(milliseconds: 200),
                curve: Curves.easeIn,
              );
            },
          );
        },
      ),
    );
  }

  DateTime removeTime(DateTime dateTime) {
    if (dateTime == null) return null;
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  bool compareDate(DateTime date1, DateTime date2) {
    return date1.day == date2.day && date1.month == date2.month && date1.year == date2.year;
  }
}

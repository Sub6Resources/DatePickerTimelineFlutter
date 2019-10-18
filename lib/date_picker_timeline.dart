library date_picker_timeline;


export 'date_picker_widget.dart';

import 'package:date_picker_timeline/date_widget.dart';
import 'package:date_picker_timeline/extra/color.dart';
import 'package:date_picker_timeline/extra/style.dart';
import 'package:date_picker_timeline/gestures/tap.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

class DatePickerTimeline extends StatefulWidget {
  double width;
  double height;

  TextStyle yearTextStyle, monthTextStyle, dayTextStyle, dateTextStyle;
  Color selectionColor;
  DateTime currentDate;
  DateTime startDate;
  DateChangeListener onDateChange;
  int daysCount;
  String locale;

  // Creates the DatePickerTimeline Widget
  DatePickerTimeline(
    this.currentDate, {
    Key key,
    this.width,
    this.height = 100,
    this.yearTextStyle = defaultYearTextStyle,
    this.monthTextStyle = defaultMonthTextStyle,
    this.dayTextStyle = defaultDayTextStyle,
    this.dateTextStyle = defaultDateTextStyle,
    this.selectionColor = AppColors.defaultSelectionColor,
    this.startDate,
    this.daysCount = 50000,
    this.onDateChange,
    this.locale = "en_US",
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _DatePickerState();
}

class _DatePickerState extends State<DatePickerTimeline> {
  ScrollController _scrollController;

  double _width;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _width = WidgetsBinding.instance.renderView.size.width / 2 - 56;
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
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      child: ListView.builder(
        itemCount: widget.daysCount,
        scrollDirection: Axis.horizontal,
        controller: _scrollController,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          // Return the Date Widget
          DateTime _date = (widget.startDate ?? DateTime.now()).add(Duration(days: index));
          DateTime date = new DateTime(_date.year, _date.month, _date.day);
          bool isSelected = compareDate(date, widget.currentDate);

          return DateWidget(
            date: date,
            yearTextStyle: widget.yearTextStyle,
            monthTextStyle: widget.monthTextStyle,
            dateTextStyle: widget.dateTextStyle,
            dayTextStyle: widget.dayTextStyle,
            locale: widget.locale,
            selectionColor: isSelected ? widget.selectionColor : Colors.transparent,
            onDateSelected: (selectedDate) {
              // A date is selected
              if (widget.onDateChange != null) {
                widget.onDateChange(selectedDate);
              }
              setState(() {
                widget.currentDate = selectedDate;
              });
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

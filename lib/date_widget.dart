import 'package:date_picker_timeline/date_picker_timeline.dart';
/// ***
/// This class consists of the DateWidget that is used in the ListView.builder
///
/// Author: Vivek Kaushik <me@vivekkasuhik.com>
/// github: https://github.com/iamvivekkaushik/
/// ***

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateWidget extends StatelessWidget {
  final DateTime date;
  final TextStyle yearTextStyle, monthTextStyle, dayTextStyle, dateTextStyle;
  final Color selectionColor;
  final DateChangeListener onDateSelected;
  final String locale;

  DateWidget(
      {@required this.date,
      @required this.yearTextStyle,
      @required this.monthTextStyle,
      @required this.dayTextStyle,
      @required this.dateTextStyle,
      @required this.selectionColor,
      this.onDateSelected,
      this.locale,
      });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        margin: EdgeInsets.all(3.0),
        width: 64,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          color: selectionColor,
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 15, right: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(new DateFormat("E", locale).format(date).toUpperCase(), // WeekDay
                  style: dayTextStyle),
              Text(new DateFormat("dd", locale).format(date).toUpperCase(), // Date
                  style: dateTextStyle),
              Text(new DateFormat("MMM", locale).format(date).toUpperCase(), // Month
                  style: monthTextStyle),
              SizedBox(height: 4),
              Text(new DateFormat("yyyy", locale).format(date).toUpperCase(),
                style: yearTextStyle),

            ],
          ),
        ),
      ),
      onTap: () {
        // Check if onDateSelected is not null
        if (onDateSelected != null) {
          // Call the onDateSelected Function
          onDateSelected(this.date);
        }
      },
    );
  }
}

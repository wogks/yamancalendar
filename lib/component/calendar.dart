import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:videocall2/const/colors.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime? selectedDay;

  final defaultBoxDeco = BoxDecoration(
    color: Colors.grey[200],
    borderRadius: BorderRadius.circular(6),
  );

  final defaultTextStyle = TextStyle(
    color: Colors.grey[600],
    fontWeight: FontWeight.w700,
  );
  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      focusedDay: DateTime.now(),
      firstDay: DateTime(1800),
      lastDay: DateTime(3000),
      headerStyle: const HeaderStyle(
        //몇주치를 보여줄건지
        formatButtonVisible: false,
        titleCentered: true,
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
      ),
      calendarStyle: CalendarStyle(
        //오늘날짜 표시
        isTodayHighlighted: false,
        //날짜가 들어있는 컨테이너를 데코레이션(주말제외)
        defaultDecoration: defaultBoxDeco,
        //주말 데코
        weekendDecoration: defaultBoxDeco,
        //선택된 박스 데코
        selectedDecoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          //테두리
          border: Border.all(
            width: 1,
            color: PRIMARY_COLOR,
          ),
        ),
        defaultTextStyle: defaultTextStyle,
        weekendTextStyle: defaultTextStyle,
        selectedTextStyle: defaultTextStyle.copyWith(color: PRIMARY_COLOR),
      ),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          this.selectedDay = selectedDay;
        });
      },
      //누른날짜에 색칠
      selectedDayPredicate: (day) {
        //day == selectedDay; 이렇게 안하는 이유는 시, 분,초 까지 같을 필요가 없기 때문
        if (selectedDay == null) {
          return false;
        }
        return day.year == selectedDay!.year &&
            day.month == selectedDay!.month &&
            day.day == selectedDay!.day;
      },
    );
  }
}

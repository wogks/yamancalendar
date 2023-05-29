import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:videocall2/const/colors.dart';

class Calendar extends StatelessWidget {
  final DateTime? selectedDay;
  final DateTime focusedDay;
  final OnDaySelected onDaySelected;
  Calendar({
    super.key,
    required this.selectedDay,
    required this.focusedDay,
    required this.onDaySelected,
  });
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
      //언어
      locale: 'ko_KR',
      focusedDay: focusedDay,
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
        //기본값이 동그라미라서 다른달의 날짜를 선택하면 에러가난다
        outsideDecoration: const BoxDecoration(
          shape: BoxShape.rectangle,
        ),
      ),
      onDaySelected: onDaySelected,
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

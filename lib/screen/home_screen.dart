import 'package:flutter/material.dart';
import 'package:videocall2/component/calendar.dart';
import 'package:videocall2/component/schedule_card.dart';
import 'package:videocall2/component/today_banner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDay = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  DateTime focusedDay = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Calendar(
              focusedDay: focusedDay,
              selectedDay: selectedDay,
              onDaySelected: onDaySelected,
            ),
            const SizedBox(height: 8),
            TodayBanner(
              //널이 안되게 위에 스테이트에서 오늘 날짜로 초기화
              selectedDay: selectedDay,
              scheduledCount: 3,
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: ScheduleCard(
                startTime: 9,
                endTime: 14,
                content: '공부하기',
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  onDaySelected(selectedDay, focusedDay) {
    setState(() {
      this.selectedDay = selectedDay;
      //다른달의 날짜를 선택하면 달력이 이동한다
      this.focusedDay = selectedDay;
    });
  }
}

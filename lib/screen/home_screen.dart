import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:videocall2/component/calendar.dart';
import 'package:videocall2/component/schedule_bottom_sheet.dart';
import 'package:videocall2/component/schedule_card.dart';
import 'package:videocall2/component/today_banner.dart';
import 'package:videocall2/const/colors.dart';
import 'package:videocall2/database/drift_database.dart';

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
      floatingActionButton: renderFloatingActionbutton(),
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
            const _ScheduleList(),
          ],
        ),
      ),
    );
  }

  FloatingActionButton renderFloatingActionbutton() {
    return FloatingActionButton(
      backgroundColor: PRIMARY_COLOR,
      child: const Icon(Icons.add),
      onPressed: () {
        showModalBottomSheet(
          //바텀시트는 원래 화면의 반이 최대사이즈이지만 이걸 트루로 하면 키보드보다 위로 더 올라온다
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return ScheduleBottomSheet(
              selectedDate: selectedDay,
            );
          },
        );
      },
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

class _ScheduleList extends StatelessWidget {
  const _ScheduleList();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: StreamBuilder<List<Schedule>>(
              stream: GetIt.I<LocalDatabase>().watchSchedules(),
              builder: (context, snapshot) {
                print(snapshot.data);
                return ListView.separated(
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return const ScheduleCard(
                      startTime: 9,
                      endTime: 14,
                      content: '공부하기',
                      color: Colors.red,
                    );
                  },
                );
              })),
    );
  }
}

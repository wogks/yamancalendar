import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:videocall2/component/calendar.dart';
import 'package:videocall2/component/schedule_bottom_sheet.dart';
import 'package:videocall2/component/schedule_card.dart';
import 'package:videocall2/component/today_banner.dart';
import 'package:videocall2/const/colors.dart';
import 'package:videocall2/database/drift_database.dart';
import 'package:videocall2/model/schedule_with_color.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDay = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  DateTime focusedDay = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Schedule>(
        future: null,
        builder: (context, snapshot) {
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
                  ),
                  const SizedBox(height: 8),
                  _ScheduleList(selectedDate: selectedDay),
                ],
              ),
            ),
          );
        });
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
  final DateTime selectedDate;
  const _ScheduleList({required this.selectedDate});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: StreamBuilder<List<ScheduleWithColor>>(
              stream: GetIt.I<LocalDatabase>().watchSchedules(selectedDate),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasData && snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('데이터가 없습니다.'),
                  );
                }
                return ListView.separated(
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final scheduleWithColor = snapshot.data![index];
                    return Dismissible(
                      key: ObjectKey(scheduleWithColor.schedule.id),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        GetIt.I<LocalDatabase>()
                            .removeSchedule(scheduleWithColor.schedule.id);
                      },
                      child: GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            //바텀시트는 원래 화면의 반이 최대사이즈이지만 이걸 트루로 하면 키보드보다 위로 더 올라온다
                            isScrollControlled: true,
                            context: context,
                            builder: (context) {
                              return ScheduleBottomSheet(
                                selectedDate: selectedDate,
                                scheduleID: scheduleWithColor.schedule.id,
                              );
                            },
                          );
                        },
                        child: ScheduleCard(
                          startTime: scheduleWithColor.schedule.startTime,
                          endTime: scheduleWithColor.schedule.endTime,
                          content: scheduleWithColor.schedule.content,
                          color: Color(int.parse(
                              'FF${scheduleWithColor.categoryColor.hexCode}',
                              radix: 16)),
                        ),
                      ),
                    );
                  },
                );
              })),
    );
  }
}

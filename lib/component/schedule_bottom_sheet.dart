import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:videocall2/component/custom_text_field.dart';
import 'package:videocall2/const/colors.dart';
import 'package:videocall2/database/drift_database.dart';

class ScheduleBottomSheet extends StatefulWidget {
  final DateTime selectedDate;
  final int? scheduleID;
  const ScheduleBottomSheet(
      {super.key, this.scheduleID, required this.selectedDate});

  @override
  State<ScheduleBottomSheet> createState() => _ScheduleBottomSheetState();
}

class _ScheduleBottomSheetState extends State<ScheduleBottomSheet> {
  final GlobalKey<FormState> formKey = GlobalKey();

  //처음에 저장을 누르지 않았을때는 값이 없기때문에 널일 수 있다
  int? startTime;
  int? endTime;
  String? content;
  int? selectedColorId;

  @override
  Widget build(BuildContext context) {
    //핸드폰에서 시스템이 유아이를 차지하는 부분(이만큼 바텀시트에 패딩을 주지 않으면 키보드에 텍스트필드가 가려진다)
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: FutureBuilder<Schedule>(
          future: widget.scheduleID == null
              ? null
              : GetIt.I<LocalDatabase>().getScheduleById(widget.scheduleID!),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('스케줄을 불러올 수 없습니다.'),
              );
            }
            //futurebuilder 처음 실행했고 로딩중일때
            if (snapshot.connectionState != ConnectionState.none &&
                !snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            //future가 실행이 되고 값이 있는데 단 한번도 starttime이 세팅되지 않았을때
            if (snapshot.hasData && startTime == null) {
              startTime = snapshot.data!.startTime;
              endTime = snapshot.data!.endTime;
              content = snapshot.data!.content;
              selectedColorId = snapshot.data!.colorId;
            }

            return SafeArea(
              child: Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.height / 2 + bottomInset,
                child: Padding(
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8, top: 16),
                    child: Form(
                      //따로 버튼을 누르지 않아도 자동으로 밸리데이트 해줌
                      // autovalidateMode: AutovalidateMode.always,
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _Time(
                            startInitialValue: startTime?.toString() ?? '',
                            endInitialValue: endTime?.toString() ?? '',
                            onEndSaved: (newValue) {
                              //이미 폼필드에서 값이 아무것도 들어있지 않으면 안되게 해놨기때문에 느낌표 가능
                              endTime = int.parse(newValue!);
                            },
                            onStartSaved: (newValue) {
                              startTime = int.parse(newValue!);
                            },
                          ),
                          const SizedBox(height: 16),
                          _Contents(
                            initialValue: content ?? '',
                            onSaved: (newValue) {
                              content = newValue;
                            },
                          ),
                          const SizedBox(height: 16),
                          FutureBuilder<List<CategoryColor>>(
                            future:
                                GetIt.I<LocalDatabase>().getCategoryColors(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData &&
                                  selectedColorId == null &&
                                  snapshot.data!.isNotEmpty) {
                                selectedColorId == snapshot.data![0].id;
                              }
                              return _ColorPicker(
                                colorIdSetter: (id) {
                                  setState(() {
                                    selectedColorId = id;
                                  });
                                },
                                colors: snapshot.hasData ? snapshot.data! : [],
                                selectedColorId: selectedColorId ?? 1,
                              );
                            },
                          ),
                          const SizedBox(height: 8),
                          _SaveButton(
                            onPressed: onSavePressed,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  void onSavePressed() async {
    //formkey는 생성을 했는데 form위젯과 결합을 안했을때
    if (formKey.currentState == null) {
      return;
    }
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      if (widget.scheduleID == null) {
        await GetIt.I<LocalDatabase>().createSchedule(SchedulesCompanion(
          date: Value(widget.selectedDate),
          startTime: Value(startTime!),
          endTime: Value(endTime!),
          content: Value(content!),
          colorId: Value(selectedColorId ?? 0),
        ));
      } else {
        await GetIt.I<LocalDatabase>().updateScheduleById(
            widget.scheduleID!,
            SchedulesCompanion(
              date: Value(widget.selectedDate),
              startTime: Value(startTime!),
              endTime: Value(endTime!),
              content: Value(content!),
              colorId: Value(selectedColorId ?? 0),
            ));
      }

      Navigator.of(context).pop();
    } else {}
  }
}

class _Time extends StatelessWidget {
  final FormFieldSetter<String> onStartSaved;
  final FormFieldSetter<String> onEndSaved;
  final String startInitialValue;
  final String endInitialValue;
  const _Time({
    required this.onStartSaved,
    required this.onEndSaved,
    required this.startInitialValue,
    required this.endInitialValue,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomTextField(
            onSaved: onStartSaved,
            label: '시작시간',
            isTime: true,
            initialValue: startInitialValue,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: CustomTextField(
            onSaved: onEndSaved,
            label: '마감시간',
            isTime: true,
            initialValue: endInitialValue,
          ),
        ),
      ],
    );
  }
}

class _Contents extends StatelessWidget {
  final FormFieldSetter<String> onSaved;
  final String initialValue;
  const _Contents({required this.onSaved, required this.initialValue});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CustomTextField(
        initialValue: initialValue,
        onSaved: onSaved,
        isTime: false,
        label: '내용',
      ),
    );
  }
}

typedef ColorIdSetter = void Function(int id);

class _ColorPicker extends StatelessWidget {
  final List<CategoryColor> colors;
  final int selectedColorId;
  final ColorIdSetter colorIdSetter;
  const _ColorPicker({
    required this.colors,
    required this.selectedColorId,
    required this.colorIdSetter,
  });

  @override
  Widget build(BuildContext context) {
    //row에 동그라미가 많으면 픽셀오류가 뜨지만 랩을 하면 자동 줄바꿈이 된다
    return Wrap(
      //좌우간격
      spacing: 8,
      //상하간격
      runSpacing: 10,
      children: colors
          .map(
            (e) => GestureDetector(
              onTap: () {
                colorIdSetter(e.id);
              },
              child: renderColor(
                e,
                selectedColorId == e.id,
              ),
            ),
          )
          .toList(),
    );
  }

  Widget renderColor(CategoryColor color, bool isSelected) {
    return Container(
      decoration: BoxDecoration(
        border: isSelected ? Border.all(color: Colors.black, width: 3) : null,
        shape: BoxShape.circle,
        color: Color(int.parse('FF${color.hexCode}', radix: 16)),
      ),
      width: 32,
      height: 32,
    );
  }
}

class _SaveButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _SaveButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    //로우도 감싸서 익스펜디드로 감싸면 버튼이 좌우로 늘어난다
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: PRIMARY_COLOR,
            ),
            child: const Text('저장'),
          ),
        ),
      ],
    );
  }
}

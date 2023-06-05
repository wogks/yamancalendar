import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:videocall2/component/custom_text_field.dart';
import 'package:videocall2/const/colors.dart';
import 'package:videocall2/database/drift_database.dart';

class ScheduleBottomSheet extends StatefulWidget {
  const ScheduleBottomSheet({super.key});

  @override
  State<ScheduleBottomSheet> createState() => _ScheduleBottomSheetState();
}

class _ScheduleBottomSheetState extends State<ScheduleBottomSheet> {
  final GlobalKey<FormState> formKey = GlobalKey();

  //처음에 저장을 누르지 않았을때는 값이 없기때문에 널일 수 있다
  int? startTime;
  int? endTime;
  String? content;

  @override
  Widget build(BuildContext context) {
    //핸드폰에서 시스템이 유아이를 차지하는 부분(이만큼 바텀시트에 패딩을 주지 않으면 키보드에 텍스트필드가 가려진다)
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: SafeArea(
        child: Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height / 2 + bottomInset,
          child: Padding(
            padding: EdgeInsets.only(bottom: bottomInset),
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, top: 16),
              child: Form(
                //따로 버튼을 누르지 않아도 자동으로 밸리데이트 해줌
                autovalidateMode: AutovalidateMode.always,
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Time(
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
                      onSaved: (newValue) {
                        content = newValue;
                      },
                    ),
                    const SizedBox(height: 16),
                    FutureBuilder<List<CategoryColor>>(
                      future: GetIt.I<LocalDatabase>().getCategoryColors(),
                      builder: (context, snapshot) {
                        print(snapshot.data);
                        return _ColorPicker(
                          colors: snapshot.hasData
                              ? snapshot.data!
                                  .map((e) => Color(
                                      int.parse('FF${e.hexCode}', radix: 16)))
                                  .toList()
                              : [],
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
      ),
    );
  }

  void onSavePressed() {
    //formkey는 생성을 했는데 form위젯과 결합을 안했을때
    if (formKey.currentState == null) {
      return;
    }
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
    } else {
      print('에러가 있습니다');
    }
  }
}

class _Time extends StatelessWidget {
  final FormFieldSetter<String> onStartSaved;
  final FormFieldSetter<String> onEndSaved;
  const _Time({
    required this.onStartSaved,
    required this.onEndSaved,
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
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: CustomTextField(
            onSaved: onEndSaved,
            label: '마감시간',
            isTime: true,
          ),
        ),
      ],
    );
  }
}

class _Contents extends StatelessWidget {
  final FormFieldSetter<String> onSaved;
  const _Contents({required this.onSaved});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CustomTextField(
        onSaved: onSaved,
        isTime: false,
        label: '내용',
      ),
    );
  }
}

class _ColorPicker extends StatelessWidget {
  final List<Color> colors;
  const _ColorPicker({required this.colors});

  @override
  Widget build(BuildContext context) {
    //row에 동그라미가 많으면 픽셀오류가 뜨지만 랩을 하면 자동 줄바꿈이 된다
    return Wrap(
      //좌우간격
      spacing: 8,
      //상하간격
      runSpacing: 10,
      children: colors.map((e) => renderColor(e)).toList(),
    );
  }

  Widget renderColor(Color color) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
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

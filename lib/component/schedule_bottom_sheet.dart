import 'package:flutter/material.dart';
import 'package:videocall2/component/custom_text_field.dart';
import 'package:videocall2/const/colors.dart';

class ScheduleBottomSheet extends StatefulWidget {
  const ScheduleBottomSheet({super.key});

  @override
  State<ScheduleBottomSheet> createState() => _ScheduleBottomSheetState();
}

class _ScheduleBottomSheetState extends State<ScheduleBottomSheet> {
  final GlobalKey<FormState> formKey = GlobalKey();
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
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _Time(),
                    const SizedBox(height: 16),
                    const _Contents(),
                    const SizedBox(height: 16),
                    const _ColorPicker(),
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
      print('에러가없습니다');
    } else {
      print('에러가 있습니다');
    }
  }
}

class _Time extends StatelessWidget {
  const _Time();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: CustomTextField(
            label: '시작시간',
            isTime: true,
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: CustomTextField(
            label: '마감시간',
            isTime: true,
          ),
        ),
      ],
    );
  }
}

class _Contents extends StatelessWidget {
  const _Contents();

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: CustomTextField(
        isTime: false,
        label: '내용',
      ),
    );
  }
}

class _ColorPicker extends StatelessWidget {
  const _ColorPicker();

  @override
  Widget build(BuildContext context) {
    //row에 동그라미가 많으면 픽셀오류가 뜨지만 랩을 하면 자동 줄바꿈이 된다
    return Wrap(
      //좌우간격
      spacing: 8,
      //상하간격
      runSpacing: 10,
      children: [
        renderColor(Colors.red),
        renderColor(Colors.orange),
        renderColor(Colors.yellow),
        renderColor(Colors.green),
        renderColor(Colors.blue),
        renderColor(Colors.indigo),
        renderColor(Colors.purple),
      ],
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

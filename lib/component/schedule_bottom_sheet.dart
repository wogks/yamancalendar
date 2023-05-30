import 'package:flutter/material.dart';
import 'package:videocall2/component/custom_text_field.dart';
import 'package:videocall2/const/colors.dart';

class ScheduleBottomSheet extends StatelessWidget {
  const ScheduleBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    //핸드폰에서 시스템이 유아이를 차지하는 부분(이만큼 바텀시트에 패딩을 주지 않으면 키보드에 텍스트필드가 가려진다)
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height / 2 + bottomInset,
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomInset),
        child: const Padding(
          padding: EdgeInsets.only(left: 8, right: 8, top: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Time(),
              SizedBox(height: 16),
              _Contents(),
              SizedBox(height: 16),
              _ColorPicker(),
              SizedBox(height: 8),
              _SaveButton()
            ],
          ),
        ),
      ),
    );
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
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: CustomTextField(
            label: '마감시간',
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
    return const CustomTextField(
      label: '내용',
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
  const _SaveButton();

  @override
  Widget build(BuildContext context) {
    //로우도 감싸서 익스펜디드로 감싸면 버튼이 좌우로 늘어난다
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {},
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

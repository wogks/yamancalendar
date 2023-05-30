import 'package:flutter/material.dart';

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
        child: const Column(
          children: [
            TextField(),
          ],
        ),
      ),
    );
  }
}

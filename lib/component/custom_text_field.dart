import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:videocall2/const/colors.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final bool isTime;
  const CustomTextField({
    super.key,
    required this.label,
    required this.isTime,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
              color: PRIMARY_COLOR, fontWeight: FontWeight.w600),
        ),
        if (isTime) renderTextFiled(),
        if (!isTime) Expanded(child: renderTextFiled()),
      ],
    );
  }

  Widget renderTextFiled() {
    return TextField(
      expands: !isTime,
      //자동 줄바꿈
      maxLines: isTime ? 1 : null,
      keyboardType: isTime
          ? const TextInputType.numberWithOptions()
          : TextInputType.multiline,
      //숫자만 쓸수있게 한다
      inputFormatters: isTime ? [FilteringTextInputFormatter.digitsOnly] : [],
      cursorColor: Colors.grey,
      decoration: InputDecoration(
        //밑줄 없애기
        border: InputBorder.none,
        //이걸 넣어야 색깔을 넣을수 있다
        filled: true,
        fillColor: Colors.grey[300],
      ),
    );
  }
}
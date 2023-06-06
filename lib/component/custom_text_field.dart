import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:videocall2/const/colors.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final bool isTime;
  final String initialValue;
  final FormFieldSetter<String> onSaved;
  const CustomTextField({
    super.key,
    required this.label,
    required this.isTime,
    required this.onSaved,
    required this.initialValue,
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
    return TextFormField(
      //상위에 있는 form에서 save라는 함수를 불렀을때 실행이 된다
      onSaved: onSaved,
      //null이 return되면 에러가 없다
      //에러가 있으면 에러를 String 값으로 리턴해준다
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '값을 입력해주세요';
        }
        if (isTime) {
          int time = int.parse(value);

          if (time < 0) {
            return '0이상의 숫자를 입력하세요';
          }
          if (time > 24) {
            return '24이하의 숫자를 입력해주세요';
          }
        } else {}
        return null;
      },
      expands: !isTime,
      //자동 줄바꿈
      maxLines: isTime ? 1 : null,
      maxLength: 500,
      keyboardType: isTime
          ? const TextInputType.numberWithOptions()
          : TextInputType.multiline,
      //숫자만 쓸수있게 한다
      inputFormatters: isTime ? [FilteringTextInputFormatter.digitsOnly] : [],
      cursorColor: Colors.grey,
      initialValue: initialValue,
      decoration: InputDecoration(
        suffixText: isTime ? '시' : null,
        //밑줄 없애기
        border: InputBorder.none,
        //이걸 넣어야 색깔을 넣을수 있다
        filled: true,
        fillColor: Colors.grey[300],
      ),
    );
  }
}

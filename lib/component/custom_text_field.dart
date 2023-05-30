import 'package:flutter/material.dart';
import 'package:videocall2/const/colors.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  const CustomTextField({super.key, required this.label});

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
        TextField(
          cursorColor: Colors.grey,
          decoration: InputDecoration(
            //밑줄 없애기
            border: InputBorder.none,
            //이걸 넣어야 색깔을 넣을수 있다
            filled: true,
            fillColor: Colors.grey[300],
          ),
        ),
      ],
    );
  }
}

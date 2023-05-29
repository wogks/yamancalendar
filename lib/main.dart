import 'package:flutter/material.dart';
import 'package:videocall2/screen/home_screen.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  //런앱을 실행하기전에 다른 코드를 실행한다면 초기화를 확실히 해야하기 때문에 바인딩 실행
  WidgetsFlutterBinding.ensureInitialized();
  //인텔패키지안에 있는 언어 코드를 모두 사용할수 있음
  await initializeDateFormatting();
  runApp(
    MaterialApp(
      theme: ThemeData(fontFamily: 'NotoSans'),
      home: const HomeScreen(),
    ),
  );
}

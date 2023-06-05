import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:videocall2/database/drift_database.dart';
import 'package:videocall2/screen/home_screen.dart';
import 'package:intl/date_symbol_data_local.dart';

const DEFAULT_COLORS = [
  'F44336',
  'FF9800',
  'FFEB3B',
  'FCAF50',
  '2196F3',
  '2196F3',
  '3F51B5',
  '9C27B0',
];

void main() async {
  //런앱을 실행하기전에 다른 코드를 실행한다면 초기화를 확실히 해야하기 때문에 바인딩 실행
  WidgetsFlutterBinding.ensureInitialized();
  //인텔패키지안에 있는 언어 코드를 모두 사용할수 있음
  await initializeDateFormatting();

  final database = LocalDatabase();
  GetIt.I.registerSingleton<LocalDatabase>(database);

  final colors = await database.getCategoryColors();
  if (colors.isEmpty) {
    for (String hexCode in DEFAULT_COLORS) {
      await database.createCategoryColor(
        CategoryColorsCompanion(
          // id: const Value(1),
          //값을 집어넣을때는 항상 value안에 넣어줘야한다
          hexCode: Value(hexCode),
        ),
      );
    }
  }
  runApp(
    MaterialApp(
      theme: ThemeData(fontFamily: 'NotoSans'),
      home: const HomeScreen(),
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:simple_app/widgets/expenses.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';

var kColorScheme = ColorScheme.fromSeed(
  seedColor: Color.fromARGB(255, 96, 59, 181),
);

var kDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: Color.fromARGB(255, 5, 99, 125),
);

void main() async {
  await Hive.initFlutter();
  var box = await Hive.openBox('aaa');
  runApp(
    MaterialApp(
      darkTheme: ThemeData.dark().copyWith(
          colorScheme: kDarkColorScheme,
          cardTheme: CardTheme().copyWith(
              color: kDarkColorScheme.secondaryContainer,
              margin: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              )),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
                backgroundColor: kDarkColorScheme.primaryContainer,
                foregroundColor: kDarkColorScheme.onPrimaryContainer),
          )),
      home: Expenses(),
      theme: ThemeData().copyWith(
          colorScheme: kColorScheme,
          appBarTheme: AppBarTheme().copyWith(
            backgroundColor: kColorScheme.onPrimaryContainer,
            foregroundColor: kColorScheme.primaryContainer,
          ),
          cardTheme: CardTheme().copyWith(
            color: kColorScheme.secondaryContainer,
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                  backgroundColor: kColorScheme.primaryContainer)),
          textTheme: ThemeData().textTheme.copyWith(
              titleLarge: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: kColorScheme.onSecondaryContainer,
                  fontSize: 20))),
    ),
  );
}

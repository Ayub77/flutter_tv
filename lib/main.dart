// ignore_for_file: prefer_const_constructors, avoid_function_literals_in_foreach_calls
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tv/home_page.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox("MyBaza");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.select): ActivateIntent()
      },
      child: MaterialApp(
        title: 'Flutter Android Tv',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity),
        home: const HomePage(),
      ),
    );
  }
}

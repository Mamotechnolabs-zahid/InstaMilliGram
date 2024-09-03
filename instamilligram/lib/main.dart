import 'package:flutter/material.dart';
import 'package:instamilligram/Utilities/colors.dart';
import 'package:instamilligram/responsive/mobile_screen_layout.dart';
import 'package:instamilligram/responsive/responsive_layout_screen.dart';
import 'package:instamilligram/responsive/web_screen_layout.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'InstaMilliGram',
        theme: ThemeData.dark().copyWith(
          //gives a good dark background
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),
        home: const ResponsiveLayout(
          webScreenLayout: WebScreenLayout(),
          mobileScreenLayout: MobileScreenLayout(),
        ));
  }
}

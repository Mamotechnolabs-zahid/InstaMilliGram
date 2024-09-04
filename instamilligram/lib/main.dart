import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instamilligram/Utilities/colors.dart';
import 'package:instamilligram/firebase_options.dart';
import 'package:instamilligram/responsive/mobile_screen_layout.dart';
import 'package:instamilligram/responsive/responsive_layout_screen.dart';
import 'package:instamilligram/responsive/web_screen_layout.dart';
import 'package:instamilligram/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // let the widgets be built
  
  if (kIsWeb) { //if its web then this
    await Firebase.initializeApp(
        options: const FirebaseOptions(
      apiKey: "AIzaSyC7Lvp-YWB6ifqaOlm_mayHSwB71pHiP3A",
      appId: "1:676712352074:web:d46711ee954817b7ac99b3",
      messagingSenderId: "676712352074",
      projectId: "instamilligram-aa2e7",
      storageBucket:  "instamilligram-aa2e7.appspot.com",
    ));
  } else {
    await Firebase.initializeApp();
  }
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
        // home: const ResponsiveLayout(
        //   webScreenLayout: WebScreenLayout(),
        //   mobileScreenLayout: MobileScreenLayout(),
        // ));
        home : LoginScreen());
  }
}

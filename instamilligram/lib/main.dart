import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instamilligram/providers/user_provider.dart';
import 'package:instamilligram/responsive/mobile_screen_layout.dart';
import 'package:instamilligram/responsive/responsive_layout.dart';
import 'package:instamilligram/responsive/web_screen_layout.dart';
import 'package:instamilligram/screens/login_screen.dart';
import 'package:instamilligram/utils/colors.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // initialise app based on platform- web or mobile
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyC7Lvp-YWB6ifqaOlm_mayHSwB71pHiP3A",
          appId: "1:676712352074:web:be8b8e3bf9c922f5ac99b3",
          messagingSenderId: "5851197676712352074",
          projectId: "instamilligram-aa2e7",
          storageBucket: 'instamilligram-aa2e7.appspot.com'),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Mutliprovider takes in list of Providers and it is one time setup
    //rather than using  consumer everywhere
    return MultiProvider(
      providers: [
        //change notifier takes in our provider
        ChangeNotifierProvider(
          create: (_) => UserProvider(), //we created this user provider
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'InstaMilliGram',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),
        //persistant login of user
        home: StreamBuilder(
          //.authStateChanges Runs only when the user signs in or out.
          stream: FirebaseAuth.instance.authStateChanges(),

          ///idTokenChanges and //userChanges
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              // Checking if the snapshot has any data or not
              if (snapshot.hasData) {
                // if snapshot has data which means user is logged in then we check the width of screen and accordingly display the screen layout
                return const ResponsiveLayout(
                  mobileScreenLayout: MobileScreenLayout(),
                  webScreenLayout: WebScreenLayout(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }

            // means connection to future hasnt been made yet
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              );
            }

            // if snapshot doesnt have data then this will run ie login screen
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}



//tra;jnhn
import 'package:flutter/material.dart';
import 'package:library_app/onboarding/onboarding_page.dart';
import 'package:provider/provider.dart';
import 'bookmark_provider.dart';
import 'common/colo_extension.dart';
// ignore: unused_import
import 'home.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => BookmarkProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Labo Lingua',
      debugShowCheckedModeBanner: false,
      theme:
          ThemeData(
            primaryColor: TColor.primaryColor1,
            fontFamily: "Poppins"),
      
      home: const OnBoardingView(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/approver/approver_screen.dart';
import 'screens/requester/requester_screen.dart';
import 'utils/constants.dart';
import 'screens/administrator/admin_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Approval System',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: bgColor,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: Colors.white),
        canvasColor: secondaryColor,
      ),
      home:
          // RequesterScreen(),
          // ApproverScreen(),
          AdminScreen(),
    );
  }
}

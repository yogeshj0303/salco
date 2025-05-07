import 'package:flutter/material.dart';
import 'package:selco_app/screens/dashboard_screen.dart';
import 'package:selco_app/screens/enquiry_form.dart';
import 'package:selco_app/screens/main_screen.dart';
import 'constants/colors.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SELCO',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryTeal,
          primary: AppColors.primaryTeal,
          secondary: AppColors.primaryOrange,
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
      routes: {
        '/main': (context) => const MainScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/enquiry': (context) => const EnquiryForm(),
      },
    );
  }
}

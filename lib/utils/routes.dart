import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/login_page.dart';
import '../screens/signup_page.dart';
import '../screens/main_topics_page.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    '/': (context) => const SplashScreen(),
    '/login': (context) => const LoginPage(),
    '/signup': (context) => const SignupPage(),
    '/main-topics': (context) => const MainTopicsPage(),
  };
}
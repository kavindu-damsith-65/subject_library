import 'package:flutter/material.dart';
import 'package:subject_library/screens/main_topics_page.dart';
import 'utils/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Subject Library',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: AppRoutes.routes,
      onGenerateRoute: (settings) {
        // Debug print to see all route attempts
        debugPrint('Route attempted: ${settings.name}');
        
        // Handle the main-topics route explicitly
        if (settings.name == '/main-topics') {
          return MaterialPageRoute(builder: (context) => const MainTopicsPage());
        }
        
        // Default fallback
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(child: Text('Route not found!')),
          ),
        );
      },
    );
  }
}
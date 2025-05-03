import 'package:flutter/material.dart';
import 'package:subject_library/screens/login_page.dart';
import 'package:subject_library/screens/subtopics_page.dart';
import 'package:subject_library/services/auth_service.dart';

class MainTopicsPage extends StatelessWidget {
  const MainTopicsPage({super.key});

  // Complete list of main topics
  final List<String> mainTopics = const [
    "Science & Mathematics",
    "Humanities & Social Sciences",
    "Law & Languages",
    "Business & Economics",
    "Art & Design",
    "Technology & Vocational",
  ];

  // Logout function
  Future<void> _logout(BuildContext context) async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    // Perform logout operations
    await AuthService.logout(); // Clear token/user data

    // Close loading indicator
    Navigator.of(context).pop();

    // Navigate to login page and clear navigation stack
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subject Library'),
        actions: [
          // Logout button in app bar
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.separated(
          itemCount: mainTopics.length,
          separatorBuilder: (context, index) => const Divider(height: 16),
          itemBuilder: (context, index) {
            return Card(
              elevation: 2,
              child: ListTile(
                title: Text(
                  mainTopics[index],
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          SubtopicsPage(topic: mainTopics[index]),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
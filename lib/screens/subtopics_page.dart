import 'package:flutter/material.dart';
import 'text_files_page.dart';

class SubtopicsPage extends StatelessWidget {
  final String topic;
  const SubtopicsPage({super.key, required this.topic});

  // Complete subtopics structure
  final Map<String, List<String>> subtopics = const {
    "Science & Mathematics": [
      "Mathematics",
      "Further Mathematics",
      "Biology",
      "Chemistry",
      "Physics",
      "Computer Science",
      "Environmental Science",
      "Psychology",
    ],
    "Humanities & Social Sciences": [
      "History",
      "Geography",
      "Politics",
      "Sociology",
      "Religious Studies",
      "Philosophy",
    ],
    "Law & Languages": [
      "Law",
      "English Language",
      "English Literature",
      "French",
      "Spanish",
      "German",
      "Latin",
      "Mandarin",
    ],
    "Business & Economics": [
      "Business Studies",
      "Economics",
      "Accounting",
      "Travel & Tourism",
      "Creative & Performing Arts",
    ],
    "Art & Design": [
      "Drama & Theatre Studies",
      "Music",
      "Media Studies",
      "Photography",
    ],
    "Technology & Vocational": [
      "Design & Technology",
      "Engineering",
      "Information Technology (IT)",
      "Health & Social Care",
      "Food Science & Nutrition",
    ],
  };

  @override
  Widget build(BuildContext context) {
    // Get subtopics for the current topic or empty list if not found
    final currentSubtopics = subtopics[topic] ?? [];

    return Scaffold(
      appBar: AppBar(title: Text(topic)),
      body: ListView.builder(
        itemCount: currentSubtopics.length,
        itemBuilder: (context, index) {
          final subtopic = currentSubtopics[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text(
                subtopic,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              trailing: const Icon(Icons.arrow_forward),
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => TextFilesPage(
                            mainTopic: topic, // Pass the main topic
                            subtopic: subtopic, // Pass the subtopic
                          ),
                    ),
                  ),
            ),
          );
        },
      ),
    );
  }
}

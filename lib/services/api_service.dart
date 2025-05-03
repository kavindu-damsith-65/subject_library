import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:subject_library/models/text_file.dart';
import 'package:subject_library/services/auth_service.dart';

class ApiService {
  static const String _baseUrl = 'http://10.0.2.2:3000/api'; // Your backend URL

  // Get all text files for a subtopic
 static Future<List<TextFile>> getTextFilesByTopicAndSubtopic(
    String mainTopic, String subtopic) async {
  final token = await AuthService.getToken();
  final encodedMainTopic = Uri.encodeComponent(mainTopic);
  final encodedSubtopic = Uri.encodeComponent(subtopic); 
  final response = await http.get(
    Uri.parse('$_baseUrl/notes?mainTopic=$encodedMainTopic&subtopic=$encodedSubtopic'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    final dynamic responseData = jsonDecode(response.body);
    
    // Handle both array and object responses
    if (responseData is List) {
      return responseData.map((json) => TextFile.fromMap(json)).toList();
    } else if (responseData is Map) {
      // If backend returns a single object, wrap it in a list
      return [TextFile.fromMap(responseData as Map<String, dynamic>)];
    } else {
      throw Exception('Invalid response format');
    }
  } else {
    throw Exception('Failed to load notes: ${response.statusCode}');
  }
}


  // Create a new text file
  static Future<TextFile> createTextFile(TextFile file) async {
    final token = await AuthService.getToken();
    final response = await http.post(
      Uri.parse('$_baseUrl/notes'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(file.toMap()),
    );

    if (response.statusCode == 201) {
      return TextFile.fromMap(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create note');
    }
  }

  // Update a text file
  static Future<TextFile> updateTextFile(TextFile file) async {
    final token = await AuthService.getToken();
    final response = await http.put(
      Uri.parse('$_baseUrl/notes/${file.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(file.toMap()),
    );

    if (response.statusCode == 200) {
      return TextFile.fromMap(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update note');
    }
  }

  // Delete a text file
  static Future<void> deleteTextFile(String id) async {
    final token = await AuthService.getToken();
    final response = await http.delete(
      Uri.parse('$_baseUrl/notes/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete note');
    }
  }
}
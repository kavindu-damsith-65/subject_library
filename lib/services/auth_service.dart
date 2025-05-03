import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _baseUrl = 'http://10.0.2.2:3000/api/auth';
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';

  // Login with email and password
  static Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/login'),
        body: jsonEncode({'email': email, 'password': password}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await _persistAuthData(data['token'], data['user']);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Register new user
  static Future<bool> register(String email, String password, String name) async {
  try {
    print('Attempting to register user: $email'); // Debug: Start of registration

    final response = await http.post(
      Uri.parse('$_baseUrl/signup'),
      body: jsonEncode({'email': email, 'password': password, 'name': name}),
      headers: {'Content-Type': 'application/json'},
    );

    print('Response status code: ${response.statusCode}'); // Debug: HTTP status
    print('Response body: ${response.body}');              // Debug: Raw response

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      print('Registration successful! Token: ${data['token']}'); // Debug: Success
      await _persistAuthData(data['token'], data['user']);
      return true;
    } else {
      print('Registration failed. Server response: ${response.body}'); // Debug: Failure
      return false;
    }
  } catch (e) {
    print('Error during registration: $e'); // Debug: Exception caught
    return false;
  }
}

  // Persist auth data to shared preferences
  static Future<void> _persistAuthData(String token, dynamic user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_userKey, jsonEncode(user));
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey) != null;
  }

  // Get auth token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Logout user
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
  }
}
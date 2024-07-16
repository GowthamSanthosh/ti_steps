import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class UserRepository {
  final int pageSize = 6; // Define the page size as per your API's response size
  final String baseUrl;

  UserRepository({required this.baseUrl});

  Future<List<User>> fetchUsers(int page) async {
    final response = await http.get(Uri.parse('$baseUrl/api/users?page=$page'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> userJson = data['data'];
      return userJson.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<User> fetchUserDetail(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/api/users/$userId'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return User.fromJson(data);
    } else {
      throw Exception('Failed to load user detail');
    }
  }
}

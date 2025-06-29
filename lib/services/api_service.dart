import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://10.0.2.2:6004/api";

  static Future<List<dynamic>> getCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/category'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load categories');
    }
  }
}

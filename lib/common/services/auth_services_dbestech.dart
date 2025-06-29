import 'package:foodly_restaurant/models/environment.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class AuthServiceDbestech {
  static String baseUrl = Environment.appBaseUrl;

  // General POST request method
  static Future<http.Response> postRequest(String endpoint, String body) async {
    var url = Uri.parse('$baseUrl/$endpoint');
    return await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: body,
    );
  }

  // Login specific method
  static Future<http.Response> login(String body) async {
    return await postRequest('login', body);  // Calls the general POST method
  }

  // Registration specific method
  static Future<http.Response> register(String body) async {
    return await postRequest('register', body);  // Calls the general POST method
  }
}

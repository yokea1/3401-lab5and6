import 'dart:convert';
import 'package:foodly_restaurant/models/environment.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class FoodServiceDbestech {
  static String baseUrl = Environment.appBaseUrl;
  final box = GetStorage();

  // General GET request method
  Future<http.Response> getRequest(String endpoint) async {
    String token = box.read('token');
    String accessToken = jsonDecode(token);
    var url = Uri.parse('$baseUrl/$endpoint');
    return await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );
  }

  // General PUT request method for editing/updating
  Future<http.Response> editRequest(String foodItemId, Map<String, dynamic> updatedFoodItem) async {
    String token = box.read('token');
    String accessToken = jsonDecode(token);

    Uri url = Uri.parse('$baseUrl/api/restaurant/$foodItemId');  // Correct URL without double 'foods/'

    return await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(updatedFoodItem),  // Convert map to JSON string for the request
    );
  }

  // Method to fetch data (e.g., a list of foods)
  Future<http.Response> getFoods() async {
    return await getRequest("api/foods");  // Fetches list of foods
  }

  // Method to update a food item
  Future<http.Response> editFood(String foodItemId, Map<String, dynamic> updatedFoodItem) async {
    return await editRequest(foodItemId, updatedFoodItem);  // Calls the general PUT method
  }
}

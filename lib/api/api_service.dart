import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final http.Client client = http.Client();

  static const String baseUrl = 'http://www.themealdb.com/api/json/v1/1';

  Future<List<dynamic>> getCategories() async {
    final response = await client.get(Uri.parse('$baseUrl/categories.php'));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data['categories'];
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<dynamic>> getMealsByCategory(String category) async {
    final response = await client.get(Uri.parse('$baseUrl/filter.php?c=$category'));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data['meals'];
    } else {
      throw Exception('Failed to load data');
    }
  }
  
   Future<dynamic> getMealDetails(String id) async {
    final response = await client.get(Uri.parse('$baseUrl/lookup.php?i=$id'));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data['meals'];
    } else {
      throw Exception('Failed to load data');
    }
  }
}
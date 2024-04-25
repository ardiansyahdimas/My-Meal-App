import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_test/flutter_test.dart';
import 'package:my_meal_app/api/api_endpoint.dart';

class MealService {
  Future<List<String>> fetchAreas() async {
    final response = await _get(ApiEndpoint.areasUrl);
    final List<dynamic> data = json.decode(response.body)['meals'];
    return data.map((meal) => meal['strArea'].toString()).toList();
  }

  Future<Map<String, dynamic>> fetchMealDetails(String mealId) async {
    final response = await _get('${ApiEndpoint.mealByIdUrl}$mealId');
    final Map<String, dynamic> data = json.decode(response.body);
    return data['meals'][0];
  }

  Future<Map<String, dynamic>> searchMealByName(String mealName) async {
    final response = await _get('${ApiEndpoint.searchByNameUrl}$mealName');
    final Map<String, dynamic> data = json.decode(response.body);
    return data['meals'][0];
  }

  Future<http.Response> _get(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to load data');
    }
  }
}

void main() {
  test('API call returns list of areas', () async {
    final service = MealService();
    final areas = await service.fetchAreas();
    expect(areas, isNotEmpty);
    expect(areas.contains('American'), true);
  });

  test('API call returns meal details', () async {
    final service = MealService();
    const mealId = '52772';
    final mealDetails = await service.fetchMealDetails(mealId);

    expect(mealDetails['strMeal'], 'Teriyaki Chicken Casserole');
    expect(mealDetails['strCategory'], 'Chicken');
    expect(mealDetails['strArea'], 'Japanese');
  });

  test('API call returns search meal by name', () async {
    final service = MealService();
    const mealName = 'Arrabiata';
    final mealDetails = await service.searchMealByName(mealName);

    expect(mealDetails['strMeal'], 'Spicy Arrabiata Penne');
    expect(mealDetails['strCategory'], 'Vegetarian');
    expect(mealDetails['strArea'], 'Italian');
  });
}

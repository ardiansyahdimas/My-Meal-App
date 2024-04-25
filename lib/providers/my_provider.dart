import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:my_meal_app/api/api_endpoint.dart';
import 'package:my_meal_app/model/meal_model.dart';

class MyProvider with ChangeNotifier {

  bool _loading = false;
  bool get loading => _loading;

  List<dynamic> _areas = [];
  List<dynamic> get areas => _areas;

  List<MealModel> _meals = [];
  List<MealModel> get meals => _meals;

  MealModel? _meal;
  MealModel? get meal => _meal;

  Future<void> fetchAreas() async {
    _loading = true;
    try{
      final url = Uri.parse(ApiEndpoint.areasUrl);
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json' },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['meals'];
        _areas = data.map((item) => item['strArea'] as String).toList();
        _loading = false;
      }
    }catch (e){
      if (kDebugMode) print('Error to load areas: $e');
    }
    notifyListeners();
  }


  Future<void> fetchMeals(String areaName) async {
    _loading = true;
    try {
      final Uri url = Uri.parse("${ApiEndpoint.mealByAreaUrl}$areaName");
      final http.Response response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final List<dynamic> extractedData = json.decode(response.body)['meals'];
        final List<MealModel> loadedMeals = extractedData.map((mealData) => MealModel.fromJson(mealData)).toList();
        _meals = loadedMeals;
        _loading = false;
      } else {
        throw Exception('Failed to load meals');
      }
    } catch (e) {
      if (kDebugMode) print('Error loading meals: $e');
    }
    notifyListeners();
  }

  Future<void> searchByName(String mealName) async {
    _loading = true;
    try {
      final Uri url = Uri.parse("${ApiEndpoint.searchByNameUrl}$mealName");
      final http.Response response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final List<dynamic> extractedData = json.decode(response.body)['meals'];
        final List<MealModel> loadedMeals = extractedData.map((mealData) => MealModel.fromJson(mealData)).toList();
        _meals = loadedMeals;
        _loading = false;
      } else {
        throw Exception('Failed to load meals');
      }
    } catch (e) {
      if (kDebugMode) print('Error loading meals: $e');
    }
    notifyListeners();
  }

  Future<void> mealById(String mealId) async {
    _loading = true;
    try {
      final Uri url = Uri.parse("${ApiEndpoint.mealByIdUrl}$mealId");
      final http.Response response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final List<dynamic> extractedData = json.decode(response.body)['meals'];
        final MealModel loadedMeal = MealModel.fromJson(extractedData.firstOrNull);
        _meal = loadedMeal;
        _loading = false;
      } else {
        throw Exception('Failed to load meals');
      }
    } catch (e) {
      if (kDebugMode) print('Error loading meals: $e');
    }
    notifyListeners();
  }



}
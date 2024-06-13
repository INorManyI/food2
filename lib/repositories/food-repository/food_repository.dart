// ignore_for_file: curly_braces_in_flow_control_structures, constant_identifier_names

import 'dart:convert';
import 'DTO/food.dart';
import 'DTO/food_list_item.dart';
import 'package:http/http.dart' as http;
import 'errors/food_repository_find_errors.dart';
import 'errors/food_repository_get_errors.dart';
import 'package:lab_food_2/repositories/food-repository/DTO/nutrient.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';


/// A subsystem for interaction with stored data on foods.
class FoodRepository
{
  static const String _APP_ID = 'b8e1c762';
  static const String _APP_KEY = 'b0b1379f2ba58396198214cc4f9c476c';

  /// Checks if device is connected to the internet
  Future<bool> _isConnectedToInternet() async
  {
      return await InternetConnection().hasInternetAccess;
  }

  /// Retrieves food's details from API server
  Future<dynamic> _getFromAPI(String foodId, FoodRepositoryGetErrors errors) async
  {
    final response = await http.get(
      Uri.parse(
          'https://api.edamam.com/api/food-database/v2/parser?ingr=${Uri.encodeComponent(foodId)}&app_id=$_APP_ID&app_key=$_APP_KEY'),
    );

    if (response.statusCode != 200)
    {
      errors.add(FoodRepositoryGetErrors.INTERNAL);
      return null;
    }

    var foodApi = jsonDecode(response.body);
    if (foodApi == null &&
        foodApi['hints'] == null &&
        foodApi['hints'].isEmpty &&
        foodApi['hints'][0]['food'] == null)
    {
      return null;
    }

    return foodApi['hints'][0]['food'];
  }

  /// Converts APIs food's nutrient to app's food nutrient
  Nutrient _convertToNutrient(dynamic nutrientFromApi)
  {
    double energy = nutrientFromApi['ENERC_KCAL'];
    double protein = nutrientFromApi['PROCNT'];
    double fat = nutrientFromApi['FAT'];
    double carbohydrate = nutrientFromApi['CHOCDF'];
    return Nutrient(energy, protein, fat, carbohydrate);
  }

  /// Converts API's food to app's food list item
  Food _convertToFood(Map<String, dynamic> foodFromApi)
  {
    String id = foodFromApi['foodId'];
    String name = foodFromApi['label'];
    Nutrient nutrient = _convertToNutrient(foodFromApi['nutrients']);
    String category = foodFromApi['category'];
    String? thumbnailUrl = foodFromApi['image'];

    return Food(id, name, nutrient, category, thumbnailUrl);
  }

  /// Retrieves food's details.
  ///
  /// Returns [null] if error was encountered.
  Future<Food?> get(String id, FoodRepositoryGetErrors errors) async
  {
    if (! (await _isConnectedToInternet()))
    {
      errors.add(FoodRepositoryGetErrors.INTERNET_CONNECTION_MISSING);
      return null;
    }

    final foodFromApi = await _getFromAPI(id, errors);

    if (errors.hasAny())
      return null;

    return _convertToFood(foodFromApi);
  }



  /// Retrieves a list of foods from API server
  Future<List> _findFromAPI(String query, FoodRepositoryFindErrors errors) async
  {
    final response = await http.get(
      Uri.parse(
          'https://api.edamam.com/api/food-database/v2/parser?ingr=$query&app_id=$_APP_ID&app_key=$_APP_KEY'),
    );

    if (response.statusCode != 200)
    {
      errors.add(FoodRepositoryFindErrors.INTERNAL);
      return [];
    }

    return jsonDecode(response.body)['hints'];
  }

  /// Convert API's food list item to app's food list item
  FoodListItem _convertToFoodListItem(dynamic foodListItemFromApi)
  {
    String id = foodListItemFromApi['food']['foodId'];
    String name = foodListItemFromApi['food']['label'];
    String? thumbnailUrl = foodListItemFromApi['food']['image'];
    return FoodListItem(id, name, thumbnailUrl);
  }

  /// Checks if the [food] with the same identifier exists in the [foods]
  bool isInFoodList(List<FoodListItem> foods, FoodListItem food)
  {
    for (FoodListItem listItem in foods)
    {
      if (listItem.getId() == food.getId())
        return true;
    }
    return false;
  }

  /// Retrieves a list of foods matching the query.
  ///
  /// Returns empty list if error was encountered.
  Future<List<FoodListItem>> find(String query, FoodRepositoryFindErrors errors) async
  {
    if (! (await _isConnectedToInternet()))
    {
      errors.add(FoodRepositoryFindErrors.INTERNET_CONNECTION_MISSING);
      return [];
    }

    List<FoodListItem> result = [];
    final foodListFromApi = await _findFromAPI(query, errors);

    if (errors.hasAny())
      return [];

    for (final item in foodListFromApi)
    {
      // edamam.api have food entries with the same identifiers
      FoodListItem food = _convertToFoodListItem(item);
      if (! isInFoodList(result, food))
        result.add(food);
    }

    return result;
  }
}

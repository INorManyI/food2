// ignore_for_file: curly_braces_in_flow_control_structures, constant_identifier_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'DTO/favorite_food_list_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'errors/favorite_food_repository_get_all_errors.dart';

/// A subsystem for interaction with stored data on user's favourite foods.
class FavoriteFoodRepository
{
  static const String _APP_ID = 'b8e1c762';
  static const String _APP_KEY = 'b0b1379f2ba58396198214cc4f9c476c';
  static SharedPreferences? _storage;

  /// Initializes the FavoriteFoodRepository
  Future<void> init() async
  {
    _storage = _storage ?? await SharedPreferences.getInstance();
  }

  /// Replaces favorite foods identifiers in storage
  void _setIdentifiers(List<String> favoriteFoodsIds)
  {
    _storage!.setStringList('favoriteFoods', favoriteFoodsIds);
  }

  /// Retrieves favorite foods identifiers from storage
  List<String> _getIdentifiers()
  {
    return _storage!.getStringList('favoriteFoods') ?? [];
  }

  /// Adds a food to the user's list of favorite foods.
  ///
  /// If food is already in the list nothing will happen.
  void add(String foodId)
  {
    if (_storage == null)
      throw Exception('FavoriteFoodRepository not initialized. Please call init procedure before any interaction attempt.');

    List<String> favoriteFoodsIds = _getIdentifiers();
    if (favoriteFoodsIds.contains(foodId))
      return;

    favoriteFoodsIds.add(foodId);
    _setIdentifiers(favoriteFoodsIds);
  }

  /// Removes a food from the user's list of favorite foods.
  ///
  /// If food not in the list nothing will happen.
  void remove(String foodId)
  {
    if (_storage == null)
      throw Exception('FavoriteFoodRepository not initialized. Please call init procedure before any interaction attempt.');

    List<String> favoriteFoodsIds = _getIdentifiers();
    favoriteFoodsIds.remove(foodId);

    _setIdentifiers(favoriteFoodsIds);
  }

  /// Checks if a food is in the user's list of favorite foods.
  bool contains(String foodId)
  {
    if (_storage == null)
      throw Exception('FavoriteFoodRepository not initialized. Please call init procedure before any interaction attempt.');

    return _getIdentifiers().contains(foodId);
  }


  /// Checks if device is connected to the internet
  Future<bool> _isConnectedToInternet() async
  {
    return await InternetConnection().hasInternetAccess;
  }

  /// Retrieves food's details from API server
  dynamic _getFoodFromApi(String foodId, FavoriteFoodRepositoryGetAllErrors errors) async
  {
    final response = await http.get(
      Uri.parse(
          'https://api.edamam.com/api/food-database/v2/parser?ingr=${Uri.encodeComponent(foodId)}&app_id=$_APP_ID&app_key=$_APP_KEY'),
    );

    if (response.statusCode != 200)
    {
      errors.add(FavoriteFoodRepositoryGetAllErrors.INTERNAL);
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

  /// Converts API's food to app's user favorite food list item
  FavoriteFoodListItem _convertToFavoriteFoodListItem(dynamic foodFromApi)
  {
    String id = foodFromApi['foodId'];
    String name = foodFromApi['label'];
    String? thumbnailUrl = foodFromApi['image'];
    return FavoriteFoodListItem(id, name, thumbnailUrl);
  }

  /// Retrieves a list of user's favourite foods.
  ///
  /// Returns empty list if error was encountered.
  Future<List<FavoriteFoodListItem>> getAll(FavoriteFoodRepositoryGetAllErrors errors) async
  {
    if (_storage == null)
      throw Exception('FavoriteFoodRepository not initialized. Please call init procedure before any interaction attempt.');

    if (! (await _isConnectedToInternet()))
    {
      errors.add(FavoriteFoodRepositoryGetAllErrors.INTERNET_CONNECTION_MISSING);
      return [];
    }

    List<String> favoriteFoodsIds = _getIdentifiers();
    List<FavoriteFoodListItem> result = [];
    for (String foodId in favoriteFoodsIds)
    {
      final foodFromApi = await _getFoodFromApi(foodId, errors);
      if (errors.hasAny())
        return [];
      if (foodFromApi == null)
        continue;

      result.add(_convertToFavoriteFoodListItem(foodFromApi));
    }

    return result;
  }
}

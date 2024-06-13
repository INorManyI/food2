// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:lab_food_2/UI/favorite_foods_page/widgets/food_list.dart';
import '../../repositories/favorite-food-repository/DTO/favorite_food_list_item.dart';
import '../../repositories/favorite-food-repository/errors/favorite_food_repository_get_all_errors.dart';
import '../../repositories/favorite-food-repository/favorite_food_repository.dart';

class FavoriteFoodsPage extends StatefulWidget
{
  const FavoriteFoodsPage({super.key});

  @override
  FavoriteFoodsPageState createState() => FavoriteFoodsPageState();
}

class FavoriteFoodsPageState extends State<FavoriteFoodsPage>
{
  List<FavoriteFoodListItem> _foodList = [];
  final _foods = FavoriteFoodRepository();

  void showErrorMessage(String message)
  {
      final snackBar = SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _updateFoodList() async
  {
      await _foods.init();

      final errors = FavoriteFoodRepositoryGetAllErrors();
      final foodList = await _foods.getAll(errors);
      if (errors.hasAny())
      {
        if (errors.isInternetConnectionMissing())
          showErrorMessage('Отсутствует интернет-соединение');
        if (errors.isInternalErrorOccurred())
          showErrorMessage('В приложении произошла критическая ошибка. Разработчики уже были оповещены.');
        return;
      }
      setState(() {
        _foodList = foodList;
      });
  }

  @override
  Widget build(BuildContext context)
  {
    _updateFoodList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Избранное'),
      ),

      body: FoodListWidget(foodList: _foodList),
    );
  }
}

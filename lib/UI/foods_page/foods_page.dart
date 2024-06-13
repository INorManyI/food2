// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import '../../repositories/food-repository/DTO/food_list_item.dart';
import '../../repositories/food-repository/errors/food_repository_find_errors.dart';
import '../../repositories/food-repository/food_repository.dart';
import 'widgets/food_list.dart';

enum LoadingStatus
{
  loading,
  notLoading,
  failed
}

class FoodsPage extends StatefulWidget
{
  const FoodsPage({super.key});

  @override
  FoodsPageState createState() => FoodsPageState();
}

class FoodsPageState extends State<FoodsPage>
{
  String _searchQuery = '';
  List<FoodListItem>? _foodList = [];
  LoadingStatus _loadingStatus = LoadingStatus.notLoading;

  void showErrorMessage(String message)
  {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _performSearch() async
  {
    final foods = FoodRepository();
    final errors = FoodRepositoryFindErrors();

    setState(() {
      _loadingStatus = LoadingStatus.loading;
    });
    final foodList = await foods.find(_searchQuery, errors);

    if (errors.hasAny())
    {
      setState(() {
        _loadingStatus = LoadingStatus.failed;
      });

      if (errors.isInternetConnectionMissing())
        showErrorMessage('Отсутствует интернет-соединение');
      if (errors.isInternalErrorOccurred())
        showErrorMessage('В приложении произошла критическая ошибка. Разработчики уже были оповещены.');

      return;
    }

    setState(() {
      _loadingStatus = LoadingStatus.notLoading;
      _foodList = foodList;
    });
  }

  Widget _getBody()
  {
    switch (_loadingStatus)
    {
      case LoadingStatus.loading:
        return const Center(child: CircularProgressIndicator());

      case LoadingStatus.failed:
        return const Center(child: Text('Произошла ошибка'));

      case LoadingStatus.notLoading:
        if (_foodList!.isNotEmpty)
          return FoodListWidget(foodList: _foodList!);

        if (_searchQuery.isEmpty)
          return const Center(child: Text('Начните искать продукты'));
        else
          return const Center(child: Text('Ничего не было найдено'));
    }
  }

  void _showSearchDialog() async
  {
    var query = await showDialog<String>(
      context: context,
      builder: (context)
      {
        return AlertDialog(
          surfaceTintColor: const Color.fromARGB(255, 117, 0, 212),
          shadowColor: Color.fromARGB(255, 117, 0, 212),
          iconColor: const Color.fromARGB(255, 117, 0, 212),
          title: const Text(
            'Поиск',
            style: TextStyle(
              color: Colors.black
            ),
          ),
          content: TextField(
            onChanged: (value)
            {
              setState(() {
                _searchQuery = value;
              });
            },
            decoration: const InputDecoration(hintText: 'Поиск...'),
          ),
          actions: [
            TextButton(
              onPressed: ()
              {
                Navigator.pop(context);
              },
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: ()
              {
                _performSearch();
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
    if (query != null) {
      setState(() {
        _searchQuery = query;
      });
    }
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Продукты'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _showSearchDialog,
          )
        ],
      ),
      body: _getBody()
    );
  }
}

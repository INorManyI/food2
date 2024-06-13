import 'package:flutter/material.dart';
import 'package:flutter_image/network.dart';
import 'package:lab_food_2/repositories/food-repository/DTO/food.dart';

/// A subsystem for displaying widget with general information about food
/// on the "Food details" page for the user.
class FoodMainInfoWidget extends StatelessWidget
{
  final Food _food;

  const FoodMainInfoWidget(this._food, {super.key});

  @override
  Widget build(BuildContext context)
  {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: NetworkImageWithRetry(
                _food.getThumbnail() ?? 'https://via.placeholder.com/150',
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Категория: ${_food.getCategory()}'),
            const SizedBox(height: 10),
            Text('Энергетическая ценность: ${_food.getNutrient().getEnergyInKcal()} ккал.'),
            const SizedBox(height: 10),
            Text('Белки: ${_food.getNutrient().getProteinInGram()} г.'),
            const SizedBox(height: 10),
            Text('Жиры: ${_food.getNutrient().getFatInGram()} г.'),
            const SizedBox(height: 10),
            Text('Углеводы: ${_food.getNutrient().getCarbohydrateInGram()} г.'),
          ],
        )
      ],
    );
  }
}

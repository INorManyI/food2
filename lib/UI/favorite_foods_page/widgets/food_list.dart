import 'package:flutter/material.dart';
import '../../food_details_page/food_details_page.dart';
import 'package:lab_food_2/repositories/favorite-food-repository/DTO/favorite_food_list_item.dart';

/// A subsystem for displaying "List of foods" widget of "Favorite foods" page to the user.
class FoodListWidget extends StatelessWidget
{
  final List<FavoriteFoodListItem> foodList;

  const FoodListWidget({super.key, required this.foodList});

  SizedBox _getFoodThumbnail(FavoriteFoodListItem food)
  {
    return SizedBox(
      width: 70.0,
      height: 70.0,
      child: food.getThumbnail() == null
        ?  const Icon(Icons.image, color: Colors.white)
        :  Image.network(food.getThumbnail()!, fit: BoxFit.cover)
    );
  }

  @override
  Widget build(BuildContext context)
  {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10.0)
        ),
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
                itemCount: foodList.length,
                itemBuilder: (context, index)
                {
                  FavoriteFoodListItem food = foodList[index];

                  return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                    child: ListTile(
                      title: Text(
                        food.getName(),
                        style: const TextStyle(color: Colors.black),
                      ),
                      leading: _getFoodThumbnail(food),
                      onTap: ()
                      {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FoodDetailsPage(foodId: food.getId()),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
          ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../repositories/food-repository/DTO/food_list_item.dart';
import '../../food_details_page/food_details_page.dart';

/// A subsystem for displaying "List of foods" widget of "Foods" page to the user.
class FoodListWidget extends StatelessWidget
{
  final List<FoodListItem> foodList;

  const FoodListWidget({super.key, required this.foodList});

  SizedBox _getFoodThumbnail(FoodListItem food)
  {
    return SizedBox(
      width: 70,
      height: 70,
      child: food.getThumbnail() == null
        ?  const Icon(Icons.image, color: Colors.white)
        : Image.network(food.getThumbnail()!, fit: BoxFit.cover)
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
                      FoodListItem food = foodList[index];
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

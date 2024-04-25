import 'package:flutter/material.dart';
import '../model/meal_model.dart';

class MealItem extends StatelessWidget {
  final MealModel mealModel;
  const MealItem({super.key, required this.mealModel});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                "${mealModel.imageUrl}/preview",
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Text(
                mealModel.name,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
      )
    );
  }
}

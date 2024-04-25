import 'package:flutter/material.dart';
import 'package:my_meal_app/constants.dart';

class AreaItem extends StatelessWidget {
  final String areaName;
  final bool isSelected;
  const AreaItem({super.key, required this.areaName, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(                                                                                                                                                       5),
      color: isSelected ? mealColor : Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Center(
          child: Text(
            areaName,
            style: TextStyle(
                color: isSelected ? Colors.white : Colors.black
            ),
          ),
        ),
      ),
    );
  }
}

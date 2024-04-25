import 'package:flutter/material.dart';
import '../constants.dart';

class BackBtn extends StatelessWidget {
  const BackBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 50,
      left: 20,
      child: IconButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateColor.resolveWith((states) => Colors.white)
        ),
        onPressed: (){
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back, color: mealColor),
      ),
    );
  }
}

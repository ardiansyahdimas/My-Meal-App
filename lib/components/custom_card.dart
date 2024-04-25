import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String value;
  const CustomCard({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.only(right: 8, top: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Text(
          value,
          style: const TextStyle(
              color: Colors.black
          ),
        ),
      ),
    );
  }
}

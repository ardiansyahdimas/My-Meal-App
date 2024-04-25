import 'package:flutter/material.dart';
import 'package:my_meal_app/components/back_btn.dart';
import 'package:photo_view/photo_view.dart';

class PhotoViewPage extends StatelessWidget {
  final String imageUrl;
  const PhotoViewPage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          PhotoView(
            imageProvider: NetworkImage(imageUrl),
          ),
          const BackBtn()
        ]
    );
  }
}

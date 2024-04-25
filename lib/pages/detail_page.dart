import 'package:flutter/material.dart';
import 'package:my_meal_app/components/back_btn.dart';
import 'package:my_meal_app/components/custom_card.dart';
import 'package:my_meal_app/components/label_text.dart';
import 'package:my_meal_app/model/meal_model.dart';
import 'package:my_meal_app/pages/photo_view_page.dart';
import 'package:my_meal_app/providers/my_provider.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:readmore/readmore.dart';
import '../constants.dart';

class DetailPage extends StatefulWidget {
  final MealModel mealModel;
  const DetailPage({super.key, required this.mealModel});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {

  late YoutubePlayerController _controller;

  @override
  void initState() {
   Provider.of<MyProvider>(context, listen: false).mealById(widget.mealModel.id);
    super.initState();
  }

  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MyProvider>(
        builder: (context, myProvider, child) {
          BorderRadiusGeometry radius = const BorderRadius.only(
            topLeft: Radius.circular(24.0),
            topRight: Radius.circular(24.0),
          );
          List<String?> ingredientsItems = [
            myProvider.meal?.strIngredient1,
            myProvider.meal?.strIngredient2,
            myProvider.meal?.strIngredient3,
            myProvider.meal?.strIngredient4,
            myProvider.meal?.strIngredient5,
            myProvider.meal?.strIngredient6,
            myProvider.meal?.strIngredient7
          ];

          return myProvider.loading  ? const Center(
            child: CircularProgressIndicator(),
          ) : Stack(
              children: [ 
                GestureDetector(
                  onTap: (){
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) =>  PhotoViewPage(imageUrl: widget.mealModel.imageUrl)));
                  },
                  child: Image.network(
                    width: double.infinity,
                    height: 500,
                    widget.mealModel.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                SlidingUpPanel(
                  minHeight: 500,
                  maxHeight: 750,
                  borderRadius: radius,
                  panel:  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: SingleChildScrollView(
                      child:   Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.mealModel.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: mealColor,
                              ),
                            ),
                            Row(
                              children: [
                                CustomCard(value: myProvider.meal?.strArea ?? ""),
                                CustomCard(value: myProvider.meal?.strCategory ?? "")
                              ],
                            ),
                            const SizedBox(height: 16),
                            const LabelText(label: ingredients),
                            SizedBox(
                              width: double.infinity,
                              height: 60,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: ingredientsItems.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                                    child: CustomCard(value: ingredientsItems[index] ?? ""),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                            const LabelText(label: instructions),
                            const SizedBox(height: 8),
                            ReadMoreText(
                              myProvider.meal?.strInstructions ?? "",
                              trimMode: TrimMode.Line,
                              trimLines: 5,
                              colorClickableText: mealColor,
                              trimCollapsedText: showMore ,
                              trimExpandedText: showLess,
                              moreStyle: TextStyle(
                                  color: Colors.black.withOpacity(0.7),
                                  fontSize: 13
                              ),
                            ),
                            const SizedBox(height: 16),
                            YoutubePlayer(
                              controller: _controller = YoutubePlayerController(
                                initialVideoId:YoutubePlayer.convertUrlToId(myProvider.meal?.strYoutube ?? "") ?? "",
                                flags: const YoutubePlayerFlags(
                                  mute: false,
                                  autoPlay: false,
                                  disableDragSeek: false,
                                  loop: false,
                                  isLive: false,
                                  forceHD: false,
                                  enableCaption: false,
                                ),
                              ),
                              showVideoProgressIndicator: true,
                              progressIndicatorColor: mealColor,
                              progressColors: const ProgressBarColors(
                                playedColor: mealColor,
                                handleColor: mealColor,
                              ),
                            ),
                            const SizedBox(height: 16),
                            if (myProvider.meal?.strTags  != null) Text(
                              "Tags: ${myProvider.meal?.strTags}",
                              style: const TextStyle(
                                  color: mealColor
                              ),
                            ),
                          ],
                        ),
                      )
                    ),
                  ),
                ),
                const BackBtn()
              ]
          );
        },
      ),
    );
  }
}

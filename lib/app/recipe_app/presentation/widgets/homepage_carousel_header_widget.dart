import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:receipe_app/core/theme/app_colors.dart';

import '../../../../core/asset_mapper/recipe_carousel_images_mapper.dart';

class RecipeCarouselWidget extends StatefulWidget {
  const RecipeCarouselWidget({super.key});

  @override
  State<RecipeCarouselWidget> createState() => _RecipeCarouselWidgetState();
}

class _RecipeCarouselWidgetState extends State<RecipeCarouselWidget> {
  int currentIndex = 0;
  double scaleLevel = 1.0;

  @override
  Widget build(BuildContext context) {
    final mediaSize = MediaQuery.sizeOf(context);
    return Center(
      child: Container(
        color: Colors.white,
        width: mediaSize.width * 0.7, // 0.45,
        height: mediaSize.height * 0.5,
        child: MouseRegion(
          onEnter: (event) {
            setState(() {
              scaleLevel = 1.1;
            });
          },
          onExit: (event) {
            setState(() {
              scaleLevel = 1.0;
            });
          },
          child: AnimatedScale(
            duration: const Duration(milliseconds: 400),
            scale: scaleLevel,
            child: Stack(
              children: [
                CarouselSlider(
                    items: homepageCarouselImages
                        .map((e) => Image.asset(
                              e,
                              width: mediaSize.width * 0.7, // * 0.45,
                              height: mediaSize.height * 0.5,
                              fit: BoxFit.cover,
                            ))
                        .toList(),
                    options: CarouselOptions(
                      height: mediaSize.height * 0.50,
                      aspectRatio: 16 / 9,
                      viewportFraction: 1.0,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 3),
                      autoPlayAnimationDuration: const Duration(seconds: 2),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: true,
                      enlargeFactor: 0.3,
                      onPageChanged: (index, reason) {
                        setState(() {
                          currentIndex = index;
                        });
                      },
                      scrollDirection: Axis.horizontal,
                    )),
                Align(
                  alignment: Alignment(0.0, 0.90),
                  // bottom: 20,
                  // right: mediaSize.width / 2,
                  child: DotsIndicator(
                    dotsCount: 5,
                    position: currentIndex,
                    decorator: const DotsDecorator(
                      color: Colors.white,
                      size: Size(12, 12),
                      activeSize: Size(18, 18),
                      activeColor: AppColor.primaryColor,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

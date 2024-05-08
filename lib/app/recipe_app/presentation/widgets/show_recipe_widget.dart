import 'package:flutter/material.dart';
import 'package:receipe_app/core/theme/app_colors.dart';

import '../../../../core/utility/alert_header_design.dart';
import '../../../../core/utility/text_sizes.dart';
import '../../models/food_dish_model.dart';

class ShowRecipeWidget extends StatelessWidget {
  final FoodDishModel item;
  const ShowRecipeWidget({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    print("item.isImageFromHive: ${item.isImageFromHive}");
    print("item.imagePath: ${item.imagePath}");
    final mediaSize = MediaQuery.sizeOf(context);
    return SizedBox(
      width: mediaSize.width * 0.37,
      height: 600,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            item.isImageFromHive
                ? Image.memory(
                    item.imageStoredInHive!,
                    fit: BoxFit.cover,
                    height: 260,
                    width: mediaSize.width * 0.37,
                  )
                : Image.asset(
                    item.imagePath,
                    fit: BoxFit.cover,
                    height: 260,
                    width: mediaSize.width * 0.37,
                  ),
            // Image.asset(
            //   item.imagePath,
            //   fit: BoxFit.cover,
            //   height: 260,
            //   width: mediaSize.width * 0.37,
            // ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // name
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          "Name:",
                          style: CustomTextStyle.getBoldTextStyle(
                            textColor: Colors.black,
                            textSize: AppTextSize.normalM1,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        flex: 7,
                        child: Text(
                          item.name,
                          style: CustomTextStyle.getNormalTextStyle(
                            textColor: Colors.black,
                            textSize: AppTextSize.extraSmall,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  // Description
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          "Description:",
                          style: CustomTextStyle.getBoldTextStyle(
                            textColor: Colors.black,
                            textSize: AppTextSize.normalM1,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        flex: 7,
                        child: Text(
                          item.description,
                          style: CustomTextStyle.getNormalTextStyle(
                            textColor: Colors.black,
                            textSize: AppTextSize.extraSmall,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  // Ingredients
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          "Ingredients:",
                          style: CustomTextStyle.getBoldTextStyle(
                            textColor: Colors.black,
                            textSize: AppTextSize.normalM1,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        flex: 7,
                        child: Text(
                          longHorizontalStringIntoFancyString(
                              item.ingredientsList),
                          style: CustomTextStyle.getNormalTextStyle(
                            textColor: Colors.black,
                            textSize: AppTextSize.extraSmall,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  // Instructions
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Instructions:",
                        style: CustomTextStyle.getBoldTextStyle(
                          textColor: Colors.black,
                          textSize: AppTextSize.normalM1,
                        ),
                      ),
                      const SizedBox(height: 0),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          longVerticalNumberStringIntoFancyString(
                              item.instructionsList),
                          style: CustomTextStyle.getNormalTextStyle(
                            textColor: Colors.black,
                            textSize: AppTextSize.extraSmall,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Tips and Tricks
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Tips and Tricks:",
                        style: CustomTextStyle.getBoldTextStyle(
                          textColor: Colors.black,
                          textSize: AppTextSize.normalM1,
                        ),
                      ),
                      const SizedBox(height: 0),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          longVerticalNumberStringIntoFancyString(
                              item.tipsAndTricksList),
                          style: CustomTextStyle.getNormalTextStyle(
                            textColor: Colors.black,
                            textSize: AppTextSize.extraSmall,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // allergies button
                  InkWell(
                    child: Container(
                      color: AppColor.primaryColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      child: Text(
                        "Show allergies",
                        style: CustomTextStyle.getBoldTextStyle(
                          textColor: Colors.white,
                          textSize: AppTextSize.extraSmall,
                        ),
                      ),
                    ),
                    onTap: () {
                      showDialog(
                        barrierColor: Colors.transparent,
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            contentPadding: const EdgeInsets.all(15),
                            insetPadding: const EdgeInsets.all(0),
                            titlePadding: const EdgeInsetsDirectional.all(0),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                              side: BorderSide(
                                color: AppColor.primaryColor,
                                width: 1,
                              ),
                            ),
                            title: getDesignedHeaderWithInfoIcon(
                                "Allergy Alert",
                                isCenter: false),
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Allergies:",
                                  style: CustomTextStyle.getBoldTextStyle(
                                    textColor: Colors.black,
                                    textSize: AppTextSize.normalM1,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: Text(
                                    longVerticalNumberStringIntoFancyString(
                                        item.allergiesList),
                                    style: CustomTextStyle.getNormalTextStyle(
                                      textColor: Colors.black,
                                      textSize: AppTextSize.extraSmall,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  // Allergies

                  /*
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Allergies:",
                        style: CustomTextStyle.getBoldTextStyle(
                          textColor: Colors.black,
                          textSize: AppTextSize.normalM1,
                        ),
                      ),
                      const SizedBox(height: 0),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          longVerticalNumberStringIntoFancyString(
                              item.allergiesList),
                          style: CustomTextStyle.getNormalTextStyle(
                            textColor: Colors.black,
                            textSize: AppTextSize.extraSmall,
                          ),
                        ),
                      ),
                    ],
                  ),
                  */
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String longHorizontalStringIntoFancyString(List<String> data) {
    String totalString = "";
    for (int i = 0; i < data.length; i++) {
      // totalString += data[i];
      //
      if (i == (data.length - 1)) {
        // final item
        totalString += data[i];
      } else {
        totalString += "${data[i]}, ";
      }
    }
    return totalString;
  }

  String longVerticalNumberStringIntoFancyString(List<String> data) {
    String totalString = "";
    for (int i = 0; i < data.length; i++) {
      //
      if (i == (data.length - 1)) {
        totalString += "${i + 1}: ${data[i]}";
      } else {
        totalString += "${i + 1}: ${data[i]}\n";
      }
    }
    return totalString;
  }
}

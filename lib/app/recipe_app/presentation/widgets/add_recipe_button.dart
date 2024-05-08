import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:receipe_app/core/widgets/round_button.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/asset_mapper/recipe_card_images_mapper.dart';
import '../../../../core/local_db/box_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utility/alert_header_design.dart';
import '../../../../core/utility/text_sizes.dart';
import '../../../../core/utility/validator.dart';
import '../../../../core/widgets/custom_textfield.dart';
import '../../models/food_dish_model.dart';
import '../../providers/refresh_provider.dart';

class RecipeAddButton extends StatefulWidget {
  final String email;
  final void Function() refreshParentState;

  const RecipeAddButton({
    super.key,
    required this.email,
    required this.refreshParentState,
  });

  @override
  State<RecipeAddButton> createState() => _RecipeAddButtonState();
}

class _RecipeAddButtonState extends State<RecipeAddButton> {
  String recipeName = "";
  String description = "";
  String ingredientsList = "";
  String instructionsList = "";
  String tipsAndTricksList = "";
  String allergiesList = "";
  Uint8List? imagePath;
  bool isFavourite = false;

  final GlobalKey<FormState> addFormKey = GlobalKey<FormState>();

  Future<Uint8List?> captureImagesFromGallery() async {
    try {
      // EasyLoading.show(status: 'please wait');
      final XFile? image =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image != null) {
        print("image has found");

        Uint8List imageData = await image.readAsBytes();
        // print('imageData: $imageData');
        //
        // EasyLoading.show(
        //     status: AppLocalizations.of(context)!.profileImageIsUpdating,
        //     dismissOnTap: false);
        // sending image to the server
        // await profileProvider.uploadProfileImage(image.path);

        // EasyLoading.showSuccess(
        //     AppLocalizations.of(context)!.profileImageHasUploadedSuccessfully,
        //     dismissOnTap: false,
        //     duration: const Duration(milliseconds: 600));
        //setState(() {});
        return imageData;
      } else {
        // EasyLoading.dismiss();
        print("No image has found");
        return null;
        print("Images is empty");
      }
    } catch (e) {
      print("while taking image from gallery: error: $e");
    }
  }

  List<String> convertStringIntoList(String data) {
    return data.split("\n");
  }

  Future<void> saveDataToHive() async {
    var uuid = Uuid();
    final Map userDataMap =
        Hive.box(HiveBoxName.foodRecipeStoreBox).get(widget.email);

    List<FoodDishModel> _allRecipeData = [];

    for (final key in userDataMap.keys) {
      final boxItem =
          userDataMap[key]; // get the food item against specific key
      final item = FoodDishModel.fromMap(boxItem);
      _allRecipeData.add(item);
    }

    // add the current data into hive and save it
    final newAddedItem = FoodDishModel(
      id: uuid.v4(),
      name: recipeName,
      description: description,
      ingredientsList: convertStringIntoList(ingredientsList),
      instructionsList: convertStringIntoList(instructionsList),
      isFavourite: isFavourite,
      allergiesList: convertStringIntoList(allergiesList),
      tipsAndTricksList: convertStringIntoList(tipsAndTricksList),
      isImageFromHive: true,
      imageStoredInHive: imagePath,
      imagePath: "",
    );

    final Map<String, dynamic> _foodDataMap = {};
    for (final FoodDishModel item in _allRecipeData) {
      _foodDataMap[item.id] = item.toMap();
    }
    _foodDataMap[newAddedItem.id] = newAddedItem.toMap();

    await Hive.box(HiveBoxName.foodRecipeStoreBox)
        .put(widget.email, _foodDataMap);
  }

  @override
  void initState() {
    super.initState();
  }

  // @override
  // void dispose() {
  //   imagePath = null;
  //   print("disposed r45");
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    const double heightBetweenfield = 20;
    const double heightLabelAndField = 5;
    final Size mediaSize = MediaQuery.sizeOf(context);
    print("build -> _RecipeAddButtonState");
    return FloatingActionButton(
      backgroundColor: AppColor.primaryColor,
      onPressed: () {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return AlertDialog(
              contentPadding: const EdgeInsets.all(30),
              insetPadding: const EdgeInsets.all(0),
              titlePadding: const EdgeInsetsDirectional.all(0),
              shape:
                  const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              title: getDesignedHeader("Add Recipe", isCenter: false),
              content: SizedBox(
                width: mediaSize.width * 0.35,
                height: mediaSize.height * 0.75,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // show for image upload
                      StatefulBuilder(
                        builder: (context, setState) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // image showing container
                              Container(
                                height: 180,
                                width: 180,
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(2.0),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: imagePath != null
                                    ? Image.memory(imagePath!,
                                        fit: BoxFit.cover)
                                    : const Icon(
                                        Icons.broken_image_outlined,
                                        size: 180,
                                      ),
                              ),
                              const SizedBox(height: 4.0),
                              // image add button
                              Container(
                                color: AppColor.primaryColor,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 3, horizontal: 15),
                                margin: const EdgeInsets.only(left: 5),
                                child: InkWell(
                                  onTap: () async {
                                    // add image
                                    Uint8List? imageRawBinaryList =
                                        await captureImagesFromGallery();
                                    if (imageRawBinaryList != null) {
                                      // print(
                                      //     "image uint8List: $imageRawBinaryList");
                                      imagePath = imageRawBinaryList;
                                      setState(() {});
                                    }
                                  },
                                  child: Text(
                                    "Add Image",
                                    style: CustomTextStyle.getBoldTextStyle(
                                      textColor: Colors.white,
                                      textSize: AppTextSize.small,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),

                      // add image button

                      const SizedBox(height: heightBetweenfield),
                      Form(
                        key: addFormKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // name field
                            Text(
                              "Name",
                              style: CustomTextStyle.getBoldTextStyle(
                                textColor: Colors.black,
                                textSize: AppTextSize.small,
                              ),
                            ),
                            const SizedBox(height: heightLabelAndField),
                            CustomTextFormField(
                              hintText: "Write name",
                              labelText: "Name",
                              isEnd: false,
                              isNumKeyboardType: false,
                              validate: (name) {
                                return AuthenticationValidator.nameValidator(
                                    name);
                              },
                              save: (name) {
                                recipeName = name!;
                              },
                            ),
                            const SizedBox(height: heightBetweenfield),

                            // description
                            Text(
                              "Description",
                              style: CustomTextStyle.getBoldTextStyle(
                                textColor: Colors.black,
                                textSize: AppTextSize.small,
                              ),
                            ),
                            const SizedBox(height: heightLabelAndField),
                            CustomTextFormField(
                              hintText: "Write description",
                              labelText: "Description",
                              isEnd: false,
                              maxlines: 2,
                              isNumKeyboardType: false,
                              validate: (name) {
                                return AuthenticationValidator.nameValidator(
                                    name);
                              },
                              save: (name) {
                                description = name!;
                              },
                            ),
                            const SizedBox(height: heightBetweenfield),
                            // ingredient
                            Text(
                              "Ingredients",
                              style: CustomTextStyle.getBoldTextStyle(
                                textColor: Colors.black,
                                textSize: AppTextSize.small,
                              ),
                            ),
                            const SizedBox(height: heightLabelAndField),
                            CustomTextFormField(
                              hintText: "Write ingredients",
                              labelText: "Ingredients",
                              isEnd: false,
                              maxlines: 2,
                              isNumKeyboardType: false,
                              validate: (name) {
                                return AuthenticationValidator.nameValidator(
                                    name);
                              },
                              save: (name) {
                                ingredientsList = name!;
                              },
                            ),
                            const SizedBox(height: heightBetweenfield),
                            // instructions
                            Text(
                              "Instructions",
                              style: CustomTextStyle.getBoldTextStyle(
                                textColor: Colors.black,
                                textSize: AppTextSize.small,
                              ),
                            ),
                            const SizedBox(height: heightLabelAndField),
                            CustomTextFormField(
                              hintText:
                                  "Write each instruction on separate line",
                              labelText: "Instructions",
                              isEnd: false,
                              maxlines: 2,
                              isNumKeyboardType: false,
                              validate: (name) {
                                return AuthenticationValidator.nameValidator(
                                    name);
                              },
                              save: (name) {
                                instructionsList = name!;
                              },
                            ),
                            const SizedBox(height: heightBetweenfield),
                            // tipsAndTricks
                            Text(
                              "Tips And Tricks",
                              style: CustomTextStyle.getBoldTextStyle(
                                textColor: Colors.black,
                                textSize: AppTextSize.small,
                              ),
                            ),
                            const SizedBox(height: heightLabelAndField),
                            CustomTextFormField(
                              hintText:
                                  "Write each tips and Tricks on separate line",
                              labelText: "Tips And Tricks",
                              isEnd: false,
                              maxlines: 2,
                              isNumKeyboardType: false,
                              validate: (name) {
                                return AuthenticationValidator.nameValidator(
                                    name);
                              },
                              save: (name) {
                                tipsAndTricksList = name!;
                              },
                            ),
                            const SizedBox(height: heightBetweenfield),
                            // allergiesList
                            Text(
                              "Allergies",
                              style: CustomTextStyle.getBoldTextStyle(
                                textColor: Colors.black,
                                textSize: AppTextSize.small,
                              ),
                            ),
                            const SizedBox(height: heightLabelAndField),
                            CustomTextFormField(
                              hintText: "Write each allergy on separate line",
                              labelText: "Allergies",
                              isEnd: false,
                              maxlines: 2,
                              isNumKeyboardType: false,
                              validate: (name) {
                                return AuthenticationValidator.nameValidator(
                                    name);
                              },
                              save: (name) {
                                allergiesList = name!;
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: heightBetweenfield),
                      const SizedBox(height: heightBetweenfield),
                      Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            RoundedButtonStyle(
                              text: "Cancel",
                              onTap: () async {
                                imagePath = null;
                                widget.refreshParentState();
                                Navigator.of(context).pop();
                              },
                              isEnable: true,
                            ),
                            const SizedBox(width: 25),
                            RoundedButtonStyle(
                              text: "Add recipe",
                              onTap: () async {
                                // add the recipe in hive
                                if (addFormKey.currentState!.validate()) {
                                  //
                                  addFormKey.currentState!.save();
                                  if (imagePath == null) {
                                    print("Image cant be left");
                                    return;
                                  }

                                  EasyLoading.show(
                                    status: "Storing recipe",
                                    dismissOnTap: false,
                                  );
                                  await saveDataToHive();
                                  EasyLoading.showSuccess(
                                    "Recipe has stored",
                                    duration: const Duration(seconds: 1),
                                    dismissOnTap: false,
                                  );
                                  imagePath = null;
                                  widget.refreshParentState();
                                  // Provider.of<RefreshProvider>(context, listen: false).refreshDisplay();
                                  Navigator.of(context).pop();
                                }
                              },
                              isEnable: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
      child: const Icon(Icons.add, color: Colors.white),
    );
  }
}
/*

class EditRecipeAddButton extends StatefulWidget {
  final String email;
  final String itemId;
  // final void Function() refreshParentState;

  const EditRecipeAddButton({
    super.key,
    required this.email,
    required this.itemId,
    // required this.refreshParentState,
  });

  @override
  State<EditRecipeAddButton> createState() => _EditRecipeAddButtonState();
}

class _EditRecipeAddButtonState extends State<EditRecipeAddButton> {
  String recipeName = "";
  String description = "";
  String ingredientsList = "";
  String instructionsList = "";
  String tipsAndTricksList = "";
  String allergiesList = "";
  Uint8List? imagePath;
  bool isFavourite = false;

  final GlobalKey<FormState> editFormKey = GlobalKey<FormState>();

  Future<Uint8List?> captureImagesFromGallery() async {
    try {
      // EasyLoading.show(status: 'please wait');
      final XFile? image =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image != null) {
        print("image has found");

        Uint8List imageData = await image.readAsBytes();
        // print('imageData: $imageData');
        //
        // EasyLoading.show(
        //     status: AppLocalizations.of(context)!.profileImageIsUpdating,
        //     dismissOnTap: false);
        // sending image to the server
        // await profileProvider.uploadProfileImage(image.path);

        // EasyLoading.showSuccess(
        //     AppLocalizations.of(context)!.profileImageHasUploadedSuccessfully,
        //     dismissOnTap: false,
        //     duration: const Duration(milliseconds: 600));
        //setState(() {});
        return imageData;
      } else {
        // EasyLoading.dismiss();
        print("No image has found");
        return null;
        print("Images is empty");
      }
    } catch (e) {
      print("while taking image from gallery: error: $e");
    }
  }

  List<String> convertStringIntoList(String data) {
    return data.split(".");
  }

  String convertListIntoString(List<String> data) {
    String totalString = "";
    for (final str in data) {
      totalString += str;
    }
    return totalString;
  }

  Future<void> saveDataToHive() async {
    var uuid = Uuid();
    final Map userDataMap =
        Hive.box(HiveBoxName.foodRecipeStoreBox).get(widget.email);

    List<FoodDishModel> _allRecipeData = [];

    for (final key in userDataMap.keys) {
      final boxItem =
          userDataMap[key]; // get the food item against specific key
      final item = FoodDishModel.fromMap(boxItem);
      _allRecipeData.add(item);
    }

    // add the current data into hive and save it
    final newAddedItem = FoodDishModel(
      id: uuid.v4(),
      name: recipeName,
      description: description,
      ingredientsList: convertStringIntoList(ingredientsList),
      instructionsList: convertStringIntoList(instructionsList),
      isFavourite: isFavourite,
      allergiesList: convertStringIntoList(allergiesList),
      tipsAndTricksList: convertStringIntoList(tipsAndTricksList),
      isImageFromHive: true,
      imageStoredInHive: imagePath,
      imagePath: "",
    );

    final Map<String, dynamic> _foodDataMap = {};
    for (final FoodDishModel item in _allRecipeData) {
      _foodDataMap[item.id] = item.toMap();
    }
    _foodDataMap[newAddedItem.id] = newAddedItem.toMap();

    await Hive.box(HiveBoxName.foodRecipeStoreBox)
        .put(widget.email, _foodDataMap);
  }

  @override
  Widget build(BuildContext context) {
    const double heightBetweenfield = 20;
    const double heightLabelAndField = 5;
    final Size mediaSize = MediaQuery.sizeOf(context);
    return FloatingActionButton(
      backgroundColor: AppColor.primaryColor,
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              contentPadding: const EdgeInsets.all(30),
              insetPadding: const EdgeInsets.all(0),
              titlePadding: const EdgeInsetsDirectional.all(0),
              shape:
                  const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              title: getDesignedHeader("Add Recipe", isCenter: false),
              content: SizedBox(
                width: mediaSize.width * 0.35,
                height: mediaSize.height * 0.75,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // show for image upload
                      StatefulBuilder(
                        builder: (context, setState) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // image showing container
                              Container(
                                height: 180,
                                width: 180,
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(2.0),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: imagePath != null
                                    ? Image.memory(imagePath!,
                                        fit: BoxFit.cover)
                                    : const Icon(
                                        Icons.broken_image_outlined,
                                        size: 180,
                                      ),
                              ),
                              const SizedBox(height: 4.0),
                              // image add button
                              Container(
                                color: AppColor.primaryColor,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 3, horizontal: 15),
                                margin: const EdgeInsets.only(left: 5),
                                child: InkWell(
                                  onTap: () async {
                                    // add image
                                    Uint8List? imageRawBinaryList =
                                        await captureImagesFromGallery();
                                    if (imageRawBinaryList != null) {
                                      print(
                                          "image uint8List: $imageRawBinaryList");
                                      this.imagePath = imageRawBinaryList;
                                      setState(() {});
                                    }
                                  },
                                  child: Text(
                                    "Add Image",
                                    style: CustomTextStyle.getBoldTextStyle(
                                      textColor: Colors.white,
                                      textSize: AppTextSize.small,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),

                      // add image button

                      const SizedBox(height: heightBetweenfield),
                      Form(
                        key: editFormKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // name field
                            Text(
                              "Name",
                              style: CustomTextStyle.getBoldTextStyle(
                                textColor: Colors.black,
                                textSize: AppTextSize.small,
                              ),
                            ),
                            const SizedBox(height: heightLabelAndField),
                            CustomTextFormFieldWithController(
                              controller:
                                  TextEditingController(text: recipeName),
                              hintText: "Enter name",
                              labelText: "Name",
                              isEnd: false,
                              isNumKeyboardType: false,
                              validate: (name) {
                                return AuthenticationValidator.nameValidator(
                                    name);
                              },
                              save: (name) {
                                recipeName = name!;
                              },
                            ),
                            const SizedBox(height: heightBetweenfield),

                            // description
                            Text(
                              "Description",
                              style: CustomTextStyle.getBoldTextStyle(
                                textColor: Colors.black,
                                textSize: AppTextSize.small,
                              ),
                            ),
                            const SizedBox(height: heightLabelAndField),
                            CustomTextFormFieldWithController(
                              controller:
                                  TextEditingController(text: description),
                              hintText: "Enter description",
                              labelText: "Description",
                              isEnd: false,
                              maxlines: 2,
                              isNumKeyboardType: false,
                              validate: (name) {
                                return AuthenticationValidator.nameValidator(
                                    name);
                              },
                              save: (name) {
                                description = name!;
                              },
                            ),
                            const SizedBox(height: heightBetweenfield),
                            // ingredient
                            Text(
                              "Ingredients",
                              style: CustomTextStyle.getBoldTextStyle(
                                textColor: Colors.black,
                                textSize: AppTextSize.small,
                              ),
                            ),
                            const SizedBox(height: heightLabelAndField),
                            CustomTextFormFieldWithController(
                              controller:
                                  TextEditingController(text: ingredientsList),
                              hintText: "Enter ingredients",
                              labelText: "Ingredients",
                              isEnd: false,
                              maxlines: 2,
                              isNumKeyboardType: false,
                              validate: (name) {
                                return AuthenticationValidator.nameValidator(
                                    name);
                              },
                              save: (name) {
                                ingredientsList = name!;
                              },
                            ),
                            const SizedBox(height: heightBetweenfield),
                            // instructions
                            Text(
                              "Instructions",
                              style: CustomTextStyle.getBoldTextStyle(
                                textColor: Colors.black,
                                textSize: AppTextSize.small,
                              ),
                            ),
                            const SizedBox(height: heightLabelAndField),
                            CustomTextFormFieldWithController(
                              controller:
                                  TextEditingController(text: instructionsList),
                              hintText: "Enter instructions",
                              labelText: "Instructions",
                              isEnd: false,
                              maxlines: 2,
                              isNumKeyboardType: false,
                              validate: (name) {
                                return AuthenticationValidator.nameValidator(
                                    name);
                              },
                              save: (name) {
                                instructionsList = name!;
                              },
                            ),
                            const SizedBox(height: heightBetweenfield),
                            // tipsAndTricks
                            Text(
                              "Tips And Tricks",
                              style: CustomTextStyle.getBoldTextStyle(
                                textColor: Colors.black,
                                textSize: AppTextSize.small,
                              ),
                            ),
                            const SizedBox(height: heightLabelAndField),
                            CustomTextFormFieldWithController(
                              controller: TextEditingController(
                                  text: tipsAndTricksList),
                              hintText: "Enter tips and Tricks",
                              labelText: "Tips And Tricks",
                              isEnd: false,
                              maxlines: 2,
                              isNumKeyboardType: false,
                              validate: (name) {
                                return AuthenticationValidator.nameValidator(
                                    name);
                              },
                              save: (name) {
                                tipsAndTricksList = name!;
                              },
                            ),
                            const SizedBox(height: heightBetweenfield),
                            // allergiesList
                            Text(
                              "Allergies",
                              style: CustomTextStyle.getBoldTextStyle(
                                textColor: Colors.black,
                                textSize: AppTextSize.small,
                              ),
                            ),
                            const SizedBox(height: heightLabelAndField),
                            CustomTextFormFieldWithController(
                              controller:
                                  TextEditingController(text: allergiesList),
                              hintText: "Enter allergies",
                              labelText: "Allergies",
                              isEnd: false,
                              maxlines: 2,
                              isNumKeyboardType: false,
                              validate: (name) {
                                return AuthenticationValidator.nameValidator(
                                    name);
                              },
                              save: (name) {
                                allergiesList = name!;
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: heightBetweenfield),
                      const SizedBox(height: heightBetweenfield),
                      Center(
                        child: RoundedButtonStyle(
                          text: "Update recipe",
                          onTap: true
                              ? null
                              : () async {
                                  // add the recipe in hive
                                  if (editFormKey.currentState!.validate()) {
                                    //
                                    editFormKey.currentState!.save();
                                    if (imagePath == null) {
                                      print("Image cant be left");
                                      return;
                                    }

                                    EasyLoading.show(
                                      status: "Storing recipe",
                                      dismissOnTap: false,
                                    );
                                    await saveDataToHive();
                                    EasyLoading.showSuccess(
                                      "Recipe has stored",
                                      duration: const Duration(seconds: 1),
                                      dismissOnTap: false,
                                    );
                                    // widget.refreshParentState();
                                    // Provider.of<RefreshProvider>(context, listen: false).refreshDisplay();
                                    Navigator.of(context).pop();
                                  }
                                },
                          isEnable: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
      child: const Icon(Icons.edit, color: Colors.white),
    );
  }
}
*/

//     String recipeName = foodItem.name;
//     String description = foodItem.description;
//     String ingredientsList = convertListIntoString(foodItem.ingredientsList);
//     String instructionsList = convertListIntoString(foodItem.instructionsList);
//     String tipsAndTricksList = convertListIntoString(foodItem.tipsAndTricksList);
//     String allergiesList = convertListIntoString(foodItem.allergiesList);
//     Uint8List? imageUint8List = foodItem.isImageFromHive ? foodItem.imageStoredInHive : null;
//     bool isImageFromHive = foodItem.isImageFromHive;
//     bool isFavourite = foodItem.isFavourite;
//     String imagePathStored = foodItem.isImageFromHive ? foodItem.imagePath : "";

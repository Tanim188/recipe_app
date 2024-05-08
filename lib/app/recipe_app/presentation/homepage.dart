import 'dart:async';
import 'dart:js_interop';
import 'dart:typed_data';
import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:receipe_app/app/authentication/presentation/pages/authentication_page.dart';
import 'package:receipe_app/app/recipe_app/presentation/widgets/add_recipe_button.dart';
import 'package:receipe_app/app/recipe_app/presentation/widgets/homepage_carousel_header_widget.dart';
import 'package:receipe_app/app/recipe_app/presentation/widgets/show_recipe_widget.dart';
import 'package:receipe_app/core/app_routing/route_names.dart';
import 'package:receipe_app/core/theme/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:uuid/uuid.dart';

import '../../../core/asset_mapper/background_images_mapper.dart';
import '../../../core/asset_mapper/recipe_carousel_images_mapper.dart';
import '../../../core/local_db/box_names.dart';
import '../../../core/utility/alert_header_design.dart';
import '../../../core/utility/text_sizes.dart';
import '../../../core/utility/validator.dart';
import '../../../core/widgets/custom_textfield.dart';
import '../../../core/widgets/round_button.dart';
import '../../authentication/model/signup_model.dart';
import '../models/food_dish_model.dart';
import '../providers/refresh_provider.dart';
import '../providers/search_bar_provider.dart';

class RecipeHomepage extends StatefulWidget {
  final String email;

  const RecipeHomepage({
    super.key,
    required this.email,
  });

  @override
  State<RecipeHomepage> createState() => _RecipeHomepageState();
}

class _RecipeHomepageState extends State<RecipeHomepage> {
  late final Box signupBox;
  late final Box foodRecipeStoreBox;
  bool isHover = false;

  // late final Box sessionStorageStoreBox;
  final List<FoodDishModel> ukFoodDishListFromHive = [];

  void removeFromHiveList(String index) {
    return ukFoodDishListFromHive.removeWhere((element) => element.id == index);
  }

  Future<void> saveDataToHive() async {
    final Map<String, dynamic> _foodDataMap = {};
    for (final item in ukFoodDishListFromHive) {
      _foodDataMap[item.id] = item.toMap();
    }

    await foodRecipeStoreBox.put(widget.email, _foodDataMap);
  }

  Future<void> setFoodAsFavourite() async {
    // for(int i=0; i<ukFoodDishListFromHive.length; i++){
    //   if(ukFoodDishListFromHive[i].id == foodId){
    //     //
    //     ukFoodDishListFromHive[i].isFavourite = !ukFoodDishListFromHive[i].isFavourite;
    //   }
    // }

    final Map<String, dynamic> _foodDataMap = {};
    for (final item in ukFoodDishListFromHive) {
      _foodDataMap[item.id] = item.toMap();
    }

    await foodRecipeStoreBox.put(widget.email, _foodDataMap);
  }

  @override
  void initState() {
    super.initState();
    signupBox = Hive.box(HiveBoxName.signupBox);
    foodRecipeStoreBox = Hive.box(HiveBoxName.foodRecipeStoreBox);

    final Map userDataMap =
        foodRecipeStoreBox.get(widget.email); // get the map against this email
    //
    // print("homepage data: $userDataMap");
    //
    for (final key in userDataMap.keys) {
      final boxItem =
          userDataMap[key]; // get the food item against specific key
      final item = FoodDishModel.fromMap(boxItem);
      ukFoodDishListFromHive.add(item);
      // if (boxItem is Map) {
      //   // boxItem is Map
      //   final item = FoodDishModel.fromMap(boxItem.cast());
      //   ukFoodDishListFromHive.add(item);
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    print("parent 1w3 rebuilding");
    // Provider.of<RefreshProvider>(context, listen: true);
    final mediaSize = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.white,
      /*
        appBar: AppBar(
        centerTitle: false,
        backgroundColor: AppColor.primaryColor,
        // leading: Text(
        //   "Welcome to user",
        //   style: CustomTextStyle.getNormalTextStyle(
        //     textColor: Colors.white,
        //     textSize: AppTextSize.medium,
        //   ),
        // ),
        /**/
        title: Text(
          // "Login user:  ${(signupBox.get(widget.email) as Map)["name"]}",
          "Login user: Test-User",
          style: CustomTextStyle.getBoldTextStyle(
            textColor: Colors.white,
            textSize: AppTextSize.normal,
          ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          /*
          SizedBox(
            height: 600,
            width: 250,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: 0,
                  width: 250,
                  height: 35,
                  child: SearchFilter(email: widget.email),
                ),
                const Positioned(
                  top: 40,
                  width: 250,
                  height: 600,
                  child: SelectedMedicineWidget(),
                ),
              ],
            ),
          ),
          */
          // const SizedBox(width: 10),
          // const SelectedMedicineWidget(),
          IconButton(
            onPressed: () {
              // showing all favourites food item selected by user
              final allFavouriteItem = FoodDishModel.getAllFavouriteFoodDishes(
                  ukFoodDishListFromHive);
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    contentPadding: const EdgeInsets.all(20),
                    insetPadding: const EdgeInsets.all(0),
                    titlePadding: const EdgeInsetsDirectional.all(0),
                    // title: Text(
                    //   "Favourite Food Item",
                    //   style: CustomTextStyle.getBoldTextStyle(
                    //     textColor: Colors.black,
                    //     textSize: AppTextSize.large,
                    //   ),
                    // ),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero),
                    title: getDesignedHeader("Favourite Food Item"),
                    content: allFavouriteItem.isEmpty
                        ? SizedBox(
                            width: mediaSize.width * 0.55,
                            height: 450,
                            child: Center(
                              child: Text(
                                "No items found",
                                style: CustomTextStyle.getBoldTextStyle(
                                  textColor: Colors.black,
                                  textSize: AppTextSize.large,
                                ),
                              ),
                            ),
                          )
                        : Container(
                            // displaying favourite items
                            // color: Colors.teal,
                            width: mediaSize.width * 0.55,
                            height: 450,
                            child: GridView.builder(
                              scrollDirection: Axis.vertical,
                              physics: const BouncingScrollPhysics(),
                              // shrinkWrap: true,
                              itemCount: allFavouriteItem.length,
                              itemBuilder: (context, index) {
                                // ukFoodDishList
                                final foodItem = allFavouriteItem[index];
                                return Container(
                                  // width: 250,
                                  // height: 200,
                                  // color: index % 2 == 0 ? Colors.blue : Colors.orange,
                                  child: GridTile(
                                    footer: GridTileBar(
                                      backgroundColor: AppColor.primaryColor
                                          .withOpacity(0.6),
                                      leading: foodItem.isFavourite
                                          ? const Icon(
                                              Icons.favorite,
                                              color: Colors.white,
                                            )
                                          : const Icon(
                                              Icons.favorite_border,
                                              color: Colors.white,
                                            ),
                                      title: Text(
                                        foodItem.name,
                                        style: CustomTextStyle.getBoldTextStyle(
                                          textColor: Colors.white,
                                          textSize: AppTextSize.extraSmall,
                                        ),
                                      ),
                                    ),
                                    child: Image.asset(
                                      foodItem.imagePath,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              },
                              // separatorBuilder: (context, index) {
                              //   return const SizedBox(width: 80);
                              // },
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                crossAxisSpacing: 120,
                                mainAxisSpacing: 70,
                                maxCrossAxisExtent: 260, // height: 270
                                mainAxisExtent: 260, // width: 260
                              ),
                            ),
                          ),
                  );
                },
              );
            },
            icon: const Icon(
              Icons.favorite_outline_sharp,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            onPressed: () async {
              // store user session state
              Map<dynamic, dynamic> userData = signupBox.get(widget.email);
              userData["isLogout"] = "false";
              await signupBox.put(widget.email, userData);
              // sessionStorageStoreBox.put(
              //     widget.email, UserLoginState.logout.name);
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) {
                  return const AuthenticationPage();
                },
              ));
              // Navigator.of(context)
              //     .pushNamed(RecipeRouteName.authenticationPage);
            },
            icon: const Icon(
              Icons.logout_outlined,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
      */
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          // clipBehavior: Clip.none,
          children: [
            Positioned(
              // width: mediaSize.width,
              // height: mediaSize.height,
              top: 0,
              bottom: 150,
              left: 0,
              right: 0,
              child: Container(
                width: mediaSize.width,
                height: mediaSize.height,
                // decoration: const BoxDecoration(
                //   // color: Colors.red,
                //   image: DecorationImage(
                //     image: AssetImage(BackgroundImages.homepageBackgroundImage),
                //     fit: BoxFit.cover,
                //   ),
                // ),

                child: Column(
                  children: [
                    AppBar(
                      centerTitle: false,
                      backgroundColor: AppColor.primaryColor,
                      title: Text(
                        "Login user: ${(signupBox.get(widget.email) as Map)["name"]}",
                        style: CustomTextStyle.getNormalTextStyle(
                          textColor: Colors.white,
                          textSize: AppTextSize.normalM1,
                        ),
                      ),
                      automaticallyImplyLeading: false,
                      actions: [
                        SearchFilter(email: widget.email),

                        // const SizedBox(width: 10),
                        // const SelectedMedicineWidget(),
                        const SizedBox(width: 30),
                        IconButton(
                          onPressed: () {
                            // showing all favourites food item selected by user
                            final allFavouriteItem =
                                FoodDishModel.getAllFavouriteFoodDishes(
                                    ukFoodDishListFromHive);
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  contentPadding: const EdgeInsets.all(20),
                                  insetPadding: const EdgeInsets.all(0),
                                  titlePadding:
                                      const EdgeInsetsDirectional.all(0),
                                  // title: Text(
                                  //   "Favourite Food Item",
                                  //   style: CustomTextStyle.getBoldTextStyle(
                                  //     textColor: Colors.black,
                                  //     textSize: AppTextSize.large,
                                  //   ),
                                  // ),
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.zero),
                                  title:
                                      getDesignedHeader("Favourite Food Item"),
                                  content: allFavouriteItem.isEmpty
                                      ? SizedBox(
                                          width: mediaSize.width * 0.55,
                                          height: 450,
                                          child: Center(
                                            child: Text(
                                              "No items found",
                                              style: CustomTextStyle
                                                  .getBoldTextStyle(
                                                textColor: Colors.black,
                                                textSize: AppTextSize.large,
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container(
                                          // displaying favourite items
                                          // color: Colors.teal,
                                          width: mediaSize.width * 0.55,
                                          height: 450,
                                          child: GridView.builder(
                                            scrollDirection: Axis.vertical,
                                            physics:
                                                const BouncingScrollPhysics(),
                                            // shrinkWrap: true,
                                            itemCount: allFavouriteItem.length,
                                            itemBuilder: (context, index) {
                                              // ukFoodDishList
                                              final foodItem =
                                                  allFavouriteItem[index];
                                              return Container(
                                                // width: 250,
                                                // height: 200,
                                                // color: index % 2 == 0 ? Colors.blue : Colors.orange,
                                                child: GridTile(
                                                  footer: GridTileBar(
                                                    backgroundColor: AppColor
                                                        .primaryColor
                                                        .withOpacity(0.6),
                                                    leading: foodItem
                                                            .isFavourite
                                                        ? const Icon(
                                                            Icons.favorite,
                                                            color: Colors.white,
                                                          )
                                                        : const Icon(
                                                            Icons
                                                                .favorite_border,
                                                            color: Colors.white,
                                                          ),
                                                    title: Text(
                                                      foodItem.name,
                                                      style: CustomTextStyle
                                                          .getBoldTextStyle(
                                                        textColor: Colors.white,
                                                        textSize: AppTextSize
                                                            .extraSmall,
                                                      ),
                                                    ),
                                                  ),
                                                  child: foodItem
                                                              .isImageFromHive ==
                                                          true
                                                      ? Image.memory(
                                                          foodItem
                                                              .imageStoredInHive!,
                                                          fit: BoxFit.cover,
                                                        )
                                                      : Image.asset(
                                                          foodItem.imagePath,
                                                          fit: BoxFit.cover,
                                                        ),
                                                ),
                                              );
                                            },
                                            // separatorBuilder: (context, index) {
                                            //   return const SizedBox(width: 80);
                                            // },
                                            gridDelegate:
                                                const SliverGridDelegateWithMaxCrossAxisExtent(
                                              crossAxisSpacing: 40,
                                              mainAxisSpacing: 40,
                                              maxCrossAxisExtent:
                                                  320, // height: 270
                                              mainAxisExtent: 280, // width: 260
                                            ),
                                          ),
                                        ),
                                );
                              },
                            );
                          },
                          icon: const Icon(
                            Icons.favorite_outline_sharp,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          onPressed: () async {
                            String userNewName = "";
                            // change user name
                            // widget.email
                            Map<dynamic, dynamic> userData =
                                signupBox.get(widget.email);

                            await showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  contentPadding: const EdgeInsets.all(20),
                                  insetPadding: const EdgeInsets.all(0),
                                  titlePadding:
                                      const EdgeInsetsDirectional.all(0),
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.zero),
                                  title: getDesignedHeader("Change Name",
                                      isCenter: false),
                                  content: SizedBox(
                                    width: mediaSize.width * 0.25,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // name field
                                        Text(
                                          "Name",
                                          style:
                                              CustomTextStyle.getBoldTextStyle(
                                            textColor: Colors.black,
                                            textSize: AppTextSize.extraSmall,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        TextField(
                                          controller: TextEditingController(
                                              text: userData["name"]),
                                          style: const TextStyle(fontSize: 14),
                                          maxLines: 1,
                                          textInputAction: TextInputAction.done,
                                          keyboardType: TextInputType.text,
                                          decoration: InputDecoration(
                                            errorMaxLines: 10,
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 15,
                                                    horizontal: 25),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(0),
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(0),
                                              borderSide: BorderSide.none,
                                            ),
                                            fillColor: Colors.white,
                                            filled: true,
                                            hintText: "Enter name",
                                            label: const Text("Name"),
                                            isDense: true,
                                          ),
                                          onChanged: (value) {
                                            userNewName = value;
                                          },
                                        ),
                                        const SizedBox(height: 20),
                                        InkWell(
                                          child: Container(
                                            color: AppColor.primaryColor,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 8),
                                            child: Text(
                                              "Change Password",
                                              style: CustomTextStyle
                                                  .getBoldTextStyle(
                                                textColor: Colors.white,
                                                textSize:
                                                    AppTextSize.extraSmall,
                                              ),
                                            ),
                                          ),
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                String password = "";
                                                String confirmPassword = "";
                                                return AlertDialog(
                                                  contentPadding:
                                                      const EdgeInsets.all(15),
                                                  insetPadding:
                                                      const EdgeInsets.all(0),
                                                  titlePadding:
                                                      const EdgeInsetsDirectional
                                                          .all(0),
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .zero),
                                                  title: getDesignedHeader(
                                                      "Change Password",
                                                      isCenter: false),
                                                  content: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      TextField(
                                                        style: const TextStyle(
                                                            fontSize: 14),
                                                        maxLines: 1,
                                                        textInputAction:
                                                            TextInputAction
                                                                .done,
                                                        keyboardType:
                                                            TextInputType.text,
                                                        obscureText: true,
                                                        decoration:
                                                            InputDecoration(
                                                          errorMaxLines: 10,
                                                          contentPadding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 15,
                                                                  horizontal:
                                                                      25),
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        0),
                                                          ),
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        0),
                                                            borderSide:
                                                                BorderSide.none,
                                                          ),
                                                          fillColor:
                                                              Colors.white,
                                                          filled: true,
                                                          hintText:
                                                              "Enter password",
                                                          label: const Text(
                                                              "Password"),
                                                          isDense: true,
                                                        ),
                                                        onChanged: (value) {
                                                          password = value;
                                                        },
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      TextField(
                                                        style: const TextStyle(
                                                            fontSize: 14),
                                                        maxLines: 1,
                                                        textInputAction:
                                                            TextInputAction
                                                                .done,
                                                        keyboardType:
                                                            TextInputType.text,
                                                        obscureText: true,
                                                        decoration:
                                                            InputDecoration(
                                                          errorMaxLines: 10,
                                                          contentPadding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 15,
                                                                  horizontal:
                                                                      25),
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        0),
                                                          ),
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        0),
                                                            borderSide:
                                                                BorderSide.none,
                                                          ),
                                                          fillColor:
                                                              Colors.white,
                                                          filled: true,
                                                          hintText:
                                                              "Confirm password",
                                                          label: const Text(
                                                              "Confirm Password"),
                                                          isDense: true,
                                                        ),
                                                        onChanged: (value) {
                                                          confirmPassword =
                                                              value;
                                                        },
                                                      ),
                                                      const SizedBox(
                                                          height: 30),

                                                      //
                                                      Center(
                                                        child:
                                                            RoundedButtonStyle(
                                                          text:
                                                              "Change password",
                                                          onTap: () async {
                                                            if (password
                                                                .isEmpty) {
                                                              EasyLoading.showError(
                                                                  "Password cant be empty",
                                                                  dismissOnTap:
                                                                      true);
                                                              return;
                                                            }
                                                            if (confirmPassword
                                                                .isEmpty) {
                                                              EasyLoading.showError(
                                                                  "Confirm Password cant be empty",
                                                                  dismissOnTap:
                                                                      true);
                                                              return;
                                                            }
                                                            if (password !=
                                                                confirmPassword) {
                                                              EasyLoading.showError(
                                                                  "Password does not matched",
                                                                  dismissOnTap:
                                                                      true);
                                                              return;
                                                            }

                                                            final String? msg =
                                                                AuthenticationValidator
                                                                    .passwordValidator(
                                                                        password);
                                                            if (msg != null) {
                                                              EasyLoading
                                                                  .showError(
                                                                      msg,
                                                                      dismissOnTap:
                                                                          true);
                                                              return;
                                                            }

                                                            final String? cmsg =
                                                                AuthenticationValidator
                                                                    .passwordValidator(
                                                                        confirmPassword);
                                                            if (cmsg != null) {
                                                              EasyLoading
                                                                  .showError(
                                                                      cmsg,
                                                                      dismissOnTap:
                                                                          true);
                                                              return;
                                                            }
                                                            // update user name
                                                            userData[
                                                                    "password"] =
                                                                confirmPassword;
                                                            await signupBox.put(
                                                                widget.email,
                                                                userData);
                                                            EasyLoading
                                                                .showSuccess(
                                                              "Password has changed",
                                                              dismissOnTap:
                                                                  false,
                                                              duration:
                                                                  const Duration(
                                                                      seconds:
                                                                          1),
                                                            );
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          isEnable: true,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          height: 20),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        ),
                                        const SizedBox(height: 60),
                                        // update user name
                                        Center(
                                          child: RoundedButtonStyle(
                                            text: "Update",
                                            onTap: () async {
                                              // add the recipe in hive
                                              if (userNewName.trim().isEmpty ==
                                                  true) {
                                                EasyLoading.showError(
                                                    "Name cant be empty",
                                                    duration: const Duration(
                                                        seconds: 1),
                                                    dismissOnTap: false);
                                                return;
                                              } else {
                                                // update user name
                                                userData["name"] = userNewName;
                                                await signupBox.put(
                                                    widget.email, userData);
                                                EasyLoading.showSuccess(
                                                  "User name has updated",
                                                  dismissOnTap: false,
                                                  duration: const Duration(
                                                      seconds: 1),
                                                );
                                                Navigator.of(context).pop();
                                              }
                                            },
                                            isEnable: true,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                            setState(() {});
                            // sessionStorageStoreBox.put(
                            //     widget.email, UserLoginState.logout.name);
                            // Navigator.of(context).push(MaterialPageRoute(
                            //   builder: (context) {
                            //     return const AuthenticationPage();
                            //   },
                            // ));
                            // --
                            // Navigator.of(context)
                            //     .pushNamed(RecipeRouteName.authenticationPage);
                          },
                          icon: const Icon(
                            FontAwesomeIcons.userPen,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          onPressed: () async {
                            // store user session state
                            Map<dynamic, dynamic> userData =
                                signupBox.get(widget.email);
                            userData["isLogout"] = "false";
                            await signupBox.put(widget.email, userData);
                            // sessionStorageStoreBox.put(
                            //     widget.email, UserLoginState.logout.name);
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) {
                                return const AuthenticationPage();
                              },
                            ));
                            // Navigator.of(context)
                            //     .pushNamed(RecipeRouteName.authenticationPage);
                          },
                          icon: const Icon(
                            Icons.logout_outlined,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 20),
                      ],
                    ),
                    // Align(
                    //   alignment: Alignment(0.3, -1),
                    //   child: SelectedRecipeWidget(),
                    // ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 15),

                              //
                              Center(
                                child: Text(
                                  "Recipe Management Application",
                                  style: CustomTextStyle.getBoldTextStyle(
                                    textColor: AppColor.primaryColor,
                                    textSize: AppTextSize.large,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 30),

                              // Recipe Image Carousal
                              const RecipeCarouselWidget(),

                              const SizedBox(height: 40),

                              // recipe title
                              Center(
                                child: Container(
                                  width: mediaSize.width * 0.80,
                                  margin: const EdgeInsets.only(bottom: 16.0),
                                  decoration: const BoxDecoration(
                                      color: AppColor.primaryColor,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8))),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 12.0,
                                              top: 8.0,
                                              bottom: 8.0),
                                          child: Text(
                                            "Recipes",
                                            style: CustomTextStyle
                                                .getBoldTextStyle(
                                              textColor: Colors.white,
                                              textSize: AppTextSize.medium,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              Center(
                                child: Container(
                                  // alignment: Alignment.center,
                                  // color: Colors.teal,
                                  width: mediaSize.width * 0.80,
                                  height: 600,
                                  child: GridView.builder(
                                    scrollDirection: Axis.vertical,
                                    physics: const BouncingScrollPhysics(),
                                    // shrinkWrap: true,
                                    itemCount: ukFoodDishListFromHive.length,
                                    itemBuilder: (context, index) {
                                      // ukFoodDishList
                                      final foodItem =
                                          ukFoodDishListFromHive[index];
                                      return StatefulBuilder(
                                          builder: (context, setState1) {
                                        return ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(8)),
                                          child: AnimatedScale(
                                            duration: const Duration(
                                                milliseconds: 400),
                                            scale: isHover ? 1.1 : 0.9,
                                            child: InkWell(
                                              onTap: () {
                                                // show the recipe
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      contentPadding:
                                                          const EdgeInsets.all(
                                                              0),
                                                      insetPadding:
                                                          const EdgeInsets.all(
                                                              0),
                                                      titlePadding:
                                                          const EdgeInsetsDirectional
                                                              .all(0),
                                                      shape:
                                                          const RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .zero),
                                                      // title: getDesignedHeader(foodItem.name),
                                                      content: ShowRecipeWidget(
                                                          item: foodItem),
                                                    );
                                                  },
                                                );
                                              },
                                              // onHover: (value) {
                                              //   print("onhover");
                                              //   setState((){
                                              //     isHover = true;
                                              //   });
                                              // },

                                              child: MouseRegion(
                                                onEnter: (event) {
                                                  setState1(() {
                                                    isHover = true;
                                                  });
                                                },
                                                onExit: (event) {
                                                  setState1(() {
                                                    isHover = false;
                                                  });
                                                },
                                                child: Card(
                                                  elevation: isHover ? 12 : 0,
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(8)),
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(8)),
                                                    child: GridTile(
                                                      header: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        // mainAxisAlignment:
                                                        //     MainAxisAlignment.end,
                                                        children: [
                                                          IconButton(
                                                            onPressed:
                                                                () async {
                                                              // do editing of recipe
                                                              await editRecipe(
                                                                /**/
                                                                email: widget
                                                                    .email,
                                                                foodItem:
                                                                    foodItem,
                                                              );

                                                              //
                                                              ukFoodDishListFromHive
                                                                  .clear();
                                                              List<FoodDishModel>
                                                                  _tempList =
                                                                  [];
                                                              final Map
                                                                  userDataMap =
                                                                  foodRecipeStoreBox
                                                                      .get(widget
                                                                          .email); // get the map against this email

                                                              for (final key
                                                                  in userDataMap
                                                                      .keys) {
                                                                final boxItem =
                                                                    userDataMap[
                                                                        key]; // get the food item against specific key
                                                                final item =
                                                                    FoodDishModel
                                                                        .fromMap(
                                                                            boxItem);
                                                                _tempList
                                                                    .add(item);
                                                              }

                                                              ukFoodDishListFromHive
                                                                  .addAll(_tempList
                                                                      .reversed);

                                                              setState(() {});
                                                              print(
                                                                  "refreshing parent state");
                                                            },
                                                            icon: Container(
                                                              decoration:
                                                                  const BoxDecoration(
                                                                color: AppColor
                                                                    .primaryColor,
                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: const Icon(
                                                                Icons.edit,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                          IconButton(
                                                            onPressed:
                                                                () async {
                                                              // delete the specific item from hive

                                                              // foodRecipeStoreBox.delete(foodItem.id);

                                                              removeFromHiveList(
                                                                  foodItem.id);
                                                              await saveDataToHive();
                                                              setState(() {
                                                                print(
                                                                    "deleted the item: ${foodItem.id}");
                                                              });
                                                            },
                                                            icon: Container(
                                                              decoration:
                                                                  const BoxDecoration(
                                                                color: AppColor
                                                                    .primaryColor,
                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: const Icon(
                                                                Icons
                                                                    .delete_forever,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                          IconButton(
                                                            onPressed:
                                                                () async {
                                                              setState(() {
                                                                foodItem.isFavourite =
                                                                    !foodItem
                                                                        .isFavourite;
                                                                // ukFoodDishListFromHive[index].isFavourite =
                                                                //     !ukFoodDishListFromHive[index]
                                                                //         .isFavourite;
                                                              });
                                                              // changing the "isFavourite" state of hive
                                                              await setFoodAsFavourite();
                                                            },
                                                            icon: Container(
                                                              decoration:
                                                                  const BoxDecoration(
                                                                color: AppColor
                                                                    .primaryColor,
                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: foodItem
                                                                      .isFavourite
                                                                  ? const Icon(
                                                                      Icons
                                                                          .favorite,
                                                                      color: Colors
                                                                          .white,
                                                                    )
                                                                  : const Icon(
                                                                      Icons
                                                                          .favorite_border,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      footer: GridTileBar(
                                                        backgroundColor:
                                                            AppColor
                                                                .primaryColor
                                                                .withOpacity(
                                                                    0.6),
                                                        /*
                                                          leading: IconButton(
                                                            onPressed: () async {
                                                              setState(() {
                                                                foodItem.isFavourite =
                                                                    !foodItem.isFavourite;
                                                                // ukFoodDishListFromHive[index].isFavourite =
                                                                //     !ukFoodDishListFromHive[index]
                                                                //         .isFavourite;
                                                              });
                                                              // changing the "isFavourite" state of hive
                                                              await setFoodAsFavourite();
                                                              /*
                                                              await foodRecipeStoreBox.put(
                                                                foodItem.id,
                                                                foodItem.toMap(),
                                                              );

                                                              await foodRecipeStoreBox.put(
                                                                widget.email,
                                                                foodItem.toMap(),
                                                              );

                                                              {
                                                                widget.email: {
                                                              foodItem.id: foodItem.toMap(),
                                                              }
                                                              }

                                                              //   {
                                                              //     "email" :  {
                                                              //   "id" : "food recipe",
                                                              //   "id" : "food recipe",
                                                              //   }",
                                                              //   "email" :  {
                                                              //   "id" : "food recipe",
                                                              //   "id" : "food recipe",
                                                              //   }"
                                                              // }
                                                              */
                                                            },
                                                            icon: foodItem.isFavourite
                                                                ? const Icon(
                                                                    Icons.favorite,
                                                                    color: Colors.white,
                                                                  )
                                                                : const Icon(
                                                                    Icons.favorite_border,
                                                                    color: Colors.white,
                                                                  ),
                                                          ),
                                                          */
                                                        title: Text(
                                                          foodItem.name,
                                                          style: CustomTextStyle
                                                              .getBoldTextStyle(
                                                            textColor:
                                                                Colors.white,
                                                            textSize:
                                                                AppTextSize
                                                                    .extraSmall,
                                                          ),
                                                        ),
                                                        trailing: const Icon(
                                                          Icons
                                                              .arrow_forward_ios_outlined,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      child: foodItem
                                                                  .isImageFromHive ==
                                                              true
                                                          ? Image.memory(
                                                              foodItem
                                                                  .imageStoredInHive!,
                                                              fit: BoxFit.cover,
                                                            )
                                                          : Image.asset(
                                                              foodItem
                                                                  .imagePath,
                                                              fit: BoxFit.cover,
                                                            ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      });
                                    },
                                    // separatorBuilder: (context, index) {
                                    //   return const SizedBox(width: 80);
                                    // },
                                    gridDelegate:
                                        const SliverGridDelegateWithMaxCrossAxisExtent(
                                      crossAxisSpacing: 40,
                                      mainAxisSpacing: 40,
                                      maxCrossAxisExtent: 300, // width: 270
                                      mainAxisExtent: 260, // height: 260
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // search bar result
            Positioned(
              top: 56,
              right: 70,
              width: 320,
              height: 400,
              child: SelectedRecipeWidget(
                refreshParentState: (String itemId) async {
                  //
                  final Map userDataMap = foodRecipeStoreBox
                      .get(widget.email); // get the map against this email
                  ukFoodDishListFromHive.clear();
                  //
                  for (final key in userDataMap.keys) {
                    final boxItem = userDataMap[
                        key]; // get the food item against specific key
                    final item = FoodDishModel.fromMap(boxItem);
                    if (item.id == itemId) {
                      //
                      item.isFavourite = !item.isFavourite;
                    }
                    ukFoodDishListFromHive.add(item);

                    //
                    final Map<String, dynamic> _foodDataMap = {};
                    for (final item in ukFoodDishListFromHive) {
                      _foodDataMap[item.id] = item.toMap();
                    }

                    await foodRecipeStoreBox.put(widget.email, _foodDataMap);
                  }
                  setState(() {});
                  //
                },
              ),
            ),
            // footer
            Positioned(
              bottom: 0,
              height: 90,
              width: mediaSize.width * 1,
              child: const FooterWidget(),
            ),
            // add recipe button
            Positioned(
              bottom: 130,
              right: 14,
              // height: 110,
              // width: mediaSize.width * 1,
              child: RecipeAddButton(
                  email: widget.email,
                  refreshParentState: () {
                    //
                    final Map userDataMap = foodRecipeStoreBox
                        .get(widget.email); // get the map against this email
                    ukFoodDishListFromHive.clear();
                    for (final key in userDataMap.keys) {
                      final boxItem = userDataMap[
                          key]; // get the food item against specific key
                      final item = FoodDishModel.fromMap(boxItem);
                      ukFoodDishListFromHive.add(item);
                    }
                    setState(() {});
                    //
                  }),
            ),
          ],
        ),
      ),
      // floatingActionButton: RecipeAddButton(
      //     email: widget.email,
      //     refreshParentState: () {
      //       //
      //       final Map userDataMap = foodRecipeStoreBox
      //           .get(widget.email); // get the map against this email
      //       ukFoodDishListFromHive.clear();
      //       for (final key in userDataMap.keys) {
      //         final boxItem =
      //             userDataMap[key]; // get the food item against specific key
      //         final item = FoodDishModel.fromMap(boxItem);
      //         ukFoodDishListFromHive.add(item);
      //       }
      //       setState(() {});
      //       //
      //     }),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }

  Future<void> showRecipe({required FoodDishModel foodItem}) async {
    //
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(0),
          insetPadding: const EdgeInsets.all(0),
          titlePadding: const EdgeInsetsDirectional.all(0),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          // title: getDesignedHeader(foodItem.name),
          content: ShowRecipeWidget(item: foodItem),
        );
      },
    );
  }

  String convertListIntoString(List<String> data) {
    String totalString = "";
    for (final str in data) {
      totalString += str;
    }
    return totalString;
  }

  Future<void> editRecipe({
    required String email,
    required FoodDishModel foodItem,
  }) async {
    print("image stored: ${foodItem.imagePath}");
    print("isImageFromHive: ${foodItem.isImageFromHive}");
    //
    String recipeName = foodItem.name;
    String description = foodItem.description;
    String ingredientsList = convertListIntoString(foodItem.ingredientsList);
    String instructionsList = convertListIntoString(foodItem.instructionsList);
    String tipsAndTricksList =
        convertListIntoString(foodItem.tipsAndTricksList);
    String allergiesList = convertListIntoString(foodItem.allergiesList);
    Uint8List? imageUint8List =
        foodItem.isImageFromHive ? foodItem.imageStoredInHive : null;
    bool isImageFromHive = foodItem.isImageFromHive;
    bool isFavourite = foodItem.isFavourite;
    String imagePathStored = foodItem.isImageFromHive ? "" : foodItem.imagePath;

    //
    const double heightBetweenField = 20;
    const double heightLabelAndField = 5;
    final Size mediaSize = MediaQuery.sizeOf(context);
    final GlobalKey<FormState> editFormKey = GlobalKey<FormState>();

    //

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(30),
          insetPadding: const EdgeInsets.all(0),
          titlePadding: const EdgeInsetsDirectional.all(0),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          title: getDesignedHeader("Edit Recipe", isCenter: false),
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
                            padding: const EdgeInsets.all(2.0),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
                            child: isImageFromHive
                                ? Image.memory(
                                    imageUint8List!,
                                    fit: BoxFit.cover,
                                    height: 180,
                                    width: 180,
                                  )
                                : Image.asset(
                                    imagePathStored.toString(),
                                    fit: BoxFit.cover,
                                    height: 180,
                                    width: 180,
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
                                  imageUint8List = imageRawBinaryList;
                                  setState(() {
                                    print(
                                        "after adding image refreshing image container");
                                  });
                                }
                              },
                              child: Text(
                                "Edit Image",
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

                  const SizedBox(height: heightBetweenField),
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
                          controller: TextEditingController(text: recipeName),
                          hintText: "Enter recipe name",
                          labelText: "Name",
                          isEnd: false,
                          isNumKeyboardType: false,
                          validate: (name) {
                            return AuthenticationValidator.nameValidator(name);
                          },
                          save: (name) {
                            recipeName = name!;
                          },
                        ),
                        const SizedBox(height: heightBetweenField),

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
                          controller: TextEditingController(text: description),
                          hintText: "Enter description",
                          labelText: "Description",
                          isEnd: false,
                          maxlines: 2,
                          isNumKeyboardType: false,
                          validate: (name) {
                            return AuthenticationValidator.nameValidator(name);
                          },
                          save: (name) {
                            description = name!;
                          },
                        ),
                        const SizedBox(height: heightBetweenField),
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
                            return AuthenticationValidator.nameValidator(name);
                          },
                          save: (name) {
                            ingredientsList = name!;
                          },
                        ),
                        const SizedBox(height: heightBetweenField),
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
                            return AuthenticationValidator.nameValidator(name);
                          },
                          save: (name) {
                            instructionsList = name!;
                          },
                        ),
                        const SizedBox(height: heightBetweenField),
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
                          controller:
                              TextEditingController(text: tipsAndTricksList),
                          hintText: "Enter tips and Tricks",
                          labelText: "Tips And Tricks",
                          isEnd: false,
                          maxlines: 2,
                          isNumKeyboardType: false,
                          validate: (name) {
                            return AuthenticationValidator.nameValidator(name);
                          },
                          save: (name) {
                            tipsAndTricksList = name!;
                          },
                        ),
                        const SizedBox(height: heightBetweenField),
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
                            return AuthenticationValidator.nameValidator(name);
                          },
                          save: (name) {
                            allergiesList = name!;
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: heightBetweenField),
                  const SizedBox(height: heightBetweenField),
                  Center(
                    child: RoundedButtonStyle(
                      text: "Update recipe",
                      onTap: () async {
                        // add the recipe in hive
                        if (editFormKey.currentState!.validate()) {
                          //
                          editFormKey.currentState!.save();

                          EasyLoading.show(
                            status: "Updating recipe",
                            dismissOnTap: false,
                          );
                          /*
                          *
                          * */

                          final Map userDataMap =
                              Hive.box(HiveBoxName.foodRecipeStoreBox)
                                  .get(email);

                          List<FoodDishModel> _allRecipeData = [];

                          for (final key in userDataMap.keys) {
                            final boxItem = userDataMap[
                                key]; // get the food item against specific key
                            final item = FoodDishModel.fromMap(boxItem);
                            _allRecipeData.add(item);
                          }

                          // updating the current data into hive and save it
                          final updateItem = FoodDishModel(
                            id: foodItem.id,
                            name: recipeName,
                            description: description,
                            ingredientsList:
                                convertStringIntoList(ingredientsList),
                            instructionsList:
                                convertStringIntoList(instructionsList),
                            isFavourite: isFavourite,
                            allergiesList: convertStringIntoList(allergiesList),
                            tipsAndTricksList:
                                convertStringIntoList(tipsAndTricksList),
                            isImageFromHive: foodItem.isImageFromHive,
                            // imageUint8List == null ? false : true,  // image has changed
                            imageStoredInHive:
                                (foodItem.isImageFromHive == true &&
                                        imageUint8List != null)
                                    ? imageUint8List
                                    : foodItem.imageStoredInHive,
                            imagePath: foodItem.isImageFromHive == false
                                ? foodItem.imagePath
                                : "",
                          );

                          final Map<String, dynamic> _foodDataMap = {};

                          for (final FoodDishModel item in _allRecipeData) {
                            // store all item except the one changed
                            if (item.id != updateItem.id) {
                              _foodDataMap[item.id] = item.toMap();
                            }
                          }

                          // newly change append in the end
                          _foodDataMap[updateItem.id] = updateItem.toMap();

                          // saved the changes into database
                          await Hive.box(HiveBoxName.foodRecipeStoreBox)
                              .put(email, _foodDataMap);

                          // read those changes from the database

                          /*
                          *
                          * */
                          EasyLoading.showSuccess(
                            "Recipe has Updated",
                            duration: const Duration(seconds: 1),
                            dismissOnTap: false,
                          );
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
  }

  Future<Uint8List?> captureImagesFromGallery() async {
    try {
      final XFile? image =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image != null) {
        Uint8List imageData = await image.readAsBytes();
        return imageData;
      } else {
        print("No image has found");
        return null;
      }
    } catch (e) {
      print("while taking image from gallery: error: $e");
    }
  }

  List<String> convertStringIntoList(String data) {
    return data.split(".");
  }
}

class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});

  void _launchURL(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url, webOnlyWindowName: "_blank");
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size mediaSize = MediaQuery.sizeOf(context);
    return Container(
      color: AppColor.primaryColor, // .withOpacity(0.7),
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
      child: Stack(
        // crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // const SizedBox(height: 25),

          // const Spacer(),
          Align(
            alignment: Alignment(0.0, -0.2),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Copyright 2024. All Rights Reserved",
                  style: CustomTextStyle.getBoldTextStyle(
                    textColor: Colors.white,
                    textSize: AppTextSize.extraSmall,
                  ),
                ),
                Text(
                  "Developed by Abu Sayeed Tanim",
                  style: CustomTextStyle.getBoldTextStyle(
                    textColor: Colors.white,
                    textSize: AppTextSize.extraSmall,
                  ),
                ),
              ],
            ),
          ),
          // const SizedBox(height: 10),
          Align(
            alignment: Alignment.bottomRight,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    "Follow Us",
                    style: CustomTextStyle.getBoldTextStyle(
                      textColor: Colors.white,
                      textSize: AppTextSize.extraSmall,
                    ),
                  ),
                ),
                const SizedBox(height: 1),
                // all icon buttons
                SizedBox(
                  width: 190,
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          //
                          _launchURL(Uri.parse(
                              "https://www.facebook.com/groups/234936450332030/"));
                        },
                        icon: const Icon(
                          Icons.facebook,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        onPressed: () {
                          //
                          _launchURL(
                              Uri.parse("https://twitter.com/therecipegroup"));
                        },
                        icon: const FaIcon(
                          FontAwesomeIcons.xTwitter,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        onPressed: () {
                          //
                          _launchURL(Uri.parse(
                              "https://www.instagram.com/culinaryginger/?hl=en"));
                        },
                        icon: const FaIcon(
                          FontAwesomeIcons.instagram,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        onPressed: () {
                          //
                          _launchURL(Uri.parse(
                              "https://www.linkedin.com/company/recipe"));
                        },
                        icon: const FaIcon(
                          FontAwesomeIcons.linkedin,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --------------------------------------------------------------------
class SearchFilter extends StatefulWidget {
  final String email;

  const SearchFilter({
    super.key,
    required this.email,
  });

  @override
  State<SearchFilter> createState() => _SearchFilterState();
}

class _SearchFilterState extends State<SearchFilter> {
  late TextEditingController _searchController;
  Timer? _debounceTime;
  String oldSearchedValue = "";

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(onSearchChanged);
  }

  void onSearchChanged() {
    if (_debounceTime != null && _debounceTime!.isActive) {
      _debounceTime!.cancel();
    }
    _debounceTime = Timer(const Duration(milliseconds: 500), () {
      if (_searchController.text.trim().isEmpty) {
        oldSearchedValue = "";
        Provider.of<SearchBarProvider>(context, listen: false).emptySearch();
      }
      if (_searchController.text.trim().isNotEmpty &&
          oldSearchedValue != _searchController.text.trim()) {
        oldSearchedValue = _searchController.text.trim();
        Provider.of<SearchBarProvider>(context, listen: false)
            .searchByIngredient(
          ingredientName: oldSearchedValue,
          email: widget.email,
        );
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchController.removeListener(onSearchChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 250,
          height: 35,
          child: TextField(
            controller: _searchController,
            style: const TextStyle(fontSize: 17),
            textInputAction: TextInputAction.search,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.search,
                size: 24,
                color: Colors.black,
              ),
              contentPadding: const EdgeInsetsDirectional.symmetric(
                vertical: 4,
                horizontal: 16,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: const BorderSide(color: AppColor.primaryColor),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                // borderSide: BorderSide.none,
              ),
              hintText: "Search Recipe",
              isDense: true,
              fillColor: Colors.white,
              filled: true,
            ),
            // onChanged: (String? medicineName) {
            //   //
            //   // Provider.of<MedicineListProvider>(context, listen: false)
            //   //     .getMedicineList(
            //   //   _searchController.text,
            //   // );
            // },
          ),
        ),
      ],
    );
  }
}

class SelectedRecipeWidget extends StatefulWidget {
  final void Function(String id) refreshParentState;

  const SelectedRecipeWidget({
    super.key,
    required this.refreshParentState,
  });

  @override
  State<SelectedRecipeWidget> createState() => _SelectedRecipeWidgetState();
}

class _SelectedRecipeWidgetState extends State<SelectedRecipeWidget> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<SearchBarProvider>(context, listen: false).dialogVisibility(dialogClose: true);
  }

  @override
  Widget build(BuildContext context) {
    const double windowHeight = 500;
    return Consumer<SearchBarProvider>(
      builder: (context, SearchBarProvider value, child) {
        // if(value.isProcessEnd == true &&
        //     value.selectedRecipes.isEmpty &&
        //     value.isCloseDialog == true){
        //   return const SizedBox();
        // }

        // process start
        if (value.isSearchingStart == true) {
          // is in searching
          return const SizedBox(
            height: windowHeight,
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(
                  AppColor.primaryColor,
                ),
              ),
            ),
          );
        }

        // process end -- no data found
        if (value.isProcessEnd == true &&
            value.selectedRecipes.isEmpty &&
            value.isCloseDialog == false) {
          return MouseRegion(
            onExit: (event) {
              value.dialogVisibility(dialogClose: true);
            },
            child: Container(
              color: Colors.white,
              // width: 400,
              // height: 300,
              child: Center(
                child: Text(
                  "No items found",
                  style: CustomTextStyle.getBoldTextStyle(
                    textColor: Colors.black,
                    textSize: AppTextSize.large,
                  ),
                ),
              ),
            ),
          );
        }

        if (value.isCloseDialog == true) {
          return const SizedBox();
        }

        // if (value.medicineData == null) {
        //   return const SizedBox();
        // }

        // process end -- data found <select medicine add it to selected medicine model>
        // final dataSize = value.selectedRecipes.length;
        final recipeData = value.selectedRecipes;
        return Container(
          color: Colors.white,

          height: windowHeight,
          // width: 90.sw,
          // padding: EdgeInsetsDirectional.symmetric(horizontal: 2.w),
          // color: Colors.blue,
          child: MouseRegion(
            onExit: (event) {
              print("tap outside");
              value.dialogVisibility(dialogClose: true);
            },
            child: ListView.separated(
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              itemCount: value.selectedRecipes.length,
              itemBuilder: (context, index) {
                // ukFoodDishList
                final singleRecipeItem = recipeData[index];
                return Container(
                  color: Colors.white,
                  width: 320,
                  height: 110,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 100,
                        height: 110,
                        child: singleRecipeItem.isImageFromHive == true
                            ? Image.memory(
                                singleRecipeItem.imageStoredInHive!,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                singleRecipeItem.imagePath,
                                fit: BoxFit.cover,
                              ),
                      ),
                      const SizedBox(width: 10),
                      // Name
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Text(
                                singleRecipeItem.name,
                                style: CustomTextStyle.getBoldTextStyle(
                                  textColor: Colors.black,
                                  textSize: AppTextSize.extraSmall,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            SingleChildScrollView(
                              child: Text(
                                singleRecipeItem.description,
                                style: CustomTextStyle.getBoldTextStyle(
                                  textColor: Colors.black,
                                  textSize: AppTextSize.extraExtraSmall,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),

                      IconButton(
                        onPressed: () async {
                          setState(() {
                            singleRecipeItem.isFavourite =
                                !singleRecipeItem.isFavourite;
                          });
                          // changing the "isFavourite" state of hive
                          widget.refreshParentState(singleRecipeItem.id);
                        },
                        icon: singleRecipeItem.isFavourite
                            ? const Icon(
                                // fill: 1.0,
                                Icons.favorite_rounded,
                                color: AppColor.primaryColor,
                              )
                            : const Icon(
                                Icons.favorite_border,
                                color: AppColor.primaryColor,
                              ),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                );

                /*
                *
                * return InkWell(
                  onTap: () async {
                    print("item id: ${singleRecipeItem.id} has selected");

                    // show the recipe
                    await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          contentPadding: const EdgeInsets.all(0),
                          insetPadding: const EdgeInsets.all(0),
                          titlePadding: const EdgeInsetsDirectional.all(0),
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero),
                          // title: getDesignedHeader(foodItem.name),
                          content: ShowRecipeWidget(item: singleRecipeItem),
                        );
                      },
                    );
                  },
                  child: Container(
                    color: Colors.white,
                    width: 320,
                    height: 110,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 100,
                          height: 110,
                          child: singleRecipeItem.isImageFromHive == true
                              ? Image.memory(
                                  singleRecipeItem.imageStoredInHive!,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  singleRecipeItem.imagePath,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        const SizedBox(width: 10),
                        // Name
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Text(
                                  singleRecipeItem.name,
                                  style: CustomTextStyle.getBoldTextStyle(
                                    textColor: Colors.black,
                                    textSize: AppTextSize.extraSmall,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              SingleChildScrollView(
                                child: Text(
                                  singleRecipeItem.description,
                                  style: CustomTextStyle.getBoldTextStyle(
                                    textColor: Colors.black,
                                    textSize: AppTextSize.extraExtraSmall,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),

                        IconButton(
                          onPressed: () async {
                            setState(() {
                              singleRecipeItem.isFavourite =
                                  !singleRecipeItem.isFavourite;
                            });
                            // changing the "isFavourite" state of hive
                            widget.refreshParentState(singleRecipeItem.id);
                          },
                          icon: singleRecipeItem.isFavourite
                              ? const Icon(
                                  // fill: 1.0,
                                  Icons.favorite_rounded,
                                  color: AppColor.primaryColor,
                                )
                              : const Icon(
                                  Icons.favorite_border,
                                  color: AppColor.primaryColor,
                                ),
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                  ),
                  /*
                  child: GridTile(
                    footer: GridTileBar(
                      backgroundColor: AppColor.primaryColor.withOpacity(0.6),
                      title: Text(
                        singleRecipeItem.name,
                        style: CustomTextStyle.getBoldTextStyle(
                          textColor: Colors.white,
                          textSize: AppTextSize.extraSmall,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: Colors.white,
                      ),
                    ),
                    child: Image.asset(
                      singleRecipeItem.imagePath,
                      fit: BoxFit.cover,
                    ),
                  ),
                  */
                );
                * */
              },
              separatorBuilder: (context, index) {
                return const Divider(
                  color: AppColor.primaryColor,
                  height: 20,
                  thickness: 0.5,
                );
                // return const SizedBox(height: 40);
              },
              /*
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                mainAxisExtent: 240,
                mainAxisSpacing: 40,
              ),
              */
              // const SliverGridDelegateWithMaxCrossAxisExtent(
              //   crossAxisSpacing: 40,
              //   mainAxisSpacing: 40,
              //   maxCrossAxisExtent: 320, // height: 270
              //   mainAxisExtent: 280, // width: 260
              // ),
            ),
          ),
        );
      },
    );
  }
}

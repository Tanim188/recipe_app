import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../../core/local_db/box_names.dart';
import '../models/food_dish_model.dart';

class SearchBarProvider extends ChangeNotifier {
  List<FoodDishModel>? recipeData;
  List<FoodDishModel> selectedRecipes = [];
  bool isCloseDialog = false;
  bool isSearchingStart = false;
  bool isProcessEnd = false;

  void emptySearch() {
    // recipeData = null;
    selectedRecipes = [];
    isCloseDialog = false;
    isProcessEnd = false;
    notifyListeners();
  }

  Future<void> searchByIngredient(
      {required String ingredientName, required String email}) async {
    try {
      // recipeData = null;
      selectedRecipes.clear();
      isCloseDialog = false;
      isSearchingStart = true; // searching has started

      notifyListeners();
      // search the recipe list by ingredient
      final allRecipesMap = Hive.box(HiveBoxName.foodRecipeStoreBox).get(email);
      for (final key in allRecipesMap.keys) {
        //
        final singleRecipeItem =
            allRecipesMap[key]; // get the food item against specific key

        //
        final recipeModel = FoodDishModel.fromMap(singleRecipeItem);

        for (final ingredient in recipeModel.ingredientsList) {
          if (ingredient.contains(ingredientName)) {
            selectedRecipes.add(recipeModel);
            break;
          }
        }
      }
      isSearchingStart = false; // searching has stopped
      isProcessEnd = true;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  void dialogVisibility({required bool dialogClose}) {
    isCloseDialog = dialogClose;
    notifyListeners();
  }
}

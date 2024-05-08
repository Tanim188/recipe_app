import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:receipe_app/app/authentication/model/signup_model.dart';
import 'package:receipe_app/app/recipe_app/models/food_dish_model.dart';
import 'package:receipe_app/core/asset_mapper/recipe_card_images_mapper.dart';
import 'package:receipe_app/core/utility/validator.dart';

void main() {
  late SignupModel signUp;
  late Box recipeStoreBox;
  late FoodDishModel foodRecipe1;
  late Box signUpBox;

  setUpAll(() async {
    Hive.init("/test");
    signUpBox = await Hive.openBox("sign_up_box");
    recipeStoreBox = await Hive.openBox("recipe_Store_box");
    foodRecipe1 = FoodDishModel(
      id: "1",
      name: "Fish and Chips",
      ingredientsList: [
        "White fish fillets (such as cod or haddock)",
        "potatoes",
        "flour",
        "baking powder",
        "beer",
        "salt",
        "vegetable oil",
      ],
      description:
          "A quintessential British dish consisting of battered and deep-fried fish served with crispy chips (fries).",
      instructionsList: [
        "Peel and cut the potatoes into thick strips for chips.",
        "Prepare the batter by mixing flour, baking powder, salt, and beer until smooth.",
        "Dip the fish fillets in the batter and fry until golden brown.",
        "Fry the chips until crispy.",
      ],
      tipsAndTricksList: [
        "Ensure the oil is hot enough before frying to prevent the batter from becoming soggy.",
        "Pat the fish fillets dry before dipping them in batter to help the batter adhere better.",
      ],
      allergiesList: [
        "Wheat flour (gluten)",
        "Fish (allergic reactions)",
      ],
      imagePath: RecipeCardImages.fishAndChips,
      isFavourite: false,
      isImageFromHive: false,
      imageStoredInHive: null,
    );
  });

  setUp(() async {
    signUp = SignupModel(
      name: "test",
      email: "test@gmail.com",
      password: "Test@Test12",
      isLogout: true,
    );
    await recipeStoreBox.clear();
  });

  group('Signup functionality', () {
    test('User account is created', () async {
      await signUpBox.clear();
      await signUpBox.put(signUp.email, signUp.toHiveFormat());
      expect(signUpBox.containsKey(signUp.email), true);
    });

    test('Registered user login successfully', () async {
      expect(signUpBox.containsKey(signUp.email), true);
    });

    test('un-Registered User cant login successfully', () async {
      expect(signUpBox.containsKey("different@gmail.com"), false);
    });

    test('Changing password functionality execute successfully', () async {
      await signUpBox.put(signUp.email, signUp.toHiveFormat());
      String oldPassword = signUp.password; // "Test@Test12"
      String newPassword = "aB@12qsRt";
      await signUpBox.put(
          signUp.email, signUp.copyWith(password: newPassword).toHiveFormat());
      Map userCredentials = signUpBox.get(signUp.email);
      expect(userCredentials['password'], newPassword);
    });

    test('Changing username functionality execute successfully', () async {
      await signUpBox.put(signUp.email, signUp.toHiveFormat());
      String oldName = signUp.name; // "test"
      String newName = "testName";
      await signUpBox.put(
          signUp.email, signUp.copyWith(name: newName).toHiveFormat());
      Map userCredentials = signUpBox.get(signUp.email);
      expect(userCredentials['name'], newName);
    });

    test('User is logout successfully', () async {
      signUp.copyWith(isLogout: true);
      signUpBox.put(signUp.email, signUp.toHiveFormat());
      expect(signUpBox.get(signUp.email)["isLogout"], 'true');
    });
  });

  group('Email Verification functionality', () {
    test('Valid email matched', () async {
      expect(AuthenticationValidator.isValidEmail(signUp.email), true);
    });

    test('empty email does not matched', () async {
      expect(AuthenticationValidator.isValidEmail(''), false);
    });

    test('unformatted email does not matched', () async {
      expect(AuthenticationValidator.isValidEmail('abc.com'), false);
    });
  });

  group('Password Verification functionality', () {
    test('Valid password matched', () async {
      expect(AuthenticationValidator.isValidPassword('Abc@abc123'), true);
    });

    test('Empty password does not matched', () async {
      expect(AuthenticationValidator.isValidPassword(''), false);
    });

    test('only Lowercase alphabets password failed to match the criteria',
        () async {
      expect(AuthenticationValidator.isValidPassword('aaaaaaaaaaa'), false);
    });

    test('only numeric digits password failed to match the criteria', () async {
      expect(AuthenticationValidator.isValidPassword('1121212121'), false);
    });

    test(
        'Lowercase alphabets and numeric digits password failed to match the criteria',
        () async {
      expect(AuthenticationValidator.isValidPassword('abc1212'), false);
    });
  });

  group("Functional Requirements", () {
    test("Initially there is no recipe", () {
      expect(recipeStoreBox.containsKey(signUp.email), false);
    });

    test("When adding first recipe, its store successfully", () async {
      await recipeStoreBox.put(signUp.email, foodRecipe1.toMap());
      expect(recipeStoreBox.length == 1, true);
    });

    test("After updating the box, its value modified successfully", () async {
      await recipeStoreBox.put(signUp.email, foodRecipe1.toMap());
      final Map data = recipeStoreBox.get(signUp.email);
      data['name'] = "Fish Recipe";
      await recipeStoreBox.put(
          signUp.email, FoodDishModel.fromMap(data).toMap());
      expect(recipeStoreBox.length == 1, true);
    });

    test("Adding food recipe to favourite list", () async {
      await recipeStoreBox.put(
          signUp.email, foodRecipe1.copyWith(isFavourite: false).toMap());
      final Map oldFoodRecipeData = recipeStoreBox.get(signUp.email);
      expect(oldFoodRecipeData['isFavourite'], false);
      await recipeStoreBox.put(
          signUp.email, foodRecipe1.copyWith(isFavourite: true).toMap());
      final Map newFoodRecipeData = recipeStoreBox.get(signUp.email);
      expect(newFoodRecipeData['isFavourite'], true);
    });

    test("Removing food recipe from favourite list", () async {
      await recipeStoreBox.put(
          signUp.email, foodRecipe1.copyWith(isFavourite: true).toMap());
      final Map oldFoodRecipeData = recipeStoreBox.get(signUp.email);
      expect(oldFoodRecipeData['isFavourite'], true);
      await recipeStoreBox.put(
          signUp.email, foodRecipe1.copyWith(isFavourite: false).toMap());
      final Map newFoodRecipeData = recipeStoreBox.get(signUp.email);
      expect(newFoodRecipeData['isFavourite'], false);
    });

    test("Deleting the food recipe make storage length back to 0", () async {
      await recipeStoreBox.delete(signUp.email);
      expect(recipeStoreBox.length == 0, true);
    });
  });
}

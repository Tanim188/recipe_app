import 'dart:typed_data';

import '../../../core/asset_mapper/recipe_card_images_mapper.dart';

class FoodDishModel {
  FoodDishModel({
    required this.id,
    required this.name,
    required this.ingredientsList,
    required this.description,
    required this.instructionsList,
    required this.tipsAndTricksList,
    required this.allergiesList,
    required this.imagePath,
    required this.isFavourite,
    required this.isImageFromHive,
    required this.imageStoredInHive,
  });

  String id;
  String name;
  List<String> ingredientsList;
  String description;
  List<String> instructionsList;
  List<String> tipsAndTricksList;
  List<String> allergiesList;
  String imagePath;
  bool isFavourite;
  bool isImageFromHive;
  Uint8List? imageStoredInHive;

  // get all favourite dishes
  static List<FoodDishModel> getAllFavouriteFoodDishes(
      List<FoodDishModel> foodList) {
    return foodList
        .where((FoodDishModel foodItem) => foodItem.isFavourite == true)
        .toList();
  }

  factory FoodDishModel.fromMap(Map<dynamic, dynamic> json) {
    return FoodDishModel(
        id: json["id"],
        name: json["name"],
        ingredientsList: json["ingredientsList"],
        description: json["description"],
        instructionsList: json["instructionsList"],
        tipsAndTricksList: json["tipsAndTricksList"],
        allergiesList: json["allergiesList"],
        imagePath: json["imagePath"],
        isFavourite: json["isFavourite"],
        isImageFromHive: json["isImageFromHive"],
        imageStoredInHive: json["imageStoredInHive"]);
  }

  FoodDishModel copyWith({
    String? id,
    String? name,
    List<String>? ingredientsList,
    String? description,
    List<String>? instructionsList,
    List<String>? tipsAndTricksList,
    List<String>? allergiesList,
    String? imagePath,
    bool? isFavourite,
    bool? isImageFromHive,
    Uint8List? imageStoredInHive,
  }) {
    return FoodDishModel(
      id: id ?? this.id,
      name: name ?? this.name,
      ingredientsList: ingredientsList ?? this.ingredientsList,
      description: description ?? this.description,
      instructionsList: instructionsList ?? this.instructionsList,
      tipsAndTricksList: tipsAndTricksList ?? this.tipsAndTricksList,
      allergiesList: allergiesList ?? this.allergiesList,
      imagePath: imagePath ?? this.imagePath,
      isFavourite: isFavourite ?? this.isFavourite,
      isImageFromHive: isImageFromHive ?? this.isImageFromHive,
      imageStoredInHive: imageStoredInHive ?? this.imageStoredInHive,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "ingredientsList": ingredientsList,
      "description": description,
      "instructionsList": instructionsList,
      "tipsAndTricksList": tipsAndTricksList,
      "allergiesList": allergiesList,
      "imagePath": imagePath,
      "isFavourite": isFavourite,
      "isImageFromHive": isImageFromHive,
      "imageStoredInHive": imageStoredInHive
    };
  }
}

// each a new user is created will have this list of food item
final List<FoodDishModel> ukFoodDishList = [
  FoodDishModel(
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
  ),
  FoodDishModel(
    id: "2",
    name: "Shepherd's Pie",
    ingredientsList: [
      "Ground lamb",
      "onions",
      "carrots",
      "peas",
      "beef broth",
      "Worcestershire sauce",
      "potatoes",
      "butter",
      "milk",
    ],
    description:
        "A hearty dish made with minced meat (usually lamb), topped with mashed potatoes and baked until golden brown.",
    instructionsList: [
      "Brown the minced lamb with onions until cooked through.",
      "Add carrots, peas, beef broth, and Worcestershire sauce, and simmer until vegetables are tender.",
      "Mash the potatoes with butter and milk.",
      "Spread the meat mixture in a baking dish, top with mashed potatoes, and bake until golden.",
    ],
    tipsAndTricksList: [
      "Season the meat mixture generously with salt, pepper, and herbs for added flavor.",
      "Make extra mashed potatoes to ensure a generous topping.",
    ],
    allergiesList: [
      "Dairy (milk, butter)",
      "Gluten (Worcestershire sauce)",
    ],
    imagePath: RecipeCardImages.shepherdPie,
    isFavourite: false,
    isImageFromHive: false,
    imageStoredInHive: null,
  ),
  FoodDishModel(
    id: "3",
    name: "Bangers and Mash",
    ingredientsList: [
      "Pork sausages",
      "potatoes",
      "butter",
      "milk",
      "onion",
      "beef stock",
      "flour",
      "Worcestershire sauce",
    ],
    description:
        "A comforting dish featuring sausages served with mashed potatoes and gravy.",
    instructionsList: [
      "Grill or fry the sausages until cooked through.",
      "Boil and mash the potatoes with butter and milk.",
      "Prepare onion gravy by sautéing onions, adding flour, then beef stock and Worcestershire sauce.",
      "Serve sausages with mashed potatoes and gravy.",
    ],
    tipsAndTricksList: [
      " Use Greek yogurt for a thicker marinade.",
      "Adjust the level of spice to taste by adding more or less garam masala and chili powder.",
    ],
    allergiesList: [
      "Dairy (yogurt, cream, butter)",
      "Gluten (some brands of garam masala may contain wheat)",
    ],
    imagePath: RecipeCardImages.bangersAndMash,
    isFavourite: false,
    isImageFromHive: false,
    imageStoredInHive: null,
  ),
  FoodDishModel(
    id: "4",
    name: "Beef Wellington",
    ingredientsList: [
      "Beef fillet",
      "mushrooms",
      "shallots",
      "garlic",
      "puff pastry",
      "pâté (often made with liver)",
      "egg wash",
    ],
    description:
        "A luxurious dish consisting of beef fillet coated with pâté and wrapped in puff pastry.",
    instructionsList: [
      "Sear the beef fillet until browned on all sides.",
      "Sauté mushrooms, shallots, and garlic until softened.",
      "Spread pâté over the beef, then cover with the mushroom mixture.",
      "Wrap in puff pastry, brush with egg wash, and bake until golden.",
    ],
    tipsAndTricksList: [
      "Use high-quality sausages and bacon for the best flavor.",
      "Keep the cooked components warm while preparing the rest of the breakfast.",
    ],
    allergiesList: [
      "Pork (bacon, sausages, black pudding)",
      "Eggs",
      "Gluten (toast)",
    ],
    imagePath: RecipeCardImages.beefWellington,
    isFavourite: false,
    isImageFromHive: false,
    imageStoredInHive: null,
  ),
  FoodDishModel(
    id: "5",
    name: "Toad in the Hole",
    ingredientsList: [
      "Pork sausages",
      "flour",
      "eggs",
      "milk",
      "salt",
      "vegetable oil",
      "beef stock",
      "onion",
      "flour",
    ],
    description:
        "Sausages baked in Yorkshire pudding batter, served with gravy and vegetables.",
    instructionsList: [
      "Preheat the oven and grease a baking dish.",
      "Brown the sausages in a pan.",
      "Prepare Yorkshire pudding batter by whisking flour, eggs, milk, and salt.",
      "Pour the batter into the baking dish, add sausages, and bake until golden and puffed.",
    ],
    tipsAndTricksList: [
      "Choose high-quality sausages with a high meat content for better flavor.",
      "Add a splash of cream to the mashed potatoes for extra richness.",
    ],
    allergiesList: [
      "Dairy (butter, milk)",
      "Gluten (flour, Worcestershire sauce)",
    ],
    imagePath: RecipeCardImages.toadInTheHole,
    isFavourite: false,
    isImageFromHive: false,
    imageStoredInHive: null,
  ),
  FoodDishModel(
    id: "6",
    name: "Ploughman's Lunch",
    ingredientsList: [
      "Cheddar cheese",
      "bread",
      "pickles (such as Branston pickle or pickled onions)",
      "butter",
      "cold meats (optional)",
      "salad (optional)",
    ],
    description:
        "A traditional British cold meal consisting of cheese, bread, pickles, and sometimes cold meats and salad.",
    instructionsList: [
      "Assemble the ingredients on a plate or platter.",
    ],
    tipsAndTricksList: [
      "Use a mix of lean and fatty cuts of beef for a well-balanced filling.",
      "Blind bake the shortcrust pastry to prevent it from becoming soggy.",
    ],
    allergiesList: [
      "Gluten (flour, pastry)",
      "Egg (egg wash)",
    ],
    imagePath: RecipeCardImages.ploughmanLunch,
    isFavourite: false,
    isImageFromHive: false,
    imageStoredInHive: null,
  ),
  FoodDishModel(
    id: "7",
    name: "Cornish Pasty",
    ingredientsList: [
      "Beef or lamb",
      "potatoes",
      "onion",
      "carrot",
      "pastry dough (flour, butter, water)",
      "salt",
      "pepper",
    ],
    description:
        "A savory pastry filled with meat, potatoes, and vegetables, originating from Cornwall.",
    instructionsList: [
      "Prepare the pastry dough and let it chill.",
      "Dice the meat and vegetables and season with salt and pepper.",
      "Roll out the pastry dough and cut into circles.",
      "Fill each circle with the meat and vegetable mixture, fold, and crimp the edges.",
      "Bake until golden brown.",
    ],
    tipsAndTricksList: [
      "Use high-quality sausages with plenty of flavor.",
      "Make sure the baking dish and oil are hot before adding the batter to ensure a good rise.",
    ],
    allergiesList: [
      "Gluten (flour)",
      "Dairy (milk, eggs)",
    ],
    imagePath: RecipeCardImages.cornishPasty,
    isFavourite: false,
    isImageFromHive: false,
    imageStoredInHive: null,
  ),
  FoodDishModel(
    id: "8",
    name: "Chicken Tikka Masala",
    ingredientsList: [
      "Chicken breast",
      "yogurt",
      "lemon juice",
      "ginger",
      "garlic",
      "spices (such as cumin, coriander, paprika)",
      "tomatoes",
      "cream",
      "butter",
      "rice or naan bread",
    ],
    description:
        "While not traditionally British, it's a beloved dish in the UK, featuring marinated chicken cooked in a creamy tomato sauce.",
    instructionsList: [
      "Marinate chicken in yogurt, lemon juice, ginger, garlic, and spices.",
      "Grill or pan-fry the chicken until cooked through.",
      "Prepare the tomato sauce by simmering tomatoes, cream, and butter with spices.",
      "Add cooked chicken to the sauce and simmer until heated through.",
    ],
    tipsAndTricksList: [
      "Chill the pastry before rolling it out to prevent it from becoming too soft.",
      "Make a small slit in the top of each pasty to allow steam to escape during baking.",
    ],
    allergiesList: [
      "Gluten (pastry)",
      "Dairy (butter)",
    ],
    imagePath: RecipeCardImages.chickenTikaMasala,
    isFavourite: false,
    isImageFromHive: false,
    imageStoredInHive: null,
  ),
  FoodDishModel(
    id: "9",
    name: "Lancashire Hotpot",
    ingredientsList: [
      "Lamb neck fillet or stewing lamb",
      "onions",
      "carrots",
      "flour",
      "lamb or beef stock",
      "potatoes",
      "butter",
    ],
    description:
        "A traditional casserole dish from Lancashire made with lamb, onions, and topped with sliced potatoes.",
    instructionsList: [
      "Brown lamb in a pan, then transfer to a casserole dish.",
      "Layer sliced potatoes, onions, and carrots over the lamb.",
      "Sprinkle flour over the vegetables, then add stock, thyme, and bay leaves.",
      "Dot the top with butter, cover, and bake until the lamb is tender and the potatoes are cooked through.",
    ],
    tipsAndTricksList: [
      "Use waxy potatoes for better texture in the hotpot.",
      "Choose well-marbled lamb for a richer flavor.",
    ],
    allergiesList: [
      "Gluten (flour)",
      "Dairy (butter)",
    ],
    imagePath: RecipeCardImages.lancashireHotpot,
    isFavourite: false,
    isImageFromHive: false,
    imageStoredInHive: null,
  ),
  FoodDishModel(
    id: "10",
    name: "Scotch Egg",
    ingredientsList: [
      "Hard-boiled eggs",
      "Sausage meat",
      "Breadcrumbs",
      "Flour",
      "Egg (for egg wash)",
      "Oil for frying",
    ],
    description:
        "A hard-boiled egg wrapped in sausage meat, coated in breadcrumbs, and deep-fried until crispy.",
    instructionsList: [
      "Peel the hard-boiled eggs and coat them with flour.",
      "Encase each egg in sausage meat, ensuring it's evenly coated.",
      "Dip the coated eggs in beaten egg, then roll in breadcrumbs until fully covered.",
      "Fry the Scotch eggs in hot oil until golden brown and cooked through.",
    ],
    tipsAndTricksList: [
      "Use cold sausage meat to make it easier to shape around the eggs.",
      "Chill the coated eggs before frying to help them hold their shape.",
    ],
    allergiesList: [
      "Gluten (breadcrumbs)",
      "Dairy (if breadcrumbs contain milk)",
      "Egg (egg wash)",
    ],
    imagePath: RecipeCardImages.scotchEgg,
    isFavourite: false,
    isImageFromHive: false,
    imageStoredInHive: null,
  ),
];

import 'dart:convert';
import 'dart:developer' as dev;

class Recipe {
  final String name;
  final String images;
  final String recipeId;
  final String instructions;
  final List<List<String?>> ingredients;
  final String isAlcoholic;
  final String glassType;
  final String category;
  final String? videoUrl;

  Recipe(
      {required this.name,
      required this.images,
      required this.recipeId,
      required this.instructions,
      required this.ingredients,
      required this.glassType,
      required this.isAlcoholic,
      required this.category,
      this.videoUrl});

  factory Recipe.fromJson(Map json) {
    Map data = {...json};

    data.removeWhere((key, value) {
      String strKey = key.toString();
      if (strKey.contains('strIngredient') || strKey.contains('strMeasure')) {
        if (value != null) {
          return false;
        }
        return true;
      }
      return true;
    });

    List<String> items = [];
    List<String?> measures = [];
    List<List<String?>> ingredients = [];

    data.forEach((key, value) {
      if (key.toString().contains('strIngredient')) {
        items.add(value);
      } else {
        measures.add(value);
      }
    });
    if (items.length == measures.length) {
      for (var i = 0; i < items.length; i++) {
        final temp = [items[i], measures[i] ?? ""];
        ingredients.add(temp);
      }
    } else {
      for (var i = 0; i < items.length; i++) {
        final temp = [
          items[i],
          // items.last == items[i] ? "Up to you" : measures[i]
          (i + 1) > measures.length ? "Up to you" : measures[i]
        ];
        ingredients.add(temp);
      }
    }

    // dev.debugger();

    return Recipe(
      name: json['strDrink'] as String,
      images: json['strDrinkThumb'] as String,
      recipeId: json['idDrink'] as String,
      instructions: json['strInstructions'] as String,
      ingredients: ingredients,
      isAlcoholic: json['strAlcoholic'],
      glassType: json['strGlass'],
      category: json['strCategory'],
      videoUrl: json['strVideo'] != null ? json['strVideo'].toString().split('=').last : null,
    );
  }

  static List<Recipe> recipesFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return Recipe.fromJson(data);
    }).toList();
  }
}

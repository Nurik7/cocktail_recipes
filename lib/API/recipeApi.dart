import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:recipe_app/models/recipe.dart';
import 'dart:developer' as dev;

class RecipeApi {
  static Future<List<Recipe>?> getRecipe(pageCode) async {
    try {
      if (pageCode > 122) return null;
      final String pageLetter = Utf8Decoder().convert([pageCode]);

      var uri = Uri.https('www.thecocktaildb.com', 'api/json/v1/1/search.php',
          {'f': pageLetter});
      final response = await http.get(uri);
      Map data = jsonDecode(response.body);
      List temp = [];

      for (var i in data['drinks']) {
        temp.add(i);
      }
      return Recipe.recipesFromSnapshot(temp);
    } catch (e) {
      print(e);
    }
  }
}

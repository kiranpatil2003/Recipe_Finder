import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/recipe.dart';

class ApiServices {

  static const apiKey = "c2efafcc17e748268f86dcb73231fe46";

  Future<List<Recipe>> searchRecipes(String query) async {

    final url = Uri.parse(
   "https://api.spoonacular.com/recipes/complexSearch?query=$query&number=10&addRecipeInformation=true&addRecipeNutrition=true&apiKey=$apiKey"
    ); 
  

    final response = await http.get(url);

    if (response.statusCode == 200) {

      final data = json.decode(response.body);
      List results = data['results'];

      return results.map((e) => Recipe.fromJson(e)).toList();

    } else {
      throw Exception("Failed to load recipes");
    }
  }

  static Future<List<Recipe>> fetchLunchRecipes() async {
    final api = ApiServices();
    return api.searchRecipes("lunch");
  }

  static Future<Map<String, dynamic>> fetchRecipeDetails(int id) async {
    final url = Uri.parse(
      "https://api.spoonacular.com/recipes/$id/information?includeNutrition=true&apiKey=$apiKey"
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to load recipe details");
    }
  }
}
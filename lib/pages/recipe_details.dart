import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/recipe.dart';
import '../services/api_services.dart';

class RecipeDetails extends StatefulWidget {
  final Recipe recipe;
  final int people;
  

  const RecipeDetails({
    super.key,
    required this.recipe, required this.people,
  });

  @override
  State<RecipeDetails> createState() => _RecipeDetailsState();
}

class _RecipeDetailsState extends State<RecipeDetails> {

  Map recipeDetails = {};
  bool isLoading = true;

  int baseServings = 1;
  int selectedServings = 1;

  //  Load Recipe Details from API
  Future<void> loadRecipeDetails() async {
    final url = Uri.parse(
      "https://api.spoonacular.com/recipes/${widget.recipe.id}/information?apiKey=${ApiServices.apiKey}"
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        recipeDetails = json.decode(response.body);
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadRecipeDetails();
  }

  @override
  Widget build(BuildContext context) {

    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final int originalServings =
        (recipeDetails["servings"] as int?) ?? 1;

    // servings
    if (baseServings == 1) {
      baseServings = originalServings;
      selectedServings = widget.people;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe.title),
        backgroundColor: Colors.green,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            //  Image
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(widget.recipe.image),
            ),

            Text(
              "Cooking for ${widget.people} people",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 20),

            // Servings Selector
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Servings: $selectedServings (for ${widget.people} people)",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (selectedServings > 1) {
                          setState(() {
                            selectedServings--;
                          });
                        }
                      },
                      icon: const Icon(Icons.remove),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          selectedServings++;
                        });
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ],
                )
              ],
            ),

            const SizedBox(height: 15),

            // Nutrition Section
            const Text(
              "Nutrition",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text("Protein: ${widget.recipe.protein} g"),
            Text("Fat: ${widget.recipe.fat} g"),
            Text("Carbs: ${widget.recipe.carbs} g"),

            const SizedBox(height: 20),

            // Ingredients Title
            const Text(
              "Ingredients",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            //  Ingredients List (Dynamic)
            ...((recipeDetails["extendedIngredients"] as List<dynamic>?) ?? [])
                .map<Widget>((ingredient) {

              final double amount =
                  (ingredient["amount"] as num?)?.toDouble() ?? 0.0;

              final double scaledAmount =
                  (amount / baseServings) * selectedServings;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  "• ${scaledAmount.toStringAsFixed(1)} ${ingredient["unit"]} ${ingredient["name"]}",
                ),
              );
            }).toList(),

            const SizedBox(height: 20),

            //  Instructions Title
            const Text(
              "Instructions",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              recipeDetails["instructions"] ??
                  "No instructions available",
            ),
          ],
        ),
      ),
    );
  }
}
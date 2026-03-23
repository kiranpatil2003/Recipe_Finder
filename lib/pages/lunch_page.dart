import 'package:flutter/material.dart';
import 'package:recipe_finder/pages/recipe_details.dart';
import 'package:recipe_finder/services/api_services.dart';
import '../models/recipe.dart';

class LunchPage extends StatefulWidget {
  const LunchPage({super.key});

  @override
  State<LunchPage> createState() => _LunchPageState();
}

class _LunchPageState extends State<LunchPage> {

  late Future<List<Recipe>> recipes;

  @override
  void initState() {
    super.initState();
    recipes = ApiServices.fetchLunchRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lunch Recipes"),
      ),

      body: FutureBuilder<List<Recipe>>(
        future: recipes,
        builder: (context, snapshot) {

          //Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          
          if (snapshot.hasError) {
            return const Center(child: Text("Error loading data"));
          }

          final data = snapshot.data!;

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {

              final recipe = data[index];

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  leading: Image.network(recipe.image),
                  title: Text(recipe.title),

                  // ✅ FIXED onTap
                  onTap: () async {

                    TextEditingController controller = TextEditingController();

                    int? people = await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("How Many People Will Eat?"),

                          content: TextField(
                            controller: controller,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: "Enter number of people",
                            ),
                          ),

                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(
                                  context,
                                  int.tryParse(controller.text) ?? 1,
                                );
                              },
                              child: const Text("OK"),
                            ),
                          ],
                        );
                      },
                    );

                    if (people != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RecipeDetails(
                            recipe: recipe,
                            people: people,
                          ),
                        ),
                      );
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
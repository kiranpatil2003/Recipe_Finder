import 'package:flutter/material.dart';
import 'package:recipe_finder/models/recipe.dart';
import 'package:recipe_finder/pages/recipe_details.dart';
import 'package:recipe_finder/services/api_services.dart';

class DinnerPage extends StatefulWidget {
  final String mealType;

  const DinnerPage({super.key,
  required this.mealType
  });

  @override
  State<DinnerPage> createState() => _DinnerPageState();
}

class _DinnerPageState extends State<DinnerPage> {
   List<Recipe> recipes = [];
   bool isLoading = true;
   

    @override
    void initState() {
      super.initState();
      loadDinnerRecipes();
    }

    Future<void>loadDinnerRecipes() async{
      String query = widget.mealType == "vegetarian"
      ? "vegetarian dinner"
      : "chicken dinner";

      final result = await ApiServices().searchRecipes(query);

      setState(() {
        recipes = result;
        isLoading = false;
      });
    }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dinner (${widget.mealType})"),
      ),
      body: isLoading
      ? const Center(child: CircularProgressIndicator())
      : ListView.builder(
        itemCount: recipes.length,
        itemBuilder: (context, index){
          final recipe = recipes[index];

          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              leading: Image.network(recipe.image),
              title: Text(recipe.title),

              subtitle: SizedBox(
                height: 60,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("protein: ${recipe.protein}g"),
                    Text("fat: ${recipe.fat}g"),
                    Text("Carbs: ${recipe.carbs}g")
                  ],
                ),
              ),
              
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
                        )
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
        }
        )
    );
  }
}
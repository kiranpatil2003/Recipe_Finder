import 'package:flutter/material.dart';
import 'package:recipe_finder/models/recipe.dart';
import 'package:recipe_finder/pages/recipe_details.dart';
import 'package:recipe_finder/services/favourite_services.dart';


class RecipeCard extends StatefulWidget {
  final Recipe recipe;
  final int people;

  const RecipeCard({
    super.key,
    required this.recipe,
    required this.people,
  });

  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {

  @override
  Widget build(BuildContext context) {

    final recipe = widget.recipe;

    return GestureDetector(
      onTap: () async {

        TextEditingController controller = TextEditingController();

        int? people = await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("How Many People Will Eat?"),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),

              content: TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Enter number of people",
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
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
              builder: (context) => RecipeDetails(
                recipe: recipe,
                people: people, 
              ),
            ),
          );
        }
      },

      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color.fromARGB(255, 235, 229, 174),
          boxShadow: const [
            BoxShadow(
              blurRadius: 10,
              color: Color.fromARGB(255, 224, 220, 182),
              offset: Offset(0, 5),
            )
          ],
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 🖼 IMAGE + ❤️
            Stack(
              children: [

                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                  child: Image.network(
                    recipe.image,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

                // ❤️ FAVORITE ICON
                Positioned(
                  right: 10,
                  top: 10,
                  child: IconButton(
                    icon: Icon(
                      FavouriteServices.isFavourite(recipe)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      setState(() {
                        if (FavouriteServices.isFavourite(recipe)) {
                          FavouriteServices.removeFromFavourites(recipe);
                        } else {
                          FavouriteServices.addtoFavourites(recipe);
                        }
                      });

                      // ✅ Snackbar feedback
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            FavouriteServices.isFavourite(recipe)
                                ? "Added to Favorites ❤️"
                                : "Removed from Favorites",
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    recipe.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Row(
                    children: [
                      const Icon(Icons.timer, size: 16),
                      const SizedBox(width: 5),
                      Text("${recipe.readyInMinutes} mins"),
                    ],
                  ),

                  const SizedBox(height: 5),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Carbs ${recipe.carbs.toStringAsFixed(0)}%"),
                      Text("Protein ${recipe.protein.toStringAsFixed(0)}%"),
                      Text("Fats ${recipe.fat.toStringAsFixed(0)}%"),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
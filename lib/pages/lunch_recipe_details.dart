import 'package:flutter/material.dart';
import 'package:recipe_finder/services/api_services.dart';

class LunchRecipeDetails extends StatefulWidget {
  final int id;
  const LunchRecipeDetails({super.key, required this.id});

  @override
  State<LunchRecipeDetails> createState() => _LunchRecipeDetailsState();
}

class _LunchRecipeDetailsState extends State<LunchRecipeDetails> {
  late Future<Map<String, dynamic >> recipe;

  @override
  void initState(){
    super.initState();
    recipe = ApiServices.fetchRecipeDetails(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
      title: const Text("Recipe Details"),
    ),
    body: FutureBuilder<Map<String,dynamic>>(
      future: recipe,
      builder: (context, snapshot){
        if(!snapshot.hasData){
          return const Center(child: CircularProgressIndicator(),);
        }
        final data = snapshot.data!;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Image
              Image.network(data["image"]),

              const SizedBox(height: 10), 

              //Title
              Text(
                data["title"],
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              //serving + time
              Text("serves:${data["servings"]} people"),
              Text("Time: ${data["readyInMinutes"]}min"),

              const SizedBox(height: 15),

              //Ingridents
              const Text("Ingredients",
              style: TextStyle(fontSize: 18,
              fontWeight: FontWeight.bold
              )),

              ...data["extendedIngredients"].map<Widget>((item){
                return Text(".${item["original"]}");
              }),
              const SizedBox(height: 15),

              //Nutrition
              const Text("Nutrition",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ...data["nutrition"]["nutrients"].take(6).map<Widget>((n){
                return Text("${n["name"]}:${n["amount"]}${n["unit"]}");
              }),

              const SizedBox(height: 15),

              //Steps
              const Text("Steps",
               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
              ),

              ...(data["analyzedInstructions"].isNotEmpty
              ?data["analyzedInstructions"][0]["steps"].map<Widget>((step){
                return Text("${step["number"]}. ${step["step"]}");
              })
              :[const Text("No Steps available")]
              ),
            ],
          ),
        );
      }
    )
    );
  }
}
import 'package:flutter/material.dart';
import '../models/recipe.dart';
import 'package:recipe_finder/services/api_services.dart';
import 'package:recipe_finder/widget/recipe_card.dart';

class Breakfast extends StatefulWidget {
  const Breakfast({super.key});

  @override
  State<Breakfast> createState() => _BreakfastState();
}

class _BreakfastState extends State<Breakfast> {

  List<Recipe> BreakfastRecipes = [];
    final ApiServices api = ApiServices();
    bool isLoading = true;


   @override
   void initState() {
    super.initState();
    loadBreakfastRecipes();
   }
   //fetch breakfast recipes
   void loadBreakfastRecipes() async{
    final results = await api.searchRecipes("breakfast");
    setState(() {
      BreakfastRecipes = results;
      isLoading = false;
    });
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       
      appBar: AppBar(
        title: const Text("Breakfast Recipes"),
        backgroundColor: Colors.green,
      ),
      body: isLoading
        ? const Center(child: CircularProgressIndicator())
        :ListView.builder(
          itemCount: BreakfastRecipes.length,
          itemBuilder: (context, index) {
            return RecipeCard(
              recipe: BreakfastRecipes[index],
              people: 1,
              );
          },
          ),
    );
  }
}
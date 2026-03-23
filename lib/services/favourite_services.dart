import 'package:flutter/material.dart';
import '../models/recipe.dart';

class FavouriteServices {
  static List<Recipe> favorites = [];

  static void addtoFavourites(Recipe recipe){
    if(!favorites.contains(recipe)) {
      favorites.add(recipe);
    }
  }
  static void removeFromFavourites(Recipe recipe){
    favorites.remove(recipe);
  }

  static bool isFavourite(Recipe recipe){
    return favorites.contains(recipe);
  }
}
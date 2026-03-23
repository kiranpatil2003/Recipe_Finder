import 'dart:convert';
import 'package:flutter/material.dart';

class Recipe {
  final int id;
  final String title;
  final String image;
  final double protein;
  final double fat;
  final double carbs;
  final int readyInMinutes;


  Recipe({
    required this.id,
    required this.title,
    required this.image,
    required this.protein,
    required this.fat,
    required this.carbs,
    required this.readyInMinutes,
  });

  static double getNutrient(List nutrients, String name){
    return  nutrients.firstWhere(
      (n) => n["name"] == name,
      orElse: () => {"amount":0},
    )["amount"].toDouble();
  }

  factory Recipe.fromJson(Map<String, dynamic>json) {
    var nutrients = json["nutrition"]["nutrients"];
     return Recipe(
      id: json["id"],
      title: json["title"],
      image: json["image"],
      protein: Recipe.getNutrient(nutrients, "Protein"),
      fat: Recipe.getNutrient(nutrients, "Fat"),
      carbs: Recipe.getNutrient(nutrients, "Carbohydrates"),
      readyInMinutes: json["readyInMinutes"] ?? 0,
    );
  }
  @override
bool operator ==(Object other) =>
    identical(this, other) ||
    other is Recipe && id == other.id;

@override
int get hashCode => id.hashCode;
}

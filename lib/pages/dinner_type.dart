import 'package:flutter/material.dart';
import 'package:recipe_finder/pages/dinner_page.dart';

class DinnerType extends StatelessWidget {
  const DinnerType({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Choose Your Meal Type"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 30),

            const Text(
              "What Would You Like For Dinner?",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

              const SizedBox(height: 40),

              //Veg
              _mealCard(
                context,
                title: "Vegetarian",
                color: Colors.green,
                type: "Vegetarian",
              ),
             const SizedBox(height: 20),

             //Non-Veg
             _mealCard(
              context,
              title: "Non-Vegetarian",
              color: Colors.red,
              type: "Non-Vegetarian",
             ),
          ],
        ),
       ),
      );
   }
   Widget _mealCard(BuildContext context,
   {required String title, required Color color, required String type}) {
    return GestureDetector(
     onTap: () {
      Navigator.push(
        context, 
        MaterialPageRoute(
          builder: (_) => DinnerPage(mealType: type),
        ),
      ); 
     },

     child: Container(
      height: 120,
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            color: color,
          ),
        ),
      ),
     ),
    );
   }
}
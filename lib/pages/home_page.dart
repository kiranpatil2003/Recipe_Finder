import 'package:flutter/material.dart';
import 'package:recipe_finder/pages/dinner_page.dart';
import '../models/recipe.dart';
import 'package:recipe_finder/pages/breakfast.dart';
import 'package:recipe_finder/services/api_services.dart';
import 'lunch_page.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final List<Map<String, dynamic>> categories = [
    {"icon": Icons.free_breakfast, "name": "Breakfast"},
    {"icon": Icons.lunch_dining, "name": "Lunch"},
    {"icon": Icons.dinner_dining, "name": "Dinner"},
    {"icon": Icons.fastfood, "name": "Snacks"},
    {"icon": Icons.local_drink, "name": "Drinks"},
    {"icon": Icons.cake, "name": "Desserts"},
    {"icon": Icons.rice_bowl, "name": "Salads"},
    {"icon": Icons.grid_view, "name": "More"},
  ];

  List<Recipe> recipes = [];
  final ApiServices api = ApiServices();

  void searchRecipe(String query) async {
    final results = await api.searchRecipes(query);
    setState(() {
      recipes = results;
    });

  }

  // final List<String> recipes = [
  //   "images/biryani.jpg",
  //   "images/desserts.jpg",
  //   "images/bg4.jpg",
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
        ],
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      CircleAvatar(
                        backgroundImage:
                            NetworkImage("https://i.pravatar.cc/150?img=3"),
                      ),
                      SizedBox(width: 10),
                      Text("Hi, Kiran!", style: TextStyle(fontSize: 16))
                    ],
                  ),
                  const Icon(Icons.notifications_none)
                ],
              ),

              const SizedBox(height: 20),

              const Text(
                "Let's get cooking!",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    icon: Icon(Icons.search),
                    hintText: "Search your next meal...",
                    border: InputBorder.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: GridView.builder(
                  itemCount: categories.length,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15,
                  ),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: (){
                        if(categories[index]["name"]=="Breakfast") {
                          Navigator.push(
                            context, 
                            MaterialPageRoute(
                              builder: (context)=>const Breakfast(),
                              ),
                            );
                          }
                           else if (categories[index]["name"] == "Lunch") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LunchPage(),
                              ),
                            );
                          }
                          else if (categories[index]["name"] == "Dinner") {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                title: const Text("Choose Meal Type"),

                                content: Column(
  mainAxisSize: MainAxisSize.min,
  children: [

    // 🥗 VEG CARD
    GestureDetector(
      onTap: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const DinnerPage(mealType: "vegetarian"),
          ),
        );
      },
      child: Container(
        height: 80,
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.2),
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Center(
          child: Text(
            "🥗 Vegetarian",
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    ),

    // 🍗 NON-VEG CARD
    GestureDetector(
      onTap: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const DinnerPage(mealType: "non-veg"),
          ),
        );
      },
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.2),
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Center(
          child: Text(
            "🍗 Non-Vegetarian",
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    ),

  ],
),
                              );
                            },
                          );
                        }
                                                
                      },
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              categories[index]["icon"],
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(categories[index]["name"],
                              style: const TextStyle(fontSize: 12))

                              
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
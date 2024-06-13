import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lab_food_2/UI/favorite_foods_page/favorite_foods_page.dart';
import 'package:lab_food_2/UI/foods_page/foods_page.dart';

class FoodApp extends StatefulWidget
{
  const FoodApp({super.key});

  @override
  FoodAppState createState() => FoodAppState();
}

class FoodAppState extends State<FoodApp>
{
  int currentIndex = 0;

  @override
  Widget build(BuildContext context)
  {
    void onNavigationBarLinkTapped(int index) async
    {
      setState(() {
        currentIndex = index;
      });
    }

    return MaterialApp(
        title: 'Еда',
        theme: ThemeData(
            useMaterial3: true,
            colorScheme: const ColorScheme.light(
                onSurface: Colors.white,
                onBackground: Color.fromARGB(255, 158, 10, 226),
            ),
            textTheme: GoogleFonts.manropeTextTheme(
              const TextTheme(
                bodyMedium: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
                bodySmall: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
                bodyLarge: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                )
              )
            ),
            appBarTheme: const AppBarTheme(
                backgroundColor: Color.fromARGB(255, 90, 1, 233),
                titleTextStyle: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                ),
                centerTitle: true,
            ),
        ),
        home: Scaffold(
          body: IndexedStack(
            index: currentIndex,
            children: const [
              FoodsPage(),
              FavoriteFoodsPage()
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: onNavigationBarLinkTapped,
            selectedItemColor: Color.fromARGB(255, 105, 1, 241),
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Выбор',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: 'Избранное',
              ),
            ],
          ),
        )
    );
  }
}

void main() async
{
    FoodApp app = const FoodApp();
    runApp(app);
}

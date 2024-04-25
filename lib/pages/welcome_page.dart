import 'package:flutter/material.dart';
import 'package:my_meal_app/pages/register_page.dart';
import '../components/background_image.dart';
import '../constants.dart';
import 'login_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BackgroundImage(imageResource: "assets/images/welcome_poster.jpg"),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                const Text(
                  welcomeTitle,
                  style: TextStyle(
                      fontSize: 34,
                      color: mealColor,
                      fontWeight: FontWeight.bold
                  ),
                ),
                Text(
                  welcomeDesc,
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 54),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const LoginPage())
                        );
                      },
                      child: const Text(
                        signIn,
                        style: TextStyle(
                            color: mealColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18
                        ) ,
                      ),
                    ),
                    const Text(
                      or,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateColor.resolveWith((states) => mealColor),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const RegisterPage())
                        );
                      },
                      child: const Text(
                        signUp,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18
                        ) ,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 44),
              ],
            ),
          )
        ],
      )
    );
  }
}

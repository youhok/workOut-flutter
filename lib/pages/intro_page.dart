import 'package:flutter/material.dart';
import './home_page.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          //logo
          Padding(
            padding: const EdgeInsets.only(
                left: 80.0, right: 80, bottom: 40, top: 160),
            child: Image.asset('lib/image/muscle.png'),
          ),

          //we deliver groceries at your doorstep
         const Padding(
            padding: EdgeInsets.all(24.0),
            child: Text(
              "Your Workout Companion",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          //fresh items everyday
          const Text(
            "Track your daily work & watch your progress",
            style: TextStyle(color: Colors.grey),
          ),
          const Spacer(),
          //get started button
          GestureDetector(
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) {
                return const HomePage();
              }),
            ),
            child: Container(
              width: 300,
              decoration: BoxDecoration(
                  color: Colors.brown,
                  borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.all(24),
              child: const Text(
                "Get Started",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold ,fontSize: 20),
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
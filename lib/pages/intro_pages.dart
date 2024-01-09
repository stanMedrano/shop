import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'home_page.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Logo
              Padding(
                padding: const EdgeInsets.all(25),
                child: Lottie.asset('lib/imagenes/anima.json'),
              ),
              const SizedBox(height: 48),
              //title
              const Text(
                'Ricas pupusas y más',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              //sub-title
              const Text(
                'Disfruta de nuestros ricos platillos.',
                style: TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(255, 114, 114, 114),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              //start now button
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(25),
                  child: const Center(
                    child: Text(
                      'Ir al menu',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

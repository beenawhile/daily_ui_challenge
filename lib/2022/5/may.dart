import 'package:daily_ui/2022/5/1_neon_light/neon_light_screen.dart';
import 'package:daily_ui/2022/5/2_moving_gradation/moving_gradation_screen.dart';
import 'package:flutter/material.dart';

class MayScreen extends StatelessWidget {
  const MayScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const NeonLightScreen(),
                    ),
                  );
                },
                child: const Text("1. Neon Light Animation"),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const MovingGradationScreen(),
                    ),
                  );
                },
                child: const Text("2. Moving Gradation Animation"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../widgets/common_widgets.dart';
import 'level_selection_screen.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CandyBackground(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'CANDY\nPUZZLE',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: 60),
              CandyButton(
                text: 'PLAY',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LevelSelectionScreen()),
                  );
                },
              ),
              const SizedBox(height: 20),
              CandyButton(
                text: 'EXIT',
                color: Colors.redAccent,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}


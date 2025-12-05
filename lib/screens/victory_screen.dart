import 'package:flutter/material.dart';
import '../widgets/common_widgets.dart';
import '../widgets/confetti_widget.dart';
import '../state/game_provider.dart';
import '../state/game_controller.dart';

class VictoryScreen extends StatefulWidget {
  const VictoryScreen({super.key});

  @override
  State<VictoryScreen> createState() => _VictoryScreenState();
}

class _VictoryScreenState extends State<VictoryScreen> {
  bool _showConfetti = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showConfetti = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final GameController controller = GameProvider.of(context);
    
    final currentLevelId = controller.currentLevel?.id ?? 0;
    final nextLevelId = currentLevelId + 1;
    final hasNextLevel = controller.levels.any((l) => l.id == nextLevelId);

    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.8),
      body: Stack(
        children: [
          if (_showConfetti)
            ConfettiWidget(
              isActive: _showConfetti,
              duration: const Duration(seconds: 3),
            ),
          Center(
            child: CandyCard(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star, color: Colors.yellowAccent, size: 80),
                  const SizedBox(height: 16),
                  Text(
                    'SWEET!',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: Colors.pinkAccent,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Level Completed',
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                  const SizedBox(height: 32),
                  if (hasNextLevel)
                    CandyButton(
                      text: 'NEXT LEVEL',
                      onPressed: () {
                        Navigator.pop(context);
                        controller.selectLevel(nextLevelId);
                      },
                    ),
                  if (hasNextLevel) const SizedBox(height: 16),
                  CandyButton(
                    text: 'MENU',
                    color: Colors.purpleAccent,
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      controller.completeLevelAndReturn();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


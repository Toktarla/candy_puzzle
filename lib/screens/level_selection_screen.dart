import 'package:flutter/material.dart';
import '../state/game_provider.dart';
import '../state/game_controller.dart';
import '../widgets/common_widgets.dart';
import 'game_screen.dart';

class LevelSelectionScreen extends StatelessWidget {
  const LevelSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GameController controller = GameProvider.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Level'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: CandyBackground(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.2,
            ),
            itemCount: controller.levels.length,
            itemBuilder: (context, index) {
              final level = controller.levels[index];
              final isLocked = level.id > (controller.completedLevels + 1);
              final isCompleted = level.id <= controller.completedLevels;

              return GestureDetector(
                onTap: isLocked
                    ? null
                    : () {
                        controller.selectLevel(level.id);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const GameScreen(),
                          ),
                        );
                      },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    color: isLocked
                        ? Colors.grey.withValues(alpha: 0.5)
                        : (isCompleted ? Colors.green.withValues(alpha: 0.8) : Colors.white.withValues(alpha: 0.2)),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: isLocked ? 0.2 : 0.8),
                      width: 2,
                    ),
                    boxShadow: isLocked
                        ? []
                        : [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            )
                          ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isLocked
                            ? Icons.lock
                            : (isCompleted ? Icons.star : Icons.play_arrow),
                        size: 40,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        level.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'theme/candy_theme.dart';
import 'state/game_controller.dart';
import 'state/game_provider.dart';
import 'screens/menu_screen.dart';

void main() {
  runApp(const CandyPuzzleApp());
}

class CandyPuzzleApp extends StatefulWidget {
  const CandyPuzzleApp({super.key});

  @override
  State<CandyPuzzleApp> createState() => _CandyPuzzleAppState();
}

class _CandyPuzzleAppState extends State<CandyPuzzleApp> {
  final GameController _gameController = GameController();

  @override
  void dispose() {
    _gameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GameProvider(
      controller: _gameController,
      child: MaterialApp(
        title: 'Candy Puzzle',
        debugShowCheckedModeBanner: false,
        theme: CandyTheme.themeData,
        home: const MainMenuScreen(),
      ),
    );
  }
}

import 'package:flutter/widgets.dart';
import 'game_controller.dart';

class GameProvider extends InheritedNotifier<GameController> {
  const GameProvider({
    super.key,
    required GameController controller,
    required super.child,
  }) : super(notifier: controller);

  static GameController of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<GameProvider>()!.notifier!;
  }
}


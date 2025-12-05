import 'package:flutter/material.dart';
import '../state/game_provider.dart';
import '../state/game_controller.dart';
import '../models/game_models.dart';
import '../widgets/common_widgets.dart';
import 'victory_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  final Map<int, AnimationController> _snapAnimations = {};

  @override
  void dispose() {
    for (var controller in _snapAnimations.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _triggerSnapAnimation(int index) {
    if (!_snapAnimations.containsKey(index)) {
      final controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      );
      _snapAnimations[index] = controller;
    }
    _snapAnimations[index]!.reset();
    _snapAnimations[index]!.forward().then((_) {
      if (mounted) {
        setState(() {
          _snapAnimations.remove(index);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = GameProvider.of(context);
    final level = controller.currentLevel;

    if (level == null) return const SizedBox.shrink();

    if (controller.isVictory) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            opaque: false,
            pageBuilder: (_, __, ___) => const VictoryScreen(),
          ),
        );
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(level.name),
            Text(
              '⏱ ${controller.formattedTime}',
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
             controller.completeLevelAndReturn();
             Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: controller.resetLevel,
          )
        ],
      ),
      extendBodyBehindAppBar: true,
      body: CandyBackground(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.extension, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    '${controller.placedPiecesCount}/${controller.totalPiecesCount}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    ' pieces placed',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Center(
                child: AspectRatio(
                  aspectRatio: level.cols / level.rows,
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.5), width: 2),
                    ),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: level.cols,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: level.rows * level.cols,
                      itemBuilder: (context, index) {
                        final placedPiece = controller.placedPieces[index];
                        final targetPiece = level.pieces.cast<PuzzlePiece?>().firstWhere(
                          (p) => p?.targetIndex == index,
                          orElse: () => null,
                        );

                        return _buildGridSlot(context, index, placedPiece, targetPiece, controller, level);
                      },
                    ),
                  ),
                ),
              ),
            ),
            
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: level.pieces.where((p) => !controller.isPiecePlaced(p)).map((piece) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Draggable<PuzzlePiece>(
                          data: piece,
                          feedback: Opacity(
                            opacity: 0.8, 
                            child: _buildPieceWidget(piece, size: 80)
                          ),
                          childWhenDragging: Opacity(
                            opacity: 0.3,
                            child: _buildPieceWidget(piece),
                          ),
                          child: _buildPieceWidget(piece),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridSlot(
    BuildContext context, 
    int index, 
    PuzzlePiece? placedPiece, 
    PuzzlePiece? targetPiece,
    GameController controller,
    Level level,
  ) {
    bool isTarget = targetPiece != null;

    return DragTarget<PuzzlePiece>(
      onWillAccept: (piece) {
        return piece?.targetIndex == index;
      },
      onAccept: (piece) {
        controller.placePiece(index, piece);
        _triggerSnapAnimation(index);
      },
      builder: (context, candidateData, rejectedData) {
        if (placedPiece != null) {
          return LayoutBuilder(
            builder: (context, constraints) {
              final cellSize = constraints.maxWidth;
              return _buildPieceWidget(
                placedPiece, 
                isPlaced: true, 
                index: index,
                size: cellSize,
              );
            },
          );
        }
        
        return Container(
          decoration: BoxDecoration(
            color: isTarget ? Colors.white.withValues(alpha: 0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: isTarget 
              ? Border.all(
                  color: candidateData.isNotEmpty 
                      ? Colors.yellowAccent 
                      : Colors.white.withValues(alpha: 0.3),
                  width: 2,
                  style: BorderStyle.solid
                )
              : null,
          ),
          child: isTarget 
            ? Center(
                child: Icon(
                  _getIconForShape(targetPiece.shape),
                  color: Colors.white.withValues(alpha: 0.2),
                  size: 30,
                ),
              )
            : null,
        );
      },
    );
  }

  Widget _buildPieceWidget(PuzzlePiece piece, {double size = 60, bool isPlaced = false, int? index}) {
    Widget pieceContent = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: piece.color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: isPlaced 
          ? [
              BoxShadow(
                color: piece.color.withValues(alpha: 0.5),
                blurRadius: 15,
                spreadRadius: 2,
              )
            ]
          : [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 5,
                offset: const Offset(0, 3),
              )
            ],
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Center(
        child: Icon(
          _getIconForShape(piece.shape),
          color: Colors.white,
          size: size * 0.6,
        ),
      ),
    );

    if (isPlaced && index != null && _snapAnimations.containsKey(index)) {
      final controller = _snapAnimations[index]!;
      return AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          final curvedValue = Curves.elasticOut.transform(controller.value);
          final scale = 1.0 + (curvedValue * 0.2);
          return Transform.scale(
            scale: scale,
            child: pieceContent,
          );
        },
        child: pieceContent,
      );
    }

    return pieceContent;
  }

  IconData _getIconForShape(CandyShape shape) {
    switch (shape) {
      case CandyShape.circle: return Icons.circle;
      case CandyShape.square: return Icons.crop_square;
      case CandyShape.triangle: return Icons.change_history;
      case CandyShape.heart: return Icons.favorite;
      case CandyShape.star: return Icons.star;
    }
  }
}


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
  final GlobalKey _boardKey = GlobalKey();

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
      backgroundColor: Colors.transparent,
      body: CandyBackground(
        backgroundImage: 'assets/images/bg.png',
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      controller.completeLevelAndReturn();
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.amber.shade200, width: 2),
                      ),
                      child: const Icon(Icons.arrow_back, color: Colors.brown),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.brown.shade700,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.brown.shade900, width: 2),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.access_time, color: Colors.red, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          controller.formattedTime,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.amber.shade200, width: 2),
                      ),
                      child: const Icon(Icons.pause, color: Colors.brown),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Center(
                child: AspectRatio(
                  aspectRatio: level.type == LevelType.grid 
                      ? level.cols / level.rows 
                      : 1.0,
                  child: level.type == LevelType.grid
                      ? Container(
                          margin: const EdgeInsets.all(16),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(196, 142, 192, 0.75),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white,
                              width: 3,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: _buildGridBoard(context, controller, level),
                          ),
                        )
                      : Container(
                          margin: const EdgeInsets.all(16),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(196, 142, 192, 0.75),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white,
                              width: 3,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: _buildCustomBoard(context, controller, level),
                          ),
                        ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: 1,
                itemBuilder: (context, index) {
                  return SizedBox(width: MediaQuery.of(context).size.width);
                },
              ),
            ),
            Container(
              height: 120,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: level.pieces.where((p) => !controller.isPiecePlaced(p)).length,
                itemBuilder: (context, index) {
                  final unplacedPieces = level.pieces.where((p) => !controller.isPiecePlaced(p)).toList();
                  final piece = unplacedPieces[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Draggable<PuzzlePiece>(
                      data: piece,
                      feedback: Opacity(
                        opacity: 0.8, 
                        child: _buildPieceWidget(piece, size: 100)
                      ),
                      childWhenDragging: Opacity(
                        opacity: 0.3,
                        child: _buildPieceWidget(piece, size: 100),
                      ),
                      child: _buildPieceWidget(piece, size: 100),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridBoard(BuildContext context, GameController controller, Level level) {
    return GridView.builder(
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
    );
  }

  Widget _buildCustomBoard(BuildContext context, GameController controller, Level level) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final boardWidth = constraints.maxWidth;
        final boardHeight = constraints.maxHeight;

        return DragTarget<PuzzlePiece>(
          key: _boardKey,
          onWillAccept: (draggedPiece) => true,
          onAcceptWithDetails: (details) {
            final draggedPiece = details.data;
            final RenderBox? renderBox = _boardKey.currentContext?.findRenderObject() as RenderBox?;
            if (renderBox == null) return;
            
            final localOffset = renderBox.globalToLocal(details.offset);
            final dropCenter = localOffset + const Offset(50, 50);
            final targetPiece = level.pieces.firstWhere((p) => p.id == draggedPiece.id);
            
            final targetLeft = targetPiece.x * boardWidth;
            final targetTop = targetPiece.y * boardHeight;
            final targetWidth = targetPiece.width * boardWidth;
            final targetHeight = targetPiece.height * boardHeight;
            final targetCenter = Offset(targetLeft + targetWidth / 2, targetTop + targetHeight / 2);
            
            final tolerance = (boardWidth * 0.25).clamp(80.0, 150.0);
            
            if ((dropCenter - targetCenter).distance < tolerance) {
              if (!controller.placedPieces.containsKey(targetPiece.targetIndex) ||
                  controller.placedPieces[targetPiece.targetIndex]?.id != targetPiece.id) {
                controller.placePiece(targetPiece.targetIndex, draggedPiece);
                _triggerSnapAnimation(targetPiece.targetIndex);
              }
            }
          },
          builder: (context, candidateData, rejectedData) {
            return Stack(
              children: level.pieces.map((piece) {
                final double left = piece.x * boardWidth;
                final double top = piece.y * boardHeight;
                final double width = piece.width * boardWidth;
                final double height = piece.height * boardHeight;
                final isPlaced = controller.isPiecePlaced(piece);

                return Positioned(
                  left: left,
                  top: top,
                  width: width,
                  height: height,
                  child: isPlaced
                      ? _buildPieceWidget(piece, size: width, isPlaced: true, index: piece.targetIndex)
                      : Image.asset(
                          piece.assetPath!,
                          fit: BoxFit.contain,
                          opacity: const AlwaysStoppedAnimation(0.55),
                        ),
                );
              }).toList(),
            );
          },
        );
      },
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
    Widget pieceContent;
    
    if (piece.assetPath != null) {
      pieceContent = Image.asset(
        piece.assetPath!,
        width: size,
        height: size,
        fit: BoxFit.contain,
      );
    } else {
      pieceContent = Container(
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
    }

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
      case CandyShape.none: return Icons.help;
    }
  }
}

class ChocolateFramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.brown.shade800
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = Colors.brown.shade900
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path();
    path.addRRect(RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(8),
    ));
    
    canvas.drawPath(path, paint);
    canvas.drawPath(path, borderPaint);
    
    final drip1 = Path()
      ..moveTo(size.width * 0.3, size.height)
      ..lineTo(size.width * 0.35, size.height + 15)
      ..lineTo(size.width * 0.4, size.height)
      ..close();
    
    final drip2 = Path()
      ..moveTo(size.width * 0.6, size.height)
      ..lineTo(size.width * 0.65, size.height + 15)
      ..lineTo(size.width * 0.7, size.height)
      ..close();

    canvas.drawPath(drip1, paint);
    canvas.drawPath(drip2, paint);
  }

  @override
  bool shouldRepaint(ChocolateFramePainter oldDelegate) => false;
}

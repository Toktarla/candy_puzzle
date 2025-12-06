import 'package:flutter/material.dart';

enum CandyShape {
  circle,
  square,
  triangle,
  heart,
  star,
  none,
}

enum LevelType {
  grid,
  custom,
}

class PuzzlePiece {
  final String id;
  final CandyShape shape;
  final Color color;
  final int targetIndex;
  final String? assetPath;
  
  final double x;
  final double y;
  final double width;
  final double height;

  PuzzlePiece({
    required this.id,
    this.shape = CandyShape.none,
    this.color = Colors.transparent,
    this.targetIndex = -1,
    this.assetPath,
    this.x = 0,
    this.y = 0,
    this.width = 0.25,
    this.height = 0.25,
  });
}

class Level {
  final int id;
  final int rows;
  final int cols;
  final List<PuzzlePiece> pieces;
  final String name;
  final LevelType type;
  final String? backgroundImage;

  Level({
    required this.id,
    required this.pieces,
    required this.name,
    this.rows = 0,
    this.cols = 0,
    this.type = LevelType.grid,
    this.backgroundImage,
  });

  int get totalPieces => pieces.length;
}

class LevelData {
  static List<Level> get levels {
    return [
      Level(
        id: 1,
        rows: 2,
        cols: 2,
        name: "Level 1",
        type: LevelType.grid,
        pieces: [
          PuzzlePiece(id: 'l1_p1', shape: CandyShape.heart, color: Colors.redAccent, targetIndex: 0),
          PuzzlePiece(id: 'l1_p2', shape: CandyShape.star, color: Colors.yellowAccent, targetIndex: 1),
          PuzzlePiece(id: 'l1_p3', shape: CandyShape.circle, color: Colors.greenAccent, targetIndex: 2),
          PuzzlePiece(id: 'l1_p4', shape: CandyShape.square, color: Colors.white, targetIndex: 3),
        ],
      ),
      Level(
        id: 2,
        name: "Level 2 - Image Puzzle",
        type: LevelType.custom,
        pieces: [
          PuzzlePiece(id: 'l2_p1',  assetPath: 'assets/images/1.png',  targetIndex: 0,  x: 0.074, y: 0.033, width: 0.262, height: 0.178),
          PuzzlePiece(id: 'l2_p2',  assetPath: 'assets/images/2.png',  targetIndex: 1,  x: 0.532, y: 0.044, width: 0.334, height: 0.227),
          PuzzlePiece(id: 'l2_p3',  assetPath: 'assets/images/3.png',  targetIndex: 2,  x: 0.585, y: 0.693, width: 0.286, height: 0.307),
          PuzzlePiece(id: 'l2_p4',  assetPath: 'assets/images/4.png',  targetIndex: 3,  x: 0.062, y: 0.520, width: 0.326, height: 0.307),
          PuzzlePiece(id: 'l2_p5',  assetPath: 'assets/images/5.png',  targetIndex: 4,  x: 0.714, y: 0.304, width: 0.288, height: 0.307),
          PuzzlePiece(id: 'l2_p6',  assetPath: 'assets/images/6.png',  targetIndex: 5,  x: 0.269, y: 0.000, width: 0.364, height: 0.242),
          PuzzlePiece(id: 'l2_p7',  assetPath: 'assets/images/7.png',  targetIndex: 6,  x: 0.532, y: 0.288, width: 0.275, height: 0.405),
          PuzzlePiece(id: 'l2_p8',  assetPath: 'assets/images/8.png',  targetIndex: 7,  x: 0.025, y: 0.206, width: 0.562, height: 0.229),
          PuzzlePiece(id: 'l2_p9',  assetPath: 'assets/images/9.png',  targetIndex: 8,  x: 0.000, y: 0.374, width: 0.440, height: 0.376),
          PuzzlePiece(id: 'l2_p10', assetPath: 'assets/images/10.png', targetIndex: 9,  x: 0.121, y: 0.581, width: 0.356, height: 0.405),
          PuzzlePiece(id: 'l2_p11', assetPath: 'assets/images/11.png', targetIndex: 10, x: 0.449, y: 0.605, width: 0.265, height: 0.395),
          PuzzlePiece(id: 'l2_p12', assetPath: 'assets/images/12.png', targetIndex: 11, x: 0.799, y: 0.097, width: 0.202, height: 0.385),
          PuzzlePiece(id: 'l2_p13', assetPath: 'assets/images/13.png', targetIndex: 12, x: 0.765, y: 0.622, width: 0.233, height: 0.235),
        ],
      ),
      Level(
        id: 3,
        name: "Level 3 - New Image",
        type: LevelType.custom,
        pieces: [
          PuzzlePiece(id: 'l3_p1', assetPath: 'assets/images/1 copy.png', targetIndex: 0, x: 0.360, y: 0.870, width: 0.260, height: 0.130),
          PuzzlePiece(id: 'l3_p2', assetPath: 'assets/images/2 copy.png', targetIndex: 1, x: 0.621, y: 0.750, width: 0.156, height: 0.105),
          PuzzlePiece(id: 'l3_p3', assetPath: 'assets/images/3 copy.png', targetIndex: 2, x: 0.196, y: 0.711, width: 0.185, height: 0.132),
          PuzzlePiece(id: 'l3_p4', assetPath: 'assets/images/4 copy.png', targetIndex: 3, x: 0.515, y: 0.563, width: 0.148, height: 0.133),
          PuzzlePiece(id: 'l3_p5', assetPath: 'assets/images/5 copy.png', targetIndex: 4, x: 0.320, y: 0.573, width: 0.149, height: 0.138),
          PuzzlePiece(id: 'l3_p6', assetPath: 'assets/images/6 copy.png', targetIndex: 5, x: 0.000, y: 0.263, width: 0.289, height: 0.326),
          PuzzlePiece(id: 'l3_p7', assetPath: 'assets/images/7 copy.png', targetIndex: 6, x: 0.221, y: 0.026, width: 0.227, height: 0.306),
          PuzzlePiece(id: 'l3_p8', assetPath: 'assets/images/8 copy.png', targetIndex: 7, x: 0.709, y: 0.303, width: 0.291, height: 0.315),
          PuzzlePiece(id: 'l3_p9', assetPath: 'assets/images/9 copy.png', targetIndex: 8, x: 0.548, y: 0.040, width: 0.251, height: 0.316),
          PuzzlePiece(id: 'l3_p10', assetPath: 'assets/images/10 copy.png', targetIndex: 9, x: 0.241, y: 0.279, width: 0.239, height: 0.281),
          PuzzlePiece(id: 'l3_p11', assetPath: 'assets/images/11 copy.png', targetIndex: 10, x: 0.505, y: 0.289, width: 0.231, height: 0.274),
          PuzzlePiece(id: 'l3_p12', assetPath: 'assets/images/12 copy.png', targetIndex: 11, x: 0.099, y: 0.434, width: 0.276, height: 0.279),
          PuzzlePiece(id: 'l3_p13', assetPath: 'assets/images/13 copy.png', targetIndex: 12, x: 0.600, y: 0.461, width: 0.274, height: 0.279),
          PuzzlePiece(id: 'l3_p14', assetPath: 'assets/images/14 copy.png', targetIndex: 13, x: 0.334, y: 0.583, width: 0.312, height: 0.278),
          PuzzlePiece(id: 'l3_p15', assetPath: 'assets/images/15 copy.png', targetIndex: 14, x: 0.334, y: 0.294, width: 0.312, height: 0.279),
          PuzzlePiece(id: 'l3_p16', assetPath: 'assets/images/16 copy.png', targetIndex: 15, x: 0.334, y: 0.000, width: 0.312, height: 0.279),
        ],
      ),
    ];
  }
}

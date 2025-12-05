import 'package:flutter/material.dart';

enum CandyShape {
  circle,
  square,
  triangle,
  heart,
  star,
}

class PuzzlePiece {
  final String id;
  final CandyShape shape;
  final Color color;
  final int targetIndex;

  PuzzlePiece({
    required this.id,
    required this.shape,
    required this.color,
    required this.targetIndex,
  });
}

class Level {
  final int id;
  final int rows;
  final int cols;
  final List<PuzzlePiece> pieces;
  final String name;

  Level({
    required this.id,
    required this.rows,
    required this.cols,
    required this.pieces,
    required this.name,
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
        pieces: [
          PuzzlePiece(id: 'l1_p1', shape: CandyShape.heart, color: Colors.redAccent, targetIndex: 0),
          PuzzlePiece(id: 'l1_p2', shape: CandyShape.star, color: Colors.yellowAccent, targetIndex: 1),
          PuzzlePiece(id: 'l1_p3', shape: CandyShape.circle, color: Colors.greenAccent, targetIndex: 2),
          PuzzlePiece(id: 'l1_p4', shape: CandyShape.square, color: Colors.blueAccent, targetIndex: 3),
        ],
      ),
      Level(
        id: 2,
        rows: 3,
        cols: 2,
        name: "Level 2",
        pieces: [
          PuzzlePiece(id: 'l2_p1', shape: CandyShape.triangle, color: Colors.orangeAccent, targetIndex: 0),
          PuzzlePiece(id: 'l2_p2', shape: CandyShape.circle, color: Colors.purpleAccent, targetIndex: 2),
          PuzzlePiece(id: 'l2_p3', shape: CandyShape.heart, color: Colors.pinkAccent, targetIndex: 4),
          PuzzlePiece(id: 'l2_p4', shape: CandyShape.star, color: Colors.tealAccent, targetIndex: 5),
        ],
      ),
       Level(
        id: 3,
        rows: 3,
        cols: 3,
        name: "Level 3",
        pieces: [
          PuzzlePiece(id: 'l3_p1', shape: CandyShape.circle, color: Colors.red, targetIndex: 0),
          PuzzlePiece(id: 'l3_p2', shape: CandyShape.square, color: Colors.green, targetIndex: 2),
          PuzzlePiece(id: 'l3_p3', shape: CandyShape.triangle, color: Colors.blue, targetIndex: 4),
          PuzzlePiece(id: 'l3_p4', shape: CandyShape.heart, color: Colors.yellow, targetIndex: 6),
          PuzzlePiece(id: 'l3_p5', shape: CandyShape.star, color: Colors.purple, targetIndex: 8),
        ],
      ),
    ];
  }
}


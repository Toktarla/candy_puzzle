import 'dart:async';
import 'package:flutter/material.dart';
import '../models/game_models.dart';

class GameController extends ChangeNotifier {
  List<Level> get levels => LevelData.levels;
  
  int _completedLevels = 0;
  int get completedLevels => _completedLevels;

  Level? _currentLevel;
  Level? get currentLevel => _currentLevel;

  final Map<int, PuzzlePiece> _placedPieces = {};
  Map<int, PuzzlePiece> get placedPieces => Map.unmodifiable(_placedPieces);

  bool _isVictory = false;
  bool get isVictory => _isVictory;

  Timer? _timer;
  int _elapsedSeconds = 0;
  int get elapsedSeconds => _elapsedSeconds;
  
  String get formattedTime {
    final minutes = _elapsedSeconds ~/ 60;
    final seconds = _elapsedSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  int get placedPiecesCount => _placedPieces.length;
  
  int get totalPiecesCount => _currentLevel?.pieces.length ?? 0;

  void selectLevel(int levelId) {
    _stopTimer();
    _currentLevel = levels.firstWhere((l) => l.id == levelId);
    _placedPieces.clear();
    _isVictory = false;
    _elapsedSeconds = 0;
    _startTimer();
    notifyListeners();
  }

  void _startTimer() {
    _stopTimer();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isVictory) {
        _elapsedSeconds++;
        notifyListeners();
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void placePiece(int targetIndex, PuzzlePiece piece) {
    if (_currentLevel == null) return;
    
    if (piece.targetIndex == targetIndex) {
      _placedPieces[targetIndex] = piece;
      _checkVictory();
      notifyListeners();
    }
  }
  
  bool isPiecePlaced(PuzzlePiece piece) {
    return _placedPieces.containsValue(piece);
  }

  void _checkVictory() {
    if (_currentLevel == null) return;
    
    if (_placedPieces.length == _currentLevel!.pieces.length) {
      _isVictory = true;
      _stopTimer();
      if (_currentLevel!.id > _completedLevels) {
        _completedLevels = _currentLevel!.id;
      }
      notifyListeners();
    }
  }

  void resetLevel() {
    _placedPieces.clear();
    _isVictory = false;
    _elapsedSeconds = 0;
    notifyListeners();
  }

  void completeLevelAndReturn() {
    _stopTimer();
    _currentLevel = null;
    _placedPieces.clear();
    _isVictory = false;
    _elapsedSeconds = 0;
    notifyListeners();
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }
}


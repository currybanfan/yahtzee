import 'package:flutter/material.dart';

class GameStateNotifier extends ChangeNotifier {
  // 定義遊戲中所有可能的分數類型
  static const categories = [
    'ace',
    'twos',
    'threes',
    'fours',
    'fives',
    'sixes',
    'three_of_a_kind',
    'four_of_a_kind',
    'small',
    'large',
    'chance',
    'full',
    'yahtzee',
    'bonus',
  ];

  // 儲存每位玩家的分數板，每個分類的初始分數為0
  List<Map<String, int>> _playerScoreBoards =
      List.generate(2, (_) => {for (var category in categories) category: 0});

  // 儲存臨時分數，用於當前骰子組合的評分預測
  Map<String, int> _tempScores = {for (var category in categories) category: 0};

  // 儲存兩位玩家的總分
  List<int> _playerScores = [0, 0];
  // 紀錄當前操作的玩家（0 或 1）
  int _currentPlayer = 0;
  // 紀錄當前遊戲輪數
  int _round = 1;
  // 紀錄當前選擇的分數類型
  String _pickedCategory = '';
  // 遊戲是否結束的標誌
  bool _gameOver = false;

  // 公開讀取器，以獲得不可修改的玩家分數板
  List<Map<String, int>> get playerScoreBoards =>
      List.unmodifiable(_playerScoreBoards);
  Map<String, int> get tempScores => _tempScores;
  List<int> get playerScores => List.unmodifiable(_playerScores);
  int get currentPlayer => _currentPlayer;
  int get round => _round;
  String get pickedCategory => _pickedCategory;
  bool get gameOver => _gameOver;

  // 遊戲初始化方法，設置所有參數為初始狀態
  void initGame() {
    _gameOver = false;
    _currentPlayer = 0; // 開始時由玩家 1 開始
    _round = 1;
    _playerScores = List.filled(2, 0); // 重置玩家分數
    _playerScoreBoards = List.generate(
        2, (_) => {for (var category in categories) category: 0}); // 重置分數板
    _tempScores = {for (var category in categories) category: 0}; // 重置臨時分數

    notifyListeners(); // 通知聽眾更新
  }

  // 更新玩家選擇的分數類型
  void updatePickedCategory(String category) {
    _pickedCategory = category;
    notifyListeners(); // 更新數據後通知聽眾
  }

  // 根據骰子值和選擇的分數類型更新分數
  void updateScore(List<int> diceValues) {
    int score = calculateCategoryScore(_pickedCategory, diceValues);
    _playerScoreBoards[_currentPlayer][_pickedCategory] = score;
    _playerScores[_currentPlayer] += score;

    if (checkBonus()) {
      // 檢查是否達到獎勵條件
      _playerScoreBoards[_currentPlayer]['bonus'] = 35;
    }

    _nextPlayer(); // 換到下一位玩家
  }

  // 根據當前骰子值計算各類別的預測分數
  void calculateScore(List<int> diceValues) {
    for (var category in categories) {
      _tempScores[category] = calculateCategoryScore(category, diceValues);
    }
    notifyListeners();
  }

  // 根據骰子結果計算指定分數類型的分數
  int calculateCategoryScore(String category, List<int> diceValues) {
    switch (category) {
      case 'ace':
        return sumDiceByValue(diceValues, 1);
      case 'twos':
        return sumDiceByValue(diceValues, 2);
      case 'threes':
        return sumDiceByValue(diceValues, 3);
      // 其他類別類似...
      default:
        return 0;
    }
  }

  // 計算特定點數的骰子總和
  int sumDiceByValue(List<int> diceValues, int matchValue) {
    return diceValues.where((value) => value == matchValue).length * matchValue;
  }

  // 檢查是否有至少指定數量的相同點數骰子
  int checkXOfAKind(List<int> diceValues, {required int numberOfAKind}) {
    for (var value in diceValues) {
      if (diceValues.where((v) => v == value).length >= numberOfAKind) {
        return diceValues.reduce((v, sum) => sum += v);
      }
    }
    return 0;
  }

  // 檢查是否擲出了小順子
  bool checkSmallStraight(List<int> diceValues) {
    var diceValuesSet = diceValues.toSet();
    return diceValuesSet.containsAll([1, 2, 3, 4]) ||
        diceValuesSet.containsAll([2, 3, 4, 5]) ||
        diceValuesSet.containsAll([3, 4, 5, 6]);
  }

  // 檢查是否擲出了大順子
  bool checkLargeStraight(List<int> diceValues) {
    var diceValuesSet = diceValues.toSet();
    return diceValuesSet.containsAll([1, 2, 3, 4, 5]) ||
        diceValuesSet.containsAll([2, 3, 4, 5, 6]);
  }

  // 檢查是否擲出了滿堂紅（Full House）
  bool checkFullHouse(List<int> diceValues) {
    var diceValuesSet = diceValues.toSet();
    if (diceValuesSet.length != 2) return false;

    for (var value in diceValuesSet) {
      if (diceValues.where((v) => v == value).length == 3) {
        return true;
      }
    }
    return false;
  }

  // 檢查是否達到獎勵分數
  bool checkBonus() {
    const items = ['ace', 'twos', 'threes', 'fours', 'fives', 'sixes'];
    int total = 0;
    for (int i = 0; i < 6; i++) {
      String category = items[i];
      total += _playerScoreBoards[_currentPlayer][category]!;
    }
    return total >= 63;
  }

  // 檢查是否擲出了快艇（Yahtzee）
  bool checkYahtzee(List<int> diceValues) {
    return diceValues.every((value) => value == diceValues[0]);
  }

  // 切換到下一位玩家，如果所有回合結束則標記遊戲結束
  void _nextPlayer() {
    _currentPlayer = (_currentPlayer + 1) % 2;
    _tempScores = {for (var category in categories) category: 0};
    _pickedCategory = '';
    if (_currentPlayer == 0) _round += 1;
    if (_round > 13) _gameOver = true;

    notifyListeners(); // 通知聽眾狀態已更改
  }
}

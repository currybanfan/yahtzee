import 'package:flutter/material.dart';
import 'dice.dart'; // 導入 Dice 類別定義，可能包含骰子的基礎功能如擲骰。

class DiceNotifier extends ChangeNotifier {
  // 骰子列表，包含五個骰子，每個骰子初始值為 0。
  List<Dice> _diceList = List.generate(5, (_) => Dice(value: 0));

  // 紀錄擲骰次數。
  int _rollCount = 0;

  // 提供公開的 getter 方法來訪問骰子列表，返回不可修改的列表以確保狀態不被外部更改。
  List<Dice> get diceList => List.unmodifiable(_diceList);

  // 提供公開的 getter 方法來訪問擲骰次數。
  int get rollCount => _rollCount;

  // 初始化骰子，將所有骰子的值設定為 0 並重置擲骰次數。
  void initDice() {
    _rollCount = 0;
    _diceList = List.generate(5, (_) => Dice(value: 0));
    notifyListeners(); // 通知監聽器數據已更新。
  }

  // 擲骰，對每個骰子進行擲骰操作並增加擲骰次數。
  void rollDice() {
    for (var dice in diceList) {
      dice.roll(); // 調用 Dice 類別的 roll 方法來生成新的骰子值。
    }
    _rollCount++;
    notifyListeners(); // 通知監聽器數據已更新。
  }

  // 重置骰子，將所有骰子的值設定為 0 並重置擲骰次數。
  void resetDice() {
    _diceList = List.generate(5, (_) => Dice(value: 0));
    _rollCount = 0;
    notifyListeners(); // 通知監聽器數據已更新。
  }

  // 獲取所有骰子的值，返回一個包含所有骰子值的整數列表。
  List<int> getDiceValues() {
    return _diceList.map((dice) => dice.value).toList();
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dice_notifier.dart';
import 'game_state_notifier.dart';

class RollDiceButton extends StatelessWidget {
  const RollDiceButton({super.key}); // 構造函數，接收一個 key 參數

  void rollDice(BuildContext context) {
    // 從 Provider 獲取 GameStateNotifier 和 DiceNotifier 的實例，不監聽變化
    final gameState = Provider.of<GameStateNotifier>(context, listen: false);
    final dice = Provider.of<DiceNotifier>(context, listen: false);

    // 如果擲骰次數小於 3，則允許擲骰
    if (dice.rollCount < 3) {
      dice.rollDice(); // 調用 DiceNotifier 中的 rollDice 方法來擲骰

      List<int> diceValues = dice.getDiceValues(); // 從 DiceNotifier 獲取擲骰後的值
      gameState.calculateScore(diceValues); // 使用骰子值來計算可能的得分
    }
  }

  @override
  Widget build(BuildContext context) {
    // 使用 Consumer 監聽 DiceNotifier 的變化
    return Consumer<DiceNotifier>(
      builder: (context, dice, _) => ElevatedButton(
        onPressed: dice.rollCount < 3
            ? () => rollDice(context)
            : null, // 根據擲骰次數決定按鈕是否啟用
        child: const Text('Roll'), // 按鈕文本
      ),
    );
  }
}

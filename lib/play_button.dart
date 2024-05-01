import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dice_notifier.dart';
import 'game_state_notifier.dart';

class PlayButton extends StatelessWidget {
  const PlayButton({super.key}); // 構造函數，接收一個 key 參數

  void _playGame(BuildContext context) {
    // 從 Provider 獲取 GameStateNotifier 和 DiceNotifier 的實例，不監聽變化
    final gameState = Provider.of<GameStateNotifier>(context, listen: false);
    final dice = Provider.of<DiceNotifier>(context, listen: false);

    gameState.updateScore(dice.getDiceValues()); // 更新分數板的分數
    dice.resetDice(); // 重置骰子
  }

  @override
  Widget build(BuildContext context) {
    // 創建一個 ElevatedButton 組件
    return ElevatedButton(
      onPressed: () => _playGame(context), // 按鈕點擊時執行 _playGame 函數
      child: const Text('Play'), // 按鈕文本
    );
  }
}

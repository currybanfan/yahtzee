import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'game_state_notifier.dart';
import 'dice_notifier.dart';

class GameInfoWidget extends StatelessWidget {
  const GameInfoWidget({super.key}); // 構造函數，接收 key 參數

  @override
  Widget build(BuildContext context) {
    // 使用 Consumer 組件監聽 GameStateNotifier，當狀態發生變化時自動重建界面
    return Consumer<GameStateNotifier>(
      builder: (context, gameState, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center, // 子元素垂直居中對齊
          children: [
            Stack(
              // 堆疊布局，用於重疊放置多個元素
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20), // 在左邊增加 20 單位的內邊距
                    child: _buildReStartButton(context), // 呼叫重置遊戲按鈕構建函數
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: _buildRoundInfo(gameState.round), // 顯示當前輪次信息
                ),
              ],
            ),
            const SizedBox(
              height: 15.0, // 增加垂直間距
            ),
            Row(
              // 水平布局，展示玩家分數
              mainAxisAlignment: MainAxisAlignment.spaceEvenly, // 子元素均勻分布
              children: [
                _buildPlayerScore('Player1', gameState.playerScores[0],
                    gameState.currentPlayer == 0), // 玩家一的分數展示
                _buildPlayerScore('Player2', gameState.playerScores[1],
                    gameState.currentPlayer == 1), // 玩家二的分數展示
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildPlayerScore(String player, int score, bool highlight) {
    // 定義正常和高亮狀態下的顏色和樣式
    Color normalBoxColor = const Color.fromARGB(255, 208, 202, 202); // 正常框背景色
    Color heightlightBoxColor = Colors.white; // 高亮框背景色

    Color normalBorder = const Color.fromARGB(255, 72, 69, 69); // 正常框邊框色
    Color heightlightBorder = Colors.blue; // 高亮框邊框色

    Color textShaderBegin = const Color.fromARGB(255, 30, 151, 250); // 文字漸變開始色
    Color textShaderEnd = const Color.fromARGB(255, 0, 82, 55); // 文字漸變結束色

    return Container(
      height: 40,
      width: 160,
      decoration: BoxDecoration(
        color: highlight ? heightlightBoxColor : normalBoxColor, // 根據高亮狀態選擇背景色
        border: Border.all(
            color: highlight ? heightlightBorder : normalBorder), // 選擇邊框顏色
        borderRadius: BorderRadius.circular(8.0), // 圓角設計
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400,
            spreadRadius: -5,
            blurRadius: 15,
            offset: const Offset(0, 6), // 陰影偏移，增加立體感
          )
        ],
      ),
      padding: const EdgeInsets.all(8.0), // 內邊距
      child: ShaderMask(
        shaderCallback: (Rect bounds) {
          return LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              textShaderBegin,
              textShaderEnd,
            ],
          ).createShader(bounds);
        },
        child: Text(
          '$player Score: $score', // 顯示玩家名稱和分數
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildRoundInfo(int round) {
    // 顯示當前輪次信息
    return Text(
      'ROUND: $round/13',
      style: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.normal,
        foreground: Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5
          ..color = const Color.fromARGB(255, 184, 219, 238), // 邊框式文本
      ),
    );
  }

  Widget _buildReStartButton(BuildContext context) {
    // 建立重啟遊戲按鈕
    return Container(
      width: 30, // 方形外框的寬度
      height: 30, // 方形外框的高度
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 23, 175, 213), // 按鈕背景色
        border: Border.all(color: Colors.white, width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: -2,
            blurRadius: 4,
            offset: const Offset(0, 6), // 陰影設定，增加立體感
          ),
        ],
        borderRadius: BorderRadius.circular(8), // 圓角設計
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            final gameState =
                Provider.of<GameStateNotifier>(context, listen: false);
            final dice = Provider.of<DiceNotifier>(context, listen: false);

            gameState.initGame(); // 初始化遊戲狀態
            dice.initDice(); // 初始化骰子狀態
          },
          borderRadius: BorderRadius.circular(8),
          child: const Icon(Icons.restart_alt_outlined), // 重啟圖標
        ),
      ),
    );
  }
}

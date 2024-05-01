import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'game_state_notifier.dart';

class GameOverPage extends StatelessWidget {
  final List<int> score; // 儲存兩位玩家的分數列表

  const GameOverPage({super.key, required this.score}); // 構造函數，接收分數

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 主軸為垂直方向並居中
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround, // 子元素均勻分布
              children: [
                buildPlayerScore(
                    "Player 1", score[0] > score[1], score[0]), // 建立玩家1的分數顯示
                buildPlayerScore(
                    "Player 2", score[0] < score[1], score[1]), // 建立玩家2的分數顯示
              ],
            ),
            const SizedBox(height: 50), // 垂直間隔
            ElevatedButton(
              onPressed: () {
                final gameState =
                    Provider.of<GameStateNotifier>(context, listen: false);
                gameState.initGame(); // 重置遊戲狀態
                Navigator.pop(context); // 返回上一頁
              },
              child: const Text('重新開始'), // 按鈕文字
            )
          ],
        ),
      ),
    );
  }

  Widget buildPlayerScore(String player, bool win, int score) {
    const Color winnerColor = Color(0xFFFFDF00); // 勝利者的顏色（金色）
    const Color loserColor = Colors.white; // 輸家的顏色（白色）

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          player,
          style: TextStyle(
            fontFamily: 'Arial', // 字體
            color: win ? winnerColor : loserColor, // 根據是否勝利選擇顏色
            fontWeight: FontWeight.bold, // 粗體
            fontSize: 24, // 字體大小
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Container(
          height: 50,
          width: 150,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center, // 漸變中心
              radius: 1.0, // 漸變半徑
              colors: [
                Colors.grey[700]!, // 從灰色漸變到更深的灰色
                Colors.grey[800]!,
                Colors.grey[850]!,
                Colors.grey[900]!,
              ],
              stops: const [0.0, 0.3, 0.7, 1.0], // 漸變的具體位置
            ),
            borderRadius: BorderRadius.circular(30), // 圓角
          ),
          child: Center(
            child: Text(
              '$score',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: win ? winnerColor : loserColor, // 文字顏色
              ),
            ),
          ),
        ),
      ],
    );
  }
}

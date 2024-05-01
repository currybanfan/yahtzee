import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'game_state_notifier.dart';

class ScoreBoard extends StatelessWidget {
  ScoreBoard({super.key});

  // 分數類別的列表，包含所有遊戲中的分數類型和相應圖標
  final List<ScoreCategory> scoreCategories = [
    ScoreCategory(id: 'ace', name: '一點', icon: Icons.looks_one),
    ScoreCategory(id: 'twos', name: '二點', icon: Icons.looks_two),
    ScoreCategory(id: 'threes', name: '三點', icon: Icons.looks_3),
    ScoreCategory(id: 'fours', name: '四點', icon: Icons.looks_4),
    ScoreCategory(id: 'fives', name: '五點', icon: Icons.looks_5),
    ScoreCategory(id: 'sixes', name: '六點', icon: Icons.looks_6),
    ScoreCategory(id: 'bonus', name: '獎勵', icon: Icons.add),
    ScoreCategory(id: 'three_of_a_kind', name: '三條', icon: Icons.filter_3),
    ScoreCategory(id: 'four_of_a_kind', name: '四條', icon: Icons.filter_4),
    ScoreCategory(id: 'small', name: '小順', icon: Icons.linear_scale),
    ScoreCategory(id: 'large', name: '大順', icon: Icons.show_chart),
    ScoreCategory(id: 'chance', name: '全選', icon: Icons.casino),
    ScoreCategory(id: 'full', name: '葫蘆', icon: Icons.house),
    ScoreCategory(id: 'yahtzee', name: '快艇', icon: Icons.stars),
  ];

  @override
  Widget build(BuildContext context) {
    // 建立一個垂直布局，列出所有分數類別
    return Column(
      children: List<Widget>.generate(scoreCategories.length, (index) {
        var category = scoreCategories[index];
        return ScoreRow(category: category); // 創建每個分數類別的行
      }),
    );
  }
}

class ScoreRow extends StatelessWidget {
  final ScoreCategory category; // 接收一個分數類別作為參數

  const ScoreRow({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameStateNotifier>(
      builder: (context, gameState, child) {
        int tempScore = gameState.tempScores[category.id]!; // 從遊戲狀態獲取臨時分數

        int score1 = gameState.playerScoreBoards[0][category.id]!;
        int score2 = gameState.playerScoreBoards[1][category.id]!;
        bool isCurrentPlayer1 = gameState.currentPlayer == 0; // 當前是否是玩家1
        bool isCurrentPlayer2 = gameState.currentPlayer == 1; // 當前是否是玩家2
        bool pickable1 = false;
        bool pickable2 = false;

        if (score1 == 0 && isCurrentPlayer1 && tempScore != 0) {
          pickable1 = true; // 玩家1可以選擇這個分數類別
          score1 = tempScore; // 展示臨時計算的分數
        } else if (score2 == 0 && isCurrentPlayer2 && tempScore != 0) {
          pickable2 = true; // 玩家2可以選擇這個分數類別
          score2 = tempScore;
        }

        bool isSelected =
            gameState.pickedCategory == category.id; // 是否已選擇這個分數類別

        return GestureDetector(
          onTap: pickable1 || pickable2
              ? () => gameState.updatePickedCategory(category.id) // 選擇分數類別的動作
              : null,
          child: Container(
            height: 28,
            margin: const EdgeInsets.symmetric(vertical: 1.0),
            decoration: BoxDecoration(
              // 設定背景漸變和邊框
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: isSelected
                    ? [
                        Colors.lightBlueAccent,
                        const Color.fromARGB(255, 16, 195, 255)
                      ]
                    : [
                        const Color.fromARGB(255, 129, 169, 239),
                        const Color.fromARGB(255, 13, 142, 182)
                      ],
              ),
              border: Border.all(
                color: isSelected
                    ? Colors.yellow
                    : Colors.transparent, // 選擇時顯示黃色邊框
                width: 2,
              ),
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: -1,
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(category.icon),
                Text(category.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    )),
                ScoreDisplay(
                  score: score1,
                  pickable: pickable1,
                ),
                ScoreDisplay(
                  score: score2,
                  pickable: pickable2,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ScoreDisplay extends StatelessWidget {
  final int score; // 分數值
  final bool pickable; // 是否可選擇

  const ScoreDisplay({
    super.key,
    required this.score,
    required this.pickable,
  });

  static const TextStyle selectableTextStyle = TextStyle(
      color: Colors.yellow, // 明亮且吸引注意的顏色
      fontSize: 14.0, // 適中的字體大小
      fontWeight: FontWeight.bold // 粗體，突出可選性
      );
  static const TextStyle unselectableTextStyle = TextStyle(
      color: Colors.black, // 淡色，表示不可選
      fontSize: 14.0, // 與可選擇相同的字體大小保持一致性
      fontWeight: FontWeight.w400 // 正常粗細，不突出
      );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 25.0,
      child: Text(
        score.toString(),
        style: pickable ? selectableTextStyle : unselectableTextStyle,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class ScoreCategory {
  final String id;
  final String name;
  final IconData icon;

  ScoreCategory({required this.id, required this.name, required this.icon});
}

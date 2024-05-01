import 'package:flutter/material.dart';
import 'dice_notifier.dart';
import 'package:provider/provider.dart';
import 'game_state_notifier.dart';
import 'game_info.dart';
import 'dice.dart';
import 'score_board.dart';
import 'play_button.dart';
import 'roll_dice_button.dart';
import 'game_over_page.dart';

ThemeData lightTheme() {
  return ThemeData(
    primaryColor: const Color.fromARGB(255, 2, 42, 38), // 主色調，設為深綠色
    brightness: Brightness.light, // 主題亮度，設為淺色模式
    textTheme: const TextTheme(
      // 文字主題設定
      bodyMedium: TextStyle(
        // 用於主要文本的風格
        fontFamily: 'Arial', // 字體
        color: Color.fromARGB(255, 48, 48, 48), // 文本顏色，深灰色
        fontSize: 18, // 字體大小
      ),
      titleLarge: TextStyle(
        // 標題文本的風格
        fontFamily: 'Arial',
        fontSize: 18,
        fontWeight: FontWeight.bold, // 粗體
        color: Colors.black, // 文本顏色，黑色
      ),
      labelLarge: TextStyle(
        // 標籤文本的風格
        fontFamily: 'Arial',
        fontSize: 16,
        color: Color(0xFF40E0D0), // 使用蒂芙尼藍作為顏色
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      // 提升按鈕的主題設定
      style: ButtonStyle(
        // 按鈕風格設定
        foregroundColor: MaterialStateProperty.resolveWith<Color?>(
          // 文字顏色
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled)) {
              return Colors.grey[700]; // 禁用時的文字顏色，深灰色
            }
            return const Color.fromARGB(255, 2, 100, 175); // 啟用時的文字顏色，深藍色
          },
        ),
        textStyle:
            MaterialStateProperty.resolveWith((Set<MaterialState> states) {
          // 文字風格
          return const TextStyle(
            fontFamily: 'Arial',
            fontSize: 18,
            fontWeight: FontWeight.bold, // 粗體
          );
        }),
        backgroundColor:
            MaterialStateProperty.resolveWith((Set<MaterialState> states) {
          // 按鈕背景色
          if (states.contains(MaterialState.disabled)) {
            return Colors.grey; // 禁用時背景色為灰色
          }
          return Colors.white; // 可用時背景色為白色
        }),
        fixedSize:
            MaterialStateProperty.all(const Size.fromHeight(45)), // 按鈕大小固定
        shadowColor: MaterialStateProperty.all(Colors.black), // 陰影顏色
        elevation: MaterialStateProperty.all(10), // 陰影高度
      ),
    ),
    scaffoldBackgroundColor:
        const Color.fromARGB(82, 2, 230, 192), // Scaffold的背景顏色，淡綠色
  );
}

void main() {
  runApp(
    // 使用MultiProvider來管理多個狀態
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => GameStateNotifier()),
        ChangeNotifierProvider(create: (context) => DiceNotifier()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const DiceGame(),
      theme: lightTheme(),
    );
  }
}

class DiceGame extends StatefulWidget {
  const DiceGame({super.key});

  @override
  DiceGameState createState() => DiceGameState();
}

class DiceGameState extends State<DiceGame> {
  GameStateNotifier? gameState; // 遊戲狀態管理器
  DiceNotifier? dice; // 骰子狀態管理器

  @override
  void initState() {
    super.initState();
    // 通過Provider獲取狀態管理器實例，不監聽變化
    gameState = Provider.of<GameStateNotifier>(context, listen: false);
    dice = Provider.of<DiceNotifier>(context, listen: false);

    // 在頁面首次渲染後初始化遊戲和骰子狀態
    WidgetsBinding.instance.addPostFrameCallback((_) {
      gameState!.initGame();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      dice!.initDice();
    });

    // 監聽遊戲結束狀態
    gameState!.addListener(checkGameOver);
  }

  @override
  void dispose() {
    // 移除監聽器並清理資源
    gameState?.removeListener(checkGameOver);
    super.dispose();
  }

  // 檢查遊戲是否結束並導航到遊戲結束頁面
  void checkGameOver() {
    if (gameState!.gameOver) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => GameOverPage(score: gameState!.playerScores),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 40.0),
          const GameInfoWidget(), // 顯示遊戲資訊的組件
          const SizedBox(height: 10.0),
          Expanded(
            flex: 8,
            child: ScoreBoard(), // 顯示遊戲得分板
          ),
          const DiceTray(), // 顯示骰子托盤
          const Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RollDiceButton(), // 自定義的擲骰按鈕
                PlayButton(), // 自定義的遊玩按鈕
              ],
            ),
          ),
          const SizedBox(height: 10.0),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'package:dice_icons/dice_icons.dart';
import 'dice_notifier.dart';

class Dice {
  int value; // 骰子的點數
  bool isLocked; // 骰子是否被鎖定，不進行擲骰

  Dice({this.value = 0, this.isLocked = false}); // 構造函數，初始化點數為 0，未鎖定

  // 生成一個新的骰子點數
  void roll() {
    if (!isLocked) {
      // 如果骰子未被鎖定
      value = Random().nextInt(6) + 1; // 生成 1 到 6 的隨機數
    }
  }
}

class DiceTray extends StatelessWidget {
  const DiceTray({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween, // 元素間隔均勻分布
      children: Provider.of<DiceNotifier>(context)
          .diceList
          .map((dice) => Expanded(
                // 使用 Expanded 使得每個 DiceWidget 平分寬度
                child: AspectRatio(
                  // 使用 AspectRatio 保持正方形
                  aspectRatio: 1, // 比例 1:1 保持正方形
                  child: DiceWidget(dice: dice),
                ),
              ))
          .toList(),
    );
  }
}

class DiceWidget extends StatefulWidget {
  final Dice dice; // 接收一個骰子對象作為參數

  const DiceWidget({super.key, required this.dice});

  @override
  DiceWidgetState createState() => DiceWidgetState();
}

class DiceWidgetState extends State<DiceWidget> {
  static List<Widget> diceIcons = [
    Container(
      color: Colors.grey, // 默認容器，用於未決定骰子點數時顯示
    ),
    const Icon(DiceIcons.dice1), // 使用 DiceIcons 庫顯示骰子 1 到 6 的圖標
    const Icon(DiceIcons.dice2),
    const Icon(DiceIcons.dice3),
    const Icon(DiceIcons.dice4),
    const Icon(DiceIcons.dice5),
    const Icon(DiceIcons.dice6),
  ];

  void toggleLock() {
    setState(() {
      widget.dice.isLocked = !widget.dice.isLocked; // 切換骰子的鎖定狀態
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggleLock, // 點擊時切換骰子鎖定狀態
      child: Container(
        margin: const EdgeInsets.all(8), // 添加邊距
        decoration: BoxDecoration(
          color: widget.dice.value == 0
              ? Colors.grey[300]
              : Colors.white, // 根據骰子值設置背景顏色
          border: Border.all(
              color: widget.dice.isLocked
                  ? const Color(0xFFFFDF00)
                  : Colors.black, // 鎖定狀態用金色邊框，否則用黑色
              width: 2),
        ),
        child: FittedBox(
          fit: BoxFit.contain, // 內容盡可能填滿容器而不變形
          child: diceIcons[widget.dice.value], // 顯示對應的骰子圖標
        ),
      ),
    );
  }
}

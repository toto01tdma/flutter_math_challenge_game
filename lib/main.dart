import 'dart:async'; // นำเข้า Timer
import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(MathChallengeApp());

class MathChallengeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MathGamePage(),
    );
  }
}

class MathGamePage extends StatefulWidget {
  @override
  _MathGamePageState createState() => _MathGamePageState();
}

class _MathGamePageState extends State<MathGamePage> {
  int num1 = 0;
  int num2 = 0;
  int score = 0;
  String question = "";
  List<int> options = [];
  int correctAnswer = 0;
  int timeLeft = 10; // เริ่มต้นที่ 10 วินาที
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    generateQuestion();
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        timeLeft--;
      });
      if (timeLeft == 0) {
        timer.cancel();
        showGameOverDialog(); // แสดงผลเมื่อเวลาหมด
      }
    });
  }

  void generateQuestion() {
    final random = Random();
    num1 = random.nextInt(10) + 1; // ตัวเลข 1-10
    num2 = random.nextInt(10) + 1;
    correctAnswer = num1 + num2;
    options = List.generate(3, (_) => random.nextInt(20));
    options[random.nextInt(3)] = correctAnswer; // ใส่คำตอบที่ถูกต้อง
    setState(() {
      question = "$num1 + $num2 = ?";
      timeLeft = 10; // รีเซ็ตเวลาเมื่อเริ่มคำถามใหม่
    });
  }

  void checkAnswer(int answer) {
    if (answer == correctAnswer) {
      score++;
    } else {
      score--;
    }
    generateQuestion();
  }

  void showGameOverDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Game Over"),
        content: Text("Your score: $score"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              resetGame();
            },
            child: Text("Play Again"),
          ),
        ],
      ),
    );
  }

  void resetGame() {
    setState(() {
      score = 0;
      timeLeft = 10;
      generateQuestion();
      startTimer();
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // ยกเลิก Timer เมื่อ Widget ถูกลบ
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Math Challenge")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Score: $score", style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            Text("Time Left: $timeLeft",
                style: TextStyle(fontSize: 24, color: Colors.red)),
            SizedBox(height: 20),
            Text(question, style: TextStyle(fontSize: 32)),
            SizedBox(height: 20),
            Wrap(
              spacing: 10,
              children: options.map((option) {
                return ElevatedButton(
                  onPressed: () => checkAnswer(option),
                  child: Text("$option", style: TextStyle(fontSize: 20)),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

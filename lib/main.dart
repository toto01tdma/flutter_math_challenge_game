import 'dart:async'; // นำเข้า Timer
import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(MathChallengeApp());

class MathChallengeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LevelSelectionPage(),
    );
  }
}

class LevelSelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Difficulty Level")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Choose a difficulty level:", style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MathGamePage(timeLimit: 30),
                  ),
                );
              },
              child: Text("Easy (30 seconds)", style: TextStyle(fontSize: 18)),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MathGamePage(timeLimit: 20),
                  ),
                );
              },
              child:
                  Text("Medium (20 seconds)", style: TextStyle(fontSize: 18)),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MathGamePage(timeLimit: 10),
                  ),
                );
              },
              child: Text("Hard (10 seconds)", style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}

class MathGamePage extends StatefulWidget {
  final int timeLimit;

  MathGamePage({required this.timeLimit});

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
  int timeLeft = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    timeLeft = widget.timeLimit; // กำหนดเวลาตามระดับที่เลือก
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
      timeLeft = widget.timeLimit; // รีเซ็ตเวลาเมื่อเริ่มคำถามใหม่
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
              Navigator.of(context).pop(); // ย้อนกลับไปยังหน้าเลือกระดับ
            },
            child: Text("Back to Level Selection"),
          ),
        ],
      ),
    );
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

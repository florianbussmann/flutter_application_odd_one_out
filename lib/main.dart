import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(OddOneOutApp());
}

class OddOneOutApp extends StatelessWidget {
  const OddOneOutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Odd One Out',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: OddOneOutGame(),
    );
  }
}

class OddOneOutGame extends StatefulWidget {
  const OddOneOutGame({super.key});

  @override
  State<OddOneOutGame> createState() => _OddOneOutGameState();
}

class _OddOneOutGameState extends State<OddOneOutGame> {
  final Random _rand = Random();
  List<int> _numbers = [];
  int _oddIndex = 0;
  int _score = 0;
  final String _rule = "Multiples of 4";

  @override
  void initState() {
    super.initState();
    _generateRound();
  }

  void _generateRound() {
    List<int> nums = [];
    _oddIndex = _rand.nextInt(3);

    for (int i = 0; i < 3; i++) {
      if (i == _oddIndex) {
        // Not multiple of 4
        int n;
        do {
          n = _rand.nextInt(50) + 1;
        } while (n % 4 == 0);
        nums.add(n);
      } else {
        // Multiple of 4
        int n = (_rand.nextInt(12) + 1) * 4;
        nums.add(n);
      }
    }

    setState(() {
      _numbers = nums;
    });
  }

  void _checkAnswer(int index) {
    if (index == _oddIndex) {
      setState(() => _score++);
    } else {
      setState(() => _score = max(0, _score - 1));
    }
    _generateRound();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Odd One Out - Score: $_score')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_rule, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            for (int i = 0; i < _numbers.length; i++)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () => _checkAnswer(i),
                  child: Text(
                    _numbers[i].toString(),
                    style: TextStyle(fontSize: 28),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
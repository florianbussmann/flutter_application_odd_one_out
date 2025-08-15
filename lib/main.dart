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
  String _rule = "";

  final List<MathRule> _rules = [
    MathRule("Multiples of 4", (n) => n % 4 == 0),
    MathRule("Prime numbers", (n) {
      if (n < 2) return false;
      for (int i = 2; i <= n ~/ 2; i++) {
        if (n % i == 0) return false;
      }
      return true;
    }),
    MathRule("Even numbers", (n) => n % 2 == 0),
    MathRule("Odd numbers", (n) => n % 2 != 0),
    MathRule("Multiples of 3", (n) => n % 3 == 0),
  ];

  @override
  void initState() {
    super.initState();
    _generateRound();
  }

  void _generateRound() {
    _oddIndex = _rand.nextInt(3);
    MathRule currentRule = _rules[_rand.nextInt(_rules.length)];

    Set<int> numsSet = {};
    for (int i = 0; i < 3; i++) {
      if (i == _oddIndex) {
        // Generate a number that does NOT match the rule and is unique
        int n;
        do {
          n = _rand.nextInt(50) + 1;
        } while (currentRule.match(n) || numsSet.contains(n));
        numsSet.add(n);
      } else {
        // Generate a number that matches the rule and is unique
        int n;
        do {
          n = _rand.nextInt(50) + 1;
        } while (!currentRule.match(n) || numsSet.contains(n));
        numsSet.add(n);
      }
    }

    setState(() {
      _numbers = numsSet.toList();
      _rule = currentRule.description;
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
            Text(
              _rule,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
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

class MathRule {
  final String description;
  final bool Function(int) match;

  MathRule(this.description, this.match);
}

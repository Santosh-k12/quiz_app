// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/screens/result_screen.dart';
import 'package:quiz_app/widgets/quiz.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = 'HomeScreen';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  final _questions = const [
    {
      'questionText': 'Q1. Who is Naruto?',
      'answers': [
        {'text': 'Samurai', 'score': -2},
        {'text': 'Ninja', 'score': 10},
        {'text': 'NBA All-Star', 'score': -2},
        {'text': 'Sumo', 'score': -2},
      ],
      'image': 'assets/naruto.png',
    },
    {
      'questionText': 'Q2. Which team does the character "Ino" belong to?',
      'answers': [
        {'text': 'Team 12', 'score': -2},
        {'text': 'Team 7', 'score': -2},
        {'text': 'Team 6 ', 'score': -2},
        {'text': 'Team 10', 'score': 10},
      ],
      'image': 'assets/ino.png',
    },
    {
      'questionText':
          ' Q3. Who is this character paired up with in his first appearance?',
      'answers': [
        {'text': 'Kisame', 'score': -2},
        {'text': 'Sasori', 'score': 10},
        {'text': 'Itachi', 'score': -2},
        {'text': 'Orochimaru', 'score': -2},
      ],
      'image': 'assets/katsu.png',
    },
    {
      'questionText': 'Q4. Who did the character "jiraiya" train?',
      'answers': [
        {'text': 'Lars Bak and Kasper Lund', 'score': 10},
        {'text': 'Naruto', 'score': 10},
        {'text': 'Sasuke', 'score': -2},
        {'text': 'Tsunade', 'score': -2},
      ],
      'image': 'assets/jiraiya.png',
    },
    {
      'questionText': 'Q5. How did the character "Itachi" die?',
      'answers': [
        {'text': 'Cancer', 'score': -2},
        {'text': 'Battle', 'score': 10},
        {'text': 'Suicide', 'score': -2},
        {'text': 'Over-training', 'score': -2},
      ],
      'image': 'assets/itachi.png',
    },
  ];

  var _questionIndex = 0;
  var _totalScore = 0;

  void _resetQuiz() {
    setState(() {
      _questionIndex = 0;
      _totalScore = 0;
    });
  }

  void _answerQuestion(int score) {
    _totalScore += score;

    setState(() {
      _questionIndex = _questionIndex + 1;
    });
    print(_questionIndex);
    if (_questionIndex < _questions.length) {
      print('We have more questions!');
    } else {
      print('No more questions!');
    }
  }

  final CollectionReference collection =
      FirebaseFirestore.instance.collection('quiz-questions');

  Future<void> getData() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await collection.get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    print(allData);
  }

  @override
  Widget build(BuildContext context) {
    getData();
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.yellow, Colors.orange, Colors.deepOrange])),
          child: Column(
            children: [
              _questionIndex < _questions.length
                  ? Container(
                      height: MediaQuery.of(context).size.height * 0.6,
                      decoration: BoxDecoration(
                        // border: Border.all(color: Colors.black, width: 2),
                        image: DecorationImage(
                          fit: BoxFit.contain,
                          image: AssetImage(
                            _questions[_questionIndex]['image'].toString(),
                          ),
                        ),
                      ),
                    )
                  : Container(),
              _questionIndex < _questions.length
                  ? Quiz(
                      answerQuestion: _answerQuestion,
                      questionIndex: _questionIndex,
                      questions: _questions,
                    )
                  : Result(_totalScore, _resetQuiz),
            ],
          ),
        ),
      ),
    );
  }
}

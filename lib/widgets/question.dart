import 'package:flutter/material.dart';
import 'package:quiz_app/widgets/button.dart';

class Question extends StatelessWidget {
  final String questionText;

  const Question(this.questionText, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
        // Container(
        //   width: double.infinity,
        //   margin: const EdgeInsets.all(10),
        //   child: Text(
        //     questionText,
        //     style: const TextStyle(fontSize: 28),
        //     textAlign: TextAlign.center,
        //   ),
        // );
        SizedBox(
      width: double.infinity,
      child: FancyButton(
        child: Text(
          questionText,
          style: TextStyle(fontSize: 18),
        ),
        size: 25,
        color: Colors.blue,
      ),
    );
  }
}

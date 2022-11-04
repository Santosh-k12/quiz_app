import 'package:flutter/material.dart';
import 'package:quiz_app/widgets/button.dart';

class Answer extends StatelessWidget {
  final void Function()? selectHandler;
  final String answerText;

  const Answer(this.selectHandler, this.answerText, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child:
          //  ElevatedButton(
          //   onPressed: selectHandler,
          //   style: ButtonStyle(
          //       textStyle:
          //           MaterialStateProperty.all(const TextStyle(color: Colors.white)),
          //       backgroundColor: MaterialStateProperty.all(Colors.green)),
          //   child: Text(answerText),
          // ),
          FancyButton(
        child: Text(
          answerText,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontFamily: 'Gameplay',
          ),
        ),
        size: 25,
        color: Colors.orange,
        onPressed: selectHandler,
      ),
    );
  }
}

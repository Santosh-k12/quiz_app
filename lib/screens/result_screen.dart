// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/provider/sign_in_provider.dart';

class Result extends StatelessWidget {
  final int resultScore;
  final void Function()? resetHandler;

  Result(this.resultScore, this.resetHandler, {Key? key}) : super(key: key);

  String get resultPhrase {
    String resultText;
    if (resultScore >= 41) {
      resultText = 'You are awesome!';
      print(resultScore);
    } else if (resultScore >= 31) {
      resultText = 'Pretty likeable!';
      print(resultScore);
    } else if (resultScore >= 21) {
      resultText = 'You need to work more!';
    } else if (resultScore >= 1) {
      resultText = 'You need to work hard!';
    } else {
      resultText = 'This is a poor score!';
      print(resultScore);
    }
    return resultText;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SigninProvider>(builder: (context, loginConsumer, child) {
      loginConsumer.getData();
      loginConsumer.addScore(
        {
          'useId': loginConsumer.profileName,
          'score': resultScore,
          'date': DateTime.now(),
        },
      );
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                resultPhrase,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                '${loginConsumer.profileName}, your score is ' '$resultScore',
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue[900],
                ),
                onPressed: resetHandler,
                child: const Text(
                  'Restart Quiz',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Expanded(
                child: FutureBuilder(
                    future: loginConsumer.getData(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        print('kkkkk ${snapshot.data}');
                        if (snapshot.data != 0) {
                          return ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: ((context, index) => Card(
                                  child: ListTile(
                                    tileColor: Colors.deepOrange,
                                    leading: Text((index + 1).toString(),
                                        style: TextStyle(color: Colors.white)),
                                    title: Row(
                                      children: [
                                        Text(
                                            '${snapshot.data[index]['score'].toString()} pts',
                                            style:
                                                TextStyle(color: Colors.white)),
                                        Spacer(),
                                        Text(
                                            snapshot.data[index]['date']
                                                .toDate()
                                                .toString()
                                                .substring(0, 11),
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ],
                                    ),
                                  ),
                                )),
                          );
                        } else {
                          return Container();
                        }
                      } else {
                        return CircularProgressIndicator.adaptive();
                      }
                    }),
              ),
            ],
          ),
        ),
      );
    });
  }
}

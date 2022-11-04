// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/provider/login_provider.dart';

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

  final CollectionReference collection =
      FirebaseFirestore.instance.collection('user-score');
  Future<DocumentReference> addScore(dynamic score) {
    return collection.add(score);
  }

  Future<List> getData() async {
    QuerySnapshot querySnapshot = await collection.get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    print('sssssss${allData}');
    return allData;
  }

  @override
  Widget build(BuildContext context) {
    getData();
    return Consumer<LoginProvider>(builder: (context, loginConsumer, child) {
      addScore(
        {
          'useId': loginConsumer.profileName,
          'score': resultScore,
          'date': DateTime.now(),
        },
      );
      return Center(
        child: Container(
          height: MediaQuery.of(context).size.height,
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
                    future: getData(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.data != 0) {
                          return ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: ((context, index) => Card(
                                  child: ListTile(
                                    tileColor: Colors.white,
                                    leading: Text((index + 1).toString()),
                                    title: Row(
                                      children: [
                                        Text(
                                          snapshot.data[index]['score']
                                              .toString(),
                                        ),
                                        Spacer(),
                                        Text(
                                          snapshot.data[index]['date']
                                              .toDate()
                                              .toString()
                                              .substring(0, 11),
                                        ),
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

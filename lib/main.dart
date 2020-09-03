import 'package:flutter/material.dart';
import 'quiz_brain.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

QuizBrain quizBrain = QuizBrain();
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quizzy',
      home: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Quizzy(),
          ),
        ),
      ),
    );
  }
}

class Quizzy extends StatefulWidget {
  @override
  _QuizzyState createState() => _QuizzyState();
}

class _QuizzyState extends State<Quizzy> {
  List<Widget> scoreKeeper = [];
  var score = 0;
  var alertStyle = AlertStyle(
    animationType: AnimationType.grow,
    animationDuration: Duration(milliseconds: 400),
    alertBorder: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(color: Colors.grey),
    ),
  );
  void alert() {
    Alert(
      context: context,
      style: alertStyle,
      type: AlertType.error,
      title: 'You were correct $score/13 times',
      desc: 'You have reached the end of quiz',
      buttons: [
        DialogButton(
          child: Text("Reset the quiz!"),
          onPressed: () => Navigator.pop(context),
        )
      ],
    ).show();
    score = 0;
    quizBrain.reset();
    scoreKeeper.clear();
  }

  void checkAnswer(bool userPickedAnswer) {
    setState(
      () {
        if (!quizBrain.isFinished()) {
          bool correctAnswer = quizBrain.getQuestionAnswer();
          if (correctAnswer == userPickedAnswer) {
            if (quizBrain.checkRange()) {
              scoreKeeper.add(correct());
              score++;
            }
          } else {
            if (quizBrain.checkRange()) scoreKeeper.add(wrong());
          }
          quizBrain.nextQuestion();
        } else {
          alert();
        }
      },
    );
  }

  Widget correct() {
    return Icon(
      Icons.check,
      color: Colors.teal,
    );
  }

  Widget wrong() {
    return Icon(
      Icons.clear,
      color: Colors.red,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                quizBrain.getQuestionText(),
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 200,
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                'True',
                style: TextStyle(fontSize: 20, color: Colors.green[50]),
              ),
              color: Colors.green,
              onPressed: () {
                checkAnswer(true);
              },
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                'False',
                style: TextStyle(fontSize: 20, color: Colors.red[50]),
              ),
              color: Colors.red,
              onPressed: () {
                checkAnswer(false);
              },
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          children: scoreKeeper,
        )
      ],
    );
  }
}

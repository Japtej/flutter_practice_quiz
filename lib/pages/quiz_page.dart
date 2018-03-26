import 'package:flutter/material.dart';

import '../utils/quiz.dart';
import '../utils/question.dart';
import '../UI/answer_button.dart';
import '../UI/question_text.dart';
import '../UI/quiz_overlay.dart';
import '../pages/score_page.dart';

class QuizPage extends StatefulWidget{
  @override
  State createState() => new QuizPageState();
}

class QuizPageState extends State<QuizPage>{

  Question currentQuestion;
  Quiz quiz = new Quiz([
    new Question("Is 2+2 = 4?", true),
    new Question("Is this quiz tough?", false),
    new Question("Is flutter cool?", true)
  ]);
  String questionText;
  int questionNumber;
  bool isCorrect;
  bool overlayVisible = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentQuestion = quiz.nextQuestion;
    questionText = currentQuestion.question;
    questionNumber = quiz.questionNumber;

  }

  void handleAnswer(bool answer){
    isCorrect = (currentQuestion.answer == answer);
    quiz.answer(isCorrect);
    this.setState(() {
      overlayVisible = true;
    });
  }


  @override
  Widget build(BuildContext context){
    return new Stack(
      fit: StackFit.expand,
      children: <Widget>[
        new Column( //this is our main page
          children: <Widget>[
            new AnswerButton(true, () => handleAnswer(true)),
            new QuestionText(questionText, questionNumber),
            new AnswerButton(false, () => handleAnswer(false))
          ],
        ),
       overlayVisible == true ? new QuizOverlay(
         isCorrect,
         () {
           if (quiz.length == questionNumber){
           Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(builder: (BuildContext context) => new ScorePage(quiz.score, quiz.length)), (Route route) => route == null);
           return;
         }
         currentQuestion = quiz.nextQuestion;
         this.setState(() {
           overlayVisible = false;
           questionText = currentQuestion.question;
           questionNumber = quiz.questionNumber;
         });
         }
       ) : new Container(),
      ],
    );
  }
}
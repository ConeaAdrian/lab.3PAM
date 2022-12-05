import 'dart:async';
import "package:flutter/material.dart";

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const FirtRoute(),
        '/second': (context) => const SecondRoute(),
        '/third': (context) => const ThirdRoute(),
      },
    );
  }
}

/// Start first page///
class FirtRoute extends StatefulWidget {
  const FirtRoute({Key? key}) : super(key: key);

  @override
  State<FirtRoute> createState() => _FirstRoute();
}

class _FirstRoute extends State<FirtRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
              padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
              alignment: Alignment.center,
              child: Image.asset('images/pi.png')),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
            alignment: Alignment.center,
            child: const Text(
              'Math for\neveryone',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            alignment: Alignment.center,
            child: SizedBox(
              height: 50, //height of button
              width: 300, //width of button
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                ),
                child: const Text(
                  'Start!',
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/second');
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Finish first page///
///
/// Start second page///
class SecondRoute extends StatefulWidget {
  const SecondRoute({Key? key}) : super(key: key);

  @override
  State<SecondRoute> createState() => _SecondRoute();
}

Quiz quiz1 = Quiz();
Quiz quiz2 = Quiz();
Quiz quiz3 = Quiz();
Quiz quiz4 = Quiz();
Quiz quiz5 = Quiz();
List<Quiz> all = List.empty(growable: true);

int count = 0;
Timer? _timer;//timer pentru secunde
Timer? _timer2;//pentru linear
int initialTime = 40;
int totalTime = initialTime;
double pas = 0;
double progress = 0.0;
bool start = true;
//pentru rutu 3
int finalTime = 0;
double finalPoints = 0;
int finalCorectAnswer = 0;

class _SecondRoute extends State<SecondRoute> {
  int? _value = 0;//pentru quiz

  ///
  void nextQuiz() {
    calculateResults();
    _value = 0;
    count++;
    progress = 0.0;
    totalTime = initialTime;

    if (count == 5) {
      _timer2?.cancel();
      _timer?.cancel();
      Navigator.pushNamed(context, '/third');
    }
  }

  void calculateResults() {
    if (all[count].corectAnswer == _value) {
      setState(() {
        finalCorectAnswer++;
        finalPoints += (initialTime + totalTime) * 1.5;
      });
    }
    setState(() {
      finalTime += initialTime - totalTime;
    });
  }

  void progressBarAnimation() {
    pas = (0.01.toDouble()) / (totalTime.toDouble());
    _timer2 = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      setState(() {
        progress += pas;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    void startTimer() {
      progressBarAnimation();
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (count != 5) {
            totalTime--;

            // if time is 0 pass next quiz
            if (totalTime == 0) {
              nextQuiz();
            }
          } else {
            _timer?.cancel();
            _timer2?.cancel();
            Navigator.pushNamed(context, '/third');
          }
        });
      });
    }

    //Quiz initiation//
    loadQuiz();

    //start one time QuizTimer
    if (start) {
      startTimer();
      start = false;
    }
    Widget answerRadio(Quiz quiz) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Text(quiz.condition),
          ),
          Row(children: [
            Text(quiz.raspuns1),
            Radio(
              value: 1,
              groupValue: _value,
              onChanged: (value) {
                setState(() {
                  _value = value;
                });
              },
            ),
          ]),
          Row(children: [
            Text(quiz.raspuns2),
            Radio(
              value: 2,
              groupValue: _value,
              onChanged: (value) {
                setState(() {
                  _value = value;
                });
              },
            ),
          ]),
          Row(children: [
            Text(quiz.raspuns3),
            Radio(
              value: 3,
              groupValue: _value,
              onChanged: (value) {
                setState(() {
                  _value = value;
                });
              },
            ),
          ]),
          Row(children: [
            Text(quiz.raspuns4),
            Radio(
              value: 4,
              groupValue: _value,
              onChanged: (value) {
                setState(() {
                  _value = value;
                });
              },
            ),
          ]),
        ],
      );
    }

    Widget showWidgetQuiz(List<Quiz> quiz) {
      if (count == 0) {
        return answerRadio(quiz[0]); //set1
      } else if (count == 1) {
        return answerRadio(quiz[1]); // set2
      } else if (count == 2) {
        return answerRadio(quiz[2]); // set3
      } else if (count == 3) {
        return answerRadio(quiz[3]); // set4
      } else if (count == 4) {
        return answerRadio(quiz[4]); // set5
      }
      return const Text("");
    }

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(child: Image.asset('images/ceas.png')),
                // ignore: prefer_const_constructors
                SizedBox(
                  width: 3,
                ),
                Text("${totalTime}s"),
              ],
            ),
            SizedBox(
              width: 450,
              height: 5,
              child: LinearProgressIndicator(
                value: progress,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Colors.green,
                ),
                backgroundColor: Colors.grey,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 75, 380, 0),
              child: Text(
                "  Question " + (count + 1).toString() + " of 5",
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            showWidgetQuiz(all),
            ElevatedButton(
                onPressed: nextQuiz,
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                ),
                child: const Text(
                  "          next          ",
                  style: TextStyle(fontSize: 20),
                )),
          ],
        ),
      ),
    );
  }
}

/// Finish second page ///
///
/// Start third page ///

class ThirdRoute extends StatefulWidget {
  const ThirdRoute({Key? key}) : super(key: key);

  @override
  State<ThirdRoute> createState() => _ThirdRoute();
}

class _ThirdRoute extends State<ThirdRoute> {
  void resetQuiz() {
    finalCorectAnswer = 0;
    finalPoints = 0;
    finalTime = 0;
    count = 0;
    progress = 0.0;
    totalTime = initialTime;
    pas = 0;
    start = true;
    Navigator.pushNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          const SizedBox(
            height: 30,
          ),
          Container(
            padding: const EdgeInsets.all(5),
            alignment:Alignment.center,
            width: 250,
            height: 250,

            margin: const EdgeInsets.fromLTRB(125, 0, 0, 0),
            decoration: BoxDecoration(
                // ignore: prefer_const_literals_to_create_immutables
                boxShadow: [
                  const BoxShadow(
                    color: Colors.black,
                    blurRadius: 5,
                  )
                ],
                borderRadius: BorderRadius.circular(10),
                color: Colors.white),
            child: Column(
              children: [
                const Text("New Rating"),
                Text(
                  '$finalPoints',
                  style: const TextStyle(fontSize: 30),
                ),
                Row(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    const SizedBox(width: 50),
                    const Text("Score"),
                    const SizedBox(width: 10),
                    const Text("Corect"),
                    const SizedBox(width: 10),
                    const Text("Time"),
                  ],
                ),
                Row(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    const SizedBox(width: 50),
                    Text("${finalCorectAnswer*2}/10"),
                    const SizedBox(width: 10),
                    Text('   $finalCorectAnswer/5'),
                    const SizedBox(width: 10),
                    Text('     $finalTime s'),
                  ],
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: resetQuiz,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black,
                  ),
                  child: const Text("     New Game     "),
                ),
                const SizedBox(height: 30),
                const Text("Directed by Hydra Corporation"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Finish third page ///

class Quiz {
  late String condition;
  late String raspuns1;
  late String raspuns2;
  late String raspuns3;
  late String raspuns4;
  late int corectAnswer = 10;
}

void loadQuiz() {
  quiz1.condition = "O girafa poate cantari intre 700 si 1200 kilograme "
      "\niar o pisica de casa are aproximativ 5 kilograme. "
      "Cum bagi girafa in frigider?";
  quiz1.raspuns1 = "  A. Usorr                        ";
  quiz1.raspuns2 = "  B. Depinde de frigider";
  quiz1.raspuns3 = "  C. Nicidecum               ";
  quiz1.raspuns4 = "  D. Depinde de girafa   ";
  quiz1.corectAnswer = 2;

  quiz2.condition = "Dacă 5 mașini fac 5 nasturi în 5 minute, "
      "\nîn cât timp ar face 100 de mașini 100 de nasturi?";
  quiz2.raspuns1 = "  A. o ora   ";
  quiz2.raspuns2 = "  B. 5 ore   ";
  quiz2.raspuns3 = "  C. 20 min";
  quiz2.raspuns4 = "  D. 5 min   ";
  quiz2.corectAnswer = 4;

  quiz3.condition = "Care este al 50-lea număr din această secvență? "
      "\n5, 11, 17, 23, 29, 35, 41, …?";
  quiz3.raspuns1 = "  A. 299";
  quiz3.raspuns2 = "  B. 222";
  quiz3.raspuns3 = "  C. 292";
  quiz3.raspuns4 = "  D. 301";
  quiz3.corectAnswer = 1;

  quiz4.condition =
      "Care este continuarea logică a șirului de numere 1, 2, 4, 8, …?";
  quiz4.raspuns1 = "  A. 10";
  quiz4.raspuns2 = "  B. 12";
  quiz4.raspuns3 = "  C. 16";
  quiz4.raspuns4 = "  D. 20";
  quiz4.corectAnswer = 3;

  quiz5.condition = "Cu ce este egala aria covorului lui Sierpinski(m)?";
  quiz5.raspuns1 = "  A. 8";
  quiz5.raspuns2 = "  B. 0";
  quiz5.raspuns3 = "  C. 9";
  quiz5.raspuns4 = "  D. 5";
  quiz5.corectAnswer = 2;

  all.add(quiz1);
  all.add(quiz2);
  all.add(quiz3);
  all.add(quiz4);
  all.add(quiz5);
}

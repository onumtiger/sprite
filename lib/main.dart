import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

int question = -1;
var questionsMap = {};
var questionsList = [];
var selector = 0;
String currentQuestion = "Spiel starten";

void getQuestions() async {
  final snapshot = await FirebaseFirestore.instance
      .collection("questions")
      .doc('questions')
      .get();
  questionsMap = snapshot.data() as Map<String, dynamic>;

  for (var i = 0; i < questionsMap.length; i++) {
    questionsList.add(i);
  }
  questionsList.shuffle();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    getQuestions();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    return MaterialApp(
      title: 'Onums Never Have I Ever',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(title: 'Onums Never Have I Ever'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void nextQuestion() {
    setState(() {
      if (question < questionsMap.length - 1) {
        question++;
        selector = questionsList[question];
        currentQuestion = questionsMap['$selector'];
        containerColor = (containerColor == Colors.green[900]
            ? Colors.green[600]
            : Colors.green[900])!;
      }
    });
  }

  void previosQuestion() {
    setState(() {
      if (question > 0) {
        question--;
        selector = questionsList[question];
        currentQuestion = questionsMap['$selector'];
        (containerColor == Colors.green[900]
            ? Colors.green[700]
            : Colors.green[900])!;
      }
    });
  }

  Color containerColor = Colors.green;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: ElevatedButton(
                onPressed: previosQuestion,
                style: ElevatedButton.styleFrom(
                  primary: Colors.green[100],
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 200),
                ),
                child: null,
              ),
            ),
            Expanded(
              flex: 9,
              child: GestureDetector(
                onTap: nextQuestion,
                child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      color: containerColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    height: 500,
                    child: Center(
                        child: Container(
                            constraints: const BoxConstraints(
                                minWidth: 600, maxWidth: 600),
                            child: Center(
                                child: Text(currentQuestion,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 28,
                                        height: 1.5,
                                        letterSpacing: 1.0,
                                        color: Colors.white)))))),
              ),
            ),
          ],
        ));
  }
}

import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:loading_state/Screens/index.dart';
import 'package:loading_state/Util/game.dart';
import 'package:loading_state/Widget/game_button.dart';

class GameScreen extends StatefulWidget {
  GameScreen(this.gameChoice, {Key? key}) : super(key: key);
  Choice gameChoice;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late ConfettiController _controllerTopCenter;
  @override
  void initState() {
    super.initState();

    _controllerTopCenter = ConfettiController(duration: const Duration(seconds: 2));
    // if(Choice.gameRule[widget.gameChoice] == "You Win!")
    // _controllerTopCenter.play();
  }

  @override
  void dispose() {
    _controllerTopCenter.dispose();
    super.dispose();
  }

  Path drawCustomConfetti(Size? size) {
    final path = Path();
    path.moveTo(15, 5);
    path.lineTo(-15, 5);
    path.lineTo(-15, -5);
    path.lineTo(15, -5);
    path.lineTo(15, 5);
    path.close();
    return path;
  }

  Path drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step), halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }

  @override
  Widget build(BuildContext context) {
    double btnWidth = MediaQuery.of(context).size.width / 2 - 40;
    String? robotChoice = Game.randomChoice();
    String robotChoicePath = "";
    switch (robotChoice) {
      case "Rock":
        robotChoicePath = "assets/rock_btn.png";
        break;
      case "Paper":
        robotChoicePath = "assets/paper_btn.png";
        break;
      case "Scissor":
        robotChoicePath = "assets/scisor_btn.png";
        break;
      default:
    }

    String? playerChoice;
    switch (widget.gameChoice.type) {
      case "Rock":
        playerChoice = "assets/rock_btn.png";
        break;
      case "Paper":
        playerChoice = "assets/paper_btn.png";
        break;
      case "Scissor":
        playerChoice = "assets/scisor_btn.png";
        break;
      default:
    }

    if (Choice.gameRule[widget.gameChoice.type]![robotChoice] == "You Win!") {
      setState(() {
        Game.score++;
        _controllerTopCenter.play();
      });
    }

    return Scaffold(
      backgroundColor: Colors.deepPurple[800],
      body: Padding(
        padding: EdgeInsets.fromLTRB(20.0, 60.0, 20.0, 20.0),
        // EdgeInsets.symmetric(vertical: 54.0, horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _controllerTopCenter,
                blastDirection: -pi / 2,
                maxBlastForce: 30, // set a lower max blast force
                minBlastForce: 1, // set a lower min blast force
                emissionFrequency: 0,
                numberOfParticles: 100, // a lot of particles at once
                gravity: 0.6,
                blastDirectionality: BlastDirectionality.explosive,
                createParticlePath: drawCustomConfetti,
              ),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: 3.0,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "SCORE",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "${Game.score}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 2,
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Hero(
                    tag: "${widget.gameChoice.type}",
                    child: gameButton(null, playerChoice!, btnWidth),
                  ),
                  Text(
                    "VS",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                  gameButton(null, robotChoicePath, btnWidth)
                ],
              )),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              "${Choice.gameRule[widget.gameChoice.type]![robotChoice]}",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 36.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0),
            ),
            Container(
              width: double.infinity,
              child: RawMaterialButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MainScreen(),
                      ));
                },
                padding: EdgeInsets.all(16.0),
                shape: StadiumBorder(
                  side: BorderSide(
                    color: Colors.white,
                    width: 5.0,
                  ),
                ),
                child: Text(
                  "Play Again",
                  style: TextStyle(color: Colors.white, fontSize: 24.0),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              child: RawMaterialButton(
                onPressed: () {},
                padding: EdgeInsets.all(16.0),
                shape: StadiumBorder(
                  side: BorderSide(
                    color: Colors.white,
                    width: 5.0,
                  ),
                ),
                child: Text(
                  "RULES",
                  style: TextStyle(color: Colors.white, fontSize: 24.0),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

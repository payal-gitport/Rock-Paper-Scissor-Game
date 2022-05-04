import 'dart:math';

class Game {
  static int score = 0;

  static List<String> choices = ["Rock", "Paper", "Scissor"];
  static String? randomChoice() {
    Random random = new Random();
    int robotChoiceIndex = random.nextInt(3);
    return choices[robotChoiceIndex];
  }
}

class Choice {
  String? type = "";

  static var gameRule = {
    "Rock": {
      "Rock": "It's a Draw!",
      "Paper": "You Lose",
      "Scissor": "You Win!",
    },
    "Paper": {
      "Rock": "You Win!",
      "Paper": "It's a Draw!",
      "Scissor": "You Lose!",
    },
    "Scissor": {
      "Rock": "You Lose!",
      "Paper": "You Win!",
      "Scissor": "It's a Draw!",
    }
  };
  Choice(this.type);
}

import 'dart:math';

class Game
{
  int winner = 0;
  int limit = 5;
  int equalDice = 0;
  bool disable = false;

  Player first = Player("", 0, false);
  Player second = Player("", 0, false);

  Game(this.limit)
  {
    start();
  }

  start()
  {
    first = Player("PLAYER 01", 0, true);
    second = Player("PLAYER 02", 0, false);
    winner = 0;
    disable = false;
  }

  calculateRound()
  {
    if (first.diceNumber > second.diceNumber)
    {
      first.score++;
    }
    else if (first.diceNumber < second.diceNumber)
    {
      second.score++;
    }
    else
    {
      equalDice++;
    }
    analyseWinner();
  }

  switchTurn()
  {
    first.turn = !first.turn;
    second.turn = !second.turn;
  }

  analyseWinner()
  {
    if (first.score == limit)
    {
      winner = 1;
      freeze();
    }

    if (second.score == limit)
    {
      winner = 2;
      freeze();
    }
  }

  freeze()
  {
    disable = true;
  }

  hasWinner()
  {
    return winner > 0;
  }
}

class Player
{
  String name;
  int score = 0;
  bool turn = false;
  int diceNumber = 1;

  Player(this.name, this.score, this.turn);

  shuffle()
  {
    diceNumber = Random().nextInt(6) + 1;
  }
}

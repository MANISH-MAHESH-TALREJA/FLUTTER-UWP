import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'children_at_different_game_states.dart';

// ignore: constant_identifier_names
enum Direction { LEFT, RIGHT, UP, DOWN }
// ignore: constant_identifier_names
enum GameState { START, RUNNING, FAILURE }

// ignore: use_key_in_widget_constructors
class Game extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() => _GameState();
}

class _GameState extends State<Game>
{
  // ignore: prefer_typing_uninitialized_variables
  var snakePosition;
  late Point newPointPosition;
  late Timer timer;
  Direction _direction = Direction.UP;
  var gameState = GameState.START;
  int score = 0;

  @override
  Widget build(BuildContext context)
  {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      controller: ScrollController(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            width: 900,
            height: 500,
            padding: const EdgeInsets.only(top: 35, bottom: 35, left: 70, right: 30),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/snake/snake_bg.png'),
                fit: BoxFit.fill,
              ),
            ),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapUp: (tapUpDetails)
              {
                _handleTap(tapUpDetails);
              },
              child: _getChildBasedOnGameState(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: 200,
                  height: 200,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(width: 10.0, color: Colors.red),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text(
                    "Score\n$score",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 50),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _direction = Direction.UP;
                          });
                        },
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.green)),
                        child: const Text("Up"),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _direction = Direction.LEFT;
                            });
                          },
                          style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.yellow)),
                          child: const Text("Left"),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _direction = Direction.RIGHT;
                              });
                            },
                            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.yellow)),
                            child: const Text("Right"),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 50),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _direction = Direction.DOWN;
                          });
                        },
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.green)),
                        child: const Text("Down"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleTap(TapUpDetails tapUpDetails) {
    switch (gameState) {
      case GameState.START:
        startToRunState();
        break;
      case GameState.RUNNING:
        break;
      case GameState.FAILURE:
        setGameState(GameState.START);
        break;
    }
  }

  void startToRunState() {
    startingSnake();
    generatenewPoint();
    _direction = Direction.UP;
    setGameState(GameState.RUNNING);
    timer = Timer.periodic(const Duration(milliseconds: 400), onTimeTick);
  }

  void startingSnake() {
    setState(() {
      const midPoint = (320 / 20 / 2);
      snakePosition = [
        Point(midPoint, midPoint - 1),
        Point(midPoint, midPoint),
        Point(midPoint, midPoint + 1),
      ];
    });
  }

  void generatenewPoint() {
    setState(() {
      Random rng = Random();
      var min = 0;
      var max = 320 ~/ 20;
      var nextX = min + rng.nextInt(max - min);
      var nextY = min + rng.nextInt(max - min);

      var newRedPoint = Point(nextX.toDouble(), nextY.toDouble());

      if (snakePosition.contains(newRedPoint)) {
        generatenewPoint();
      } else {
        newPointPosition = newRedPoint;
      }
    });
  }

  void setGameState(GameState _gameState) {
    setState(() {
      gameState = _gameState;
    });
  }

  Widget _getChildBasedOnGameState() {
    // ignore: prefer_typing_uninitialized_variables
    var child;
    switch (gameState) {
      case GameState.START:
        setState(() {
          score = 0;
        });
        child = gameStartChild;
        break;

      case GameState.RUNNING:
        List<Positioned> snakePiecesWithNewPoints = [];
        snakePosition.forEach(
          (i) {
            snakePiecesWithNewPoints.add(
              Positioned(
                child: gameRunningChild,
                left: i.xx * 47,
                top: i.yy * 26,
              ),
            );
          },
        );
        final latestPoint = Positioned(
          child: newSnakePointInGame,
          left: newPointPosition.xx * 45,
          top: newPointPosition.yy * 25,
        );
        snakePiecesWithNewPoints.add(latestPoint);
        child = Stack(children: snakePiecesWithNewPoints);
        break;

      case GameState.FAILURE:
        timer.cancel();
        child = Container(
          width: 900,
          height: 500,
          padding: const EdgeInsets.all(32),
          child: Center(
            child: Text(
              "You Scored: $score\nTap to play again!",
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 30,
              ),
            ),
          ),
        );
        break;
    }
    return child;
  }

  void onTimeTick(Timer timer) {
    setState(() {
      snakePosition.insert(0, getLatestSnake());
      snakePosition.removeLast();
    });

    var currentHeadPos = snakePosition.first;
    if (currentHeadPos.x < 0 ||
        currentHeadPos.y < 0 ||
        currentHeadPos.x > 320 / 20 ||
        currentHeadPos.y > 320 / 20) {
      setGameState(GameState.FAILURE);
      return;
    }

    if (snakePosition.first.x == newPointPosition.xx &&
        snakePosition.first.y == newPointPosition.yy) {
      generatenewPoint();
      setState(() {
        if (score <= 10) {
          score = score + 1;
        } else if (score > 10 && score <= 25) {
          score = score + 2;
        } else {
          score = score + 3;
        }

        snakePosition.insert(0, getLatestSnake());
      });
    }
  }

  Point getLatestSnake() {
    // ignore: prefer_typing_uninitialized_variables
    var newHeadPos;

    switch (_direction) {
      case Direction.LEFT:
        var currentHeadPos = snakePosition.first;
        newHeadPos = Point(currentHeadPos.x - 1, currentHeadPos.y);
        break;

      case Direction.RIGHT:
        var currentHeadPos = snakePosition.first;
        newHeadPos = Point(currentHeadPos.x + 1, currentHeadPos.y);
        break;

      case Direction.UP:
        var currentHeadPos = snakePosition.first;
        newHeadPos = Point(currentHeadPos.x, currentHeadPos.y - 1);
        break;

      case Direction.DOWN:
        var currentHeadPos = snakePosition.first;
        newHeadPos = Point(currentHeadPos.x, currentHeadPos.y + 1);
        break;
    }

    return newHeadPos;
  }
}
import 'package:flutter/material.dart';
import 'package:games/games/carrom/models/game.dart';
import 'package:games/games/carrom/views/toast.dart';

import 'game_over.dart';
//import 'game_over.dart';

class CleanStrike extends StatefulWidget
{
  const CleanStrike({required Key key, required this.gameType}) : super(key: key);

  final int gameType;

  @override
  _CleanStrikeState createState() => _CleanStrikeState();
}

class _CleanStrikeState extends State<CleanStrike>
{
  int _currentPlayer = 1;
  late int _winner;
  bool _actionSuccess = false;
  final Game _gameObject = Game();

  void _showToast(String toastMessage)
  {
    Toast.show(
      toastMessage,
      context,
      backgroundRadius: 14,
      gravity: Toast.bottom,
      duration: 3,
      backgroundColor: Colors.black,
      textColor: Colors.white, border: Border.all(width: 0.0),
    );
  }

  void _performAction(int action, {int scenario = 0})
  {
    _currentPlayer = _gameObject.getCurrentPlayer();
    if (action == 2 || action == 5)
    {
      _actionSuccess = _gameObject.actions(action, scenario: scenario);
    }
    else
    {
      _actionSuccess = _gameObject.actions(action);
    }
    _winner = _gameObject.gameWinner();
    _predictWinner(_winner);
  }

  void _showDialog(int action)
  {
    showDialog<AlertDialog>(
      context: context,
      builder: (BuildContext context)
      {
        return AlertDialog(
          title: const Text('Choose Scenario'),
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>
            [
              InkWell(
                onTap: ()
                {
                  setState(()
                  {
                      _performAction(action, scenario: 1);
                      if (_actionSuccess)
                      {
                        action == 2 ? _showToast('Player $_currentPlayer pockets 2 black coins') : _showToast('Player $_currentPlayer throws a black coin out of board');
                      } else
                      {
                        _showToast('Invalid Move.No sufficient black coins');
                      }
                    },
                  );
                  Navigator.of(context).pop();
                },
                child: Container(
                  width: 100,
                  height: 50,
                  color: Colors.black,
                  child: Center(
                    child: Text(
                      action == 2 ? 'Black-Black' : 'Black',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              const Expanded(
                child: SizedBox(
                  width: 20,
                ),
              ),
              InkWell(
                onTap: ()
                {
                  setState(()
                  {
                      _performAction(action, scenario: 2);
                      if (_actionSuccess)
                      {
                        action == 2 ?_showToast('Player $_currentPlayer pockets a black coin and a red coin\nBlack coin is returned to the board.'): _showToast('Player $_currentPlayer throws the red coin out of board');
                      }
                      else
                      {
                        _showToast('Invalid Move.No sufficient coins');
                      }
                    },
                  );
                  Navigator.of(context).pop();
                },
                child: Container(
                  width: 100,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: action == 2
                        ? const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: <Color>[
                              Colors.black,
                              Colors.red,
                            ],
                            stops: <double>[0.5, 0.5],
                          )
                        : const LinearGradient(
                            colors: <Color>[Colors.red, Colors.redAccent],
                          ),
                  ),
                  child: Center(
                    child: Text(
                      action == 2 ? 'Black-Red' : 'Red',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _predictWinner(int _winner)
  {
    if (_winner >= 0)
    {
      Navigator.of(context).push(
        PageRouteBuilder<Widget>(
          opaque: false,
          pageBuilder: (BuildContext context, Animation<double> animation,
                  Animation<double> secondary) =>
              GameOver(winner: _winner, key: const Key(""),),
          transitionDuration: const Duration(seconds: 1),
          transitionsBuilder: (BuildContext context, Animation<double> anim,
                  Animation<double> secondaryAnim, Widget child) =>
              FadeTransition(
            child: child,
            opacity: Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(anim),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          controller: ScrollController(),
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Center(
                  child: Card(
                    elevation: 2,
                    color: Colors.blue,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        'PLAYER ${_gameObject.getCurrentPlayer()}\'S TURN',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        color: Colors.black,
                        child: Center(
                          child: Column(
                            children: <Widget>[
                              const Text(
                                'BLACK COINS\nLEFT',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                _gameObject.getBlackCoins().toString(),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.red,
                        child: Center(
                          child: Column(
                            children: <Widget>[
                              const Text(
                                'RED COINS\nLEFT',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                _gameObject.getRedCoins().toString(),
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Expanded(
                      child: Center(
                        child: Column(
                          children: <Widget>[
                            const Text(
                              'PLAYER 01',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              _gameObject.getPlayerScore(0).toString(),
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top: 30.0),
                        child: Text(
                          '-',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 50,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Column(
                          children: <Widget>[
                            const Text(
                              'PLAYER 02',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              _gameObject.getPlayerScore(1).toString(),
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                Column(
                  children: <Widget>[
                    Wrap(
                      runSpacing: 15,
                      children: <Widget>[
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Expanded(
                              child: ElevatedButton(
                                onPressed: ()
                                {
                                  setState(()
                                  {
                                      _performAction(1);
                                      if (_actionSuccess)
                                      {
                                        _showToast('PLAYER $_currentPlayer POCKETS A BLACK COIN');
                                      }
                                      else
                                      {
                                        _showToast('INVALID MOVE !!! NO BLACK COINS');
                                      }
                                    },
                                  );
                                },
                                style: ButtonStyle(
                                  foregroundColor: MaterialStateProperty.all(Colors.blue)
                                ),
                                child: const Text(
                                  'STRIKE',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: ()
                                {
                                  if (_gameObject.getRedCoins() == 1 && _gameObject.getBlackCoins() > 1)
                                  {
                                    _showDialog(2);
                                  }
                                  else if(_gameObject.getRedCoins()==1&&_gameObject.getBlackCoins()==1)
                                    {
                                      setState(()
                                      {
                                        _performAction(2, scenario: 2);
                                        if (_actionSuccess)
                                        {
                                          _showToast('PLAYER $_currentPlayer POCKETS A BLACK COIN AND A RED COIN\nBLACK COIN IS RETURNED TO THE BOARD');
                                        }
                                        else
                                        {
                                          _showToast('INVALID MOVE !!! NO BLACK COINS');
                                        }
                                      });
                                    }
                                  else
                                    {
                                    setState(()
                                    {
                                    _performAction(2, scenario: 1);

                                    if (_actionSuccess)
                                    {
                                      _showToast('PLAYER $_currentPlayer POCKETS 02 BLACK COINS');
                                    }
                                    else
                                    {
                                      _showToast('INVALID MOVE !!! NO BLACK COINS');
                                    }
                                  });}

                                },
                                style: ButtonStyle(
                                    foregroundColor: MaterialStateProperty.all(Colors.blue)
                                ),
                                child: const Text(
                                  'MULTI STRIKE',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: ElevatedButton(

                                onPressed: ()
                                {
                                  setState(()
                                  {
                                      _performAction(3);
                                      if (_actionSuccess)
                                      {
                                        _showToast('PLAYER $_currentPlayer POCKETS A RED COIN');
                                      }
                                      else
                                      {
                                        _showToast('INVALID MOVE !!! NO RED COINS');
                                      }
                                    },
                                  );
                                },

                                style: ButtonStyle(
                                    foregroundColor: MaterialStateProperty.all(Colors.blue),
                                ),
                                child: const Text(
                                  'RED STRIKE',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Expanded(
                              child: ElevatedButton(
                                onPressed: ()
                                {
                                  setState(()
                                  {
                                      _performAction(4);
                                      if (_gameObject.isFoul(_currentPlayer))
                                      {
                                        _showToast('PLAYER $_currentPlayer POCKETS THE STRIKER COIN. YOU WILL LOSE AN ADDITIONAL POINT SINCE YOU HAVE 03 FOULS');
                                      }
                                      else
                                      {
                                        _showToast('PLAYER $_currentPlayer POCKETS THE STRIKER');
                                      }
                                    },
                                  );
                                },
                                style: ButtonStyle(
                                    foregroundColor: MaterialStateProperty.all(Colors.blue)
                                ),
                                child: const Text(
                                  'STRIKER STRIKE',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: ()
                                {
                                  if (_gameObject.getRedCoins() != 0 && _gameObject.getBlackCoins() != 0)
                                  {
                                    _showDialog(5);
                                  }
                                  else if (_gameObject.getRedCoins() == 0)
                                  {
                                    setState(()
                                    {
                                        _performAction(5, scenario: 1);

                                        if (_actionSuccess)
                                        {
                                          _showToast('PLAYER $_currentPlayer THROWS A BLACK COIN OUT OF BOARD');
                                        }
                                        else
                                        {
                                          _showToast('INVALID MOVE !!! NO SUFFICIENT COINS');
                                        }
                                      },
                                    );
                                  }
                                  else
                                  {
                                    setState(()
                                    {
                                      _performAction(2, scenario: 2);

                                      if (_actionSuccess)
                                      {
                                        _showToast('PLAYER $_currentPlayer THROWS A RED COIN OUT OF BOARD');
                                      }
                                      else
                                      {
                                        _showToast('INVALID MOVE !!! NO SUFFICIENT COINS');
                                      }
                                    });
                                  }
                                },
                                style: ButtonStyle(foregroundColor: MaterialStateProperty.all(Colors.blue)),
                                child: const Text(
                                  'DEFUNCT COIN',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: ()
                                {
                                  setState(()
                                    {
                                      _performAction(6);
                                      if (_gameObject.isIdle(_currentPlayer))
                                      {
                                        _showToast('PLAYER $_currentPlayer MAKES AN IDLE PASS. YOU WILL LOSE AN ADDITIONAL POINT SINCE YOU HAVEN\'T POCKETED A COIN FOR 03 SUCCESSFUL TURNS');
                                      }
                                      else
                                      {
                                        _showToast('PLAYER $_currentPlayer MAKES AN IDLE PASS');
                                      }
                                    },
                                  );
                                },
                                style: ButtonStyle(foregroundColor: MaterialStateProperty.all(Colors.blue)),
                                child: const Text(
                                  'MISS',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

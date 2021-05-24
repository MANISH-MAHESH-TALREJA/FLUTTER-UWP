import 'dart:math';
import 'package:games/games/ludo/players/collision_details.dart';
import 'package:games/games/ludo/dice/dice_notifier.dart';
import 'package:games/games/ludo/board/overlay_surface.dart';
import 'package:games/games/ludo/players/players_notifier.dart';
import 'package:games/games/ludo/util/colors.dart';
import 'package:games/games/ludo/players/players.dart';
import 'package:games/games/ludo/result/result.dart';
import 'package:games/games/ludo/result/result_notifier.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'board/board.dart';
import 'dice/dice.dart';
import 'dice/dice_base.dart';

// ignore: use_key_in_widget_constructors
class FludoGame extends StatefulWidget {
  @override
  _FludoGameState createState() => _FludoGameState();
}

class _FludoGameState extends State<FludoGame> with TickerProviderStateMixin {
  late Animation<Color?> _playerHighlightAnim;
  late Animation<double> _diceHighlightAnim;
  late AnimationController _playerHighlightAnimCont, _diceHighlightAnimCont;
  final List<List<AnimationController>> _playerAnimContList = [];
  final List<List<Animation<Offset>>> _playerAnimList = [];
  final List<List<int>> _winnerPawnList = [];
  bool _provideFreeTurn = false;
  CollisionDetails _collisionDetails = CollisionDetails();

  late int _stepCounter = 0,
      _diceOutput = 0,
      _currentTurn = 0,
      _selectedPawnIndex,
      // ignore: prefer_final_fields
      _maxTrackIndex = 57,
      _straightSixesCounter = 0,
      // ignore: prefer_final_fields
      _forwardStepAnimTimeInMillis = 250,
      // ignore: prefer_final_fields
      _reverseStepAnimTimeInMillis = 60;
  late List<List<List<Rect>>> _playerTracks;
  late List<Rect> _safeSpots;
  final List<List<MapEntry<int, Rect>>> _pawnCurrentStepInfo = [];

  late PlayersNotifier _playerPaintNotifier;
  late ResultNotifier _resultNotifier;
  late DiceNotifier _diceNotifier;

  @override
  void initState()
  {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]); //full screen
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]); //force portrait mode

    _playerPaintNotifier = PlayersNotifier();
    _resultNotifier = ResultNotifier();
    _diceNotifier = DiceNotifier();

    _playerHighlightAnimCont = AnimationController(duration: const Duration(milliseconds: 700), vsync: this);
    _diceHighlightAnimCont = AnimationController(duration: const Duration(seconds: 5), vsync: this);

    _playerHighlightAnim = ColorTween(begin: Colors.black12, end: Colors.black45).animate(_playerHighlightAnimCont);
    _diceHighlightAnim = Tween(begin: 0.0, end: 2 * pi).animate(_diceHighlightAnimCont);
    WidgetsBinding.instance!.addPostFrameCallback((_)
    {
      _initData();

      _playerPaintNotifier.rebuildPaint();

      _highlightCurrentPlayer();
      _highlightDice();
    });
  }

  @override
  void dispose()
  {
    for (var controllerList in _playerAnimContList)
    {
      for (var controller in controllerList)
      {
        controller.dispose();
      }
    }
    _playerHighlightAnimCont.dispose();
    _diceHighlightAnimCont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider<PlayersNotifier>(create: (_) => _playerPaintNotifier),
          ChangeNotifierProvider<ResultNotifier>(create: (_) => _resultNotifier),
          ChangeNotifierProvider<DiceNotifier>(create: (_) => _diceNotifier),
        ],
        child: Stack(
          children: <Widget>[
            SizedBox.expand(
                child: Container(
              color: const Color(0xff1f0d67),
            )),
            Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                controller: ScrollController(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      color: Colors.white,
                      width : MediaQuery.of(context).size.height*0.7,
                      height: MediaQuery.of(context).size.height*0.7,
                      margin: const EdgeInsets.all(20),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Stack(
                          children: <Widget>
                          [
                            SizedBox.expand(
                              child: CustomPaint(
                                painter: BoardPainter(
                                    trackCalculationListener: (playerTracks)
                                    {
                                      _playerTracks = playerTracks;
                                    }
                                ),
                              ),
                            ),
                            SizedBox.expand(
                                child: AnimatedBuilder(
                              animation: _playerHighlightAnim,
                              builder: (_, __) => CustomPaint(
                                painter: OverlaySurface(
                                    highlightColor: _playerHighlightAnim.value!,
                                    selectedHomeIndex: _currentTurn,
                                    clickOffset: (clickOffset)
                                    {
                                      _handleClick(clickOffset);
                                    }),
                              ),
                            )),
                            Consumer<PlayersNotifier>(builder: (_, notifier, __)
                            {
                              if (notifier.shouldPaintPlayers)
                              {
                                return SizedBox.expand(
                                  child: Stack(
                                    children: _buildPawnWidgets(),
                                  ),
                                );
                              }
                              else
                              {
                                return Container();
                              }
                            }),
                            Consumer<ResultNotifier>(builder: (_, notifier, __)
                            {
                              return SizedBox.expand(
                                  child: CustomPaint(
                                painter: ResultPainter(notifier.ranks),
                              ));
                            })
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    GestureDetector(
                      onTap: ()
                      {
                        if (_diceHighlightAnimCont.isAnimating)
                        {
                          _playerHighlightAnimCont.reset();
                          _diceHighlightAnimCont.reset();
                          _diceNotifier.rollDice();
                        }
                      },
                      child: SizedBox(
                          width: 40,
                          height: 40,
                          child: Stack(children: [
                            SizedBox.expand(
                              child: AnimatedBuilder(
                                animation: _diceHighlightAnim,
                                builder: (_, __) => CustomPaint(
                                  painter: DiceBasePainter(_diceHighlightAnim.value),
                                ),
                              ),
                            ),
                            Consumer<DiceNotifier>(builder: (_, notifier, __)
                            {
                              if (notifier.isRolled)
                              {
                                _highlightCurrentPlayer();
                                _diceOutput = notifier.output;
                                if (_diceOutput == 6) _straightSixesCounter++;
                                _checkDiceResultValidity();
                              }
                              return SizedBox.expand(
                                child: CustomPaint(
                                  painter: DicePaint(notifier.output),
                                ),
                              );
                            })
                          ])
                      ),
                    ),
                    const SizedBox(height: 50,)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPawnWidgets()
  {
    List<Widget> playerPawns = [];

    for (int playerIndex = 0; playerIndex < 4; playerIndex++)
    {
      Color playerColor;
      switch (playerIndex)
      {
        case 0:
          playerColor = AppColors.player1;
          break;
        case 1:
          playerColor = AppColors.player2;
          break;
        case 2:
          playerColor = AppColors.player3;
          break;
        default:
          playerColor = AppColors.player4;
      }
      for (int pawnIndex = 0; pawnIndex < 4; pawnIndex++)
      {
        playerPawns.add(SizedBox.expand(
          child: AnimatedBuilder(
            builder: (_, child) => CustomPaint(painter: PlayersPainter(playerCurrentSpot: _playerAnimList[playerIndex][pawnIndex].value, playerColor: playerColor)),
            animation: _playerAnimList[playerIndex][pawnIndex],
          ),
        ));
      }
    }

    return playerPawns;
  }

  _initData()
  {
    for (int playerIndex = 0; playerIndex < _playerTracks.length; playerIndex++)
    {
      List<Animation<Offset>> currentPlayerAnimList = [];
      List<AnimationController> currentPlayerAnimContList = [];
      List<MapEntry<int, Rect>> currentStepInfoList = [];
      for (int pawnIndex = 0; pawnIndex < _playerTracks[playerIndex].length; pawnIndex++)
      {
        AnimationController currentAnimCont = AnimationController(duration: Duration(milliseconds: _forwardStepAnimTimeInMillis), vsync: this)
          ..addStatusListener((status)
          {
            if (status == AnimationStatus.completed)
            {
              if (!_collisionDetails.isReverse) _stepCounter++;
              _movePawn();
            }
          });

        currentPlayerAnimContList.add(currentAnimCont);
        currentPlayerAnimList.add(Tween(begin: _playerTracks[playerIndex][pawnIndex][0].center, end: _playerTracks[playerIndex][pawnIndex][1].center).animate(currentAnimCont));
        currentStepInfoList.add(MapEntry(0, _playerTracks[playerIndex][pawnIndex][0]));
      }
      _playerAnimContList.add(currentPlayerAnimContList);
      _playerAnimList.add(currentPlayerAnimList);
      _pawnCurrentStepInfo.add(currentStepInfoList);
      _winnerPawnList.add([]);
    }

    var playerTrack = _playerTracks[0][0];

    _safeSpots =
    [
      playerTrack[1],
      playerTrack[9],
      playerTrack[14],
      playerTrack[22],
      playerTrack[27],
      playerTrack[35],
      playerTrack[40],
      playerTrack[48]
    ];
  }

  _handleClick(Offset clickOffset)
  {
    if (!_diceHighlightAnimCont.isAnimating)
    {
      if (_stepCounter == 0)
      {
        for (int pawnIndex = 0; pawnIndex < _pawnCurrentStepInfo[_currentTurn].length; pawnIndex++)
        {
          if (_pawnCurrentStepInfo[_currentTurn][pawnIndex].value.contains(clickOffset))
          {
            var clickedPawnIndex = _pawnCurrentStepInfo[_currentTurn][pawnIndex].key;
            if (clickedPawnIndex == 0)
            {
              if (_diceOutput == 6)
              {
                _diceOutput = 1;
              }
              else
              {
                break;
              }
            }
            else if (clickedPawnIndex + _diceOutput > _maxTrackIndex)
            {
              break;
            }

            _playerHighlightAnimCont.reset();
            _selectedPawnIndex = pawnIndex;

            _movePawn(considerCurrentStep: true);

            break;
          }
        }
      }
    }
  }

  _checkDiceResultValidity()
  {
    var isValid = false;

    for (var stepInfo in _pawnCurrentStepInfo[_currentTurn])
    {
      if (_diceOutput == 6)
      {
        if (_straightSixesCounter == 3)
        {
          break;
        }
        else if (stepInfo.key + _diceOutput > _maxTrackIndex)
        {
          continue;
        }

        _provideFreeTurn = true;
        isValid = true;
        break;
      }
      else if (stepInfo.key != 0)
      {
        if (stepInfo.key + _diceOutput <= _maxTrackIndex)
        {
          isValid = true;
          break;
        }
      }
    }

    if (!isValid) _changeTurn();
  }

  _movePawn({bool considerCurrentStep = false})
  {
    int playerIndex, pawnIndex, currentStepIndex;

    if (_collisionDetails.isReverse)
    {
      playerIndex = _collisionDetails.targetPlayerIndex;
      pawnIndex = _collisionDetails.pawnIndex;
      currentStepIndex = max(_pawnCurrentStepInfo[playerIndex][pawnIndex].key - (considerCurrentStep ? 0 : 1), 0);
    }
    else
    {
      playerIndex = _currentTurn;
      pawnIndex = _selectedPawnIndex;
      currentStepIndex = min(_pawnCurrentStepInfo[playerIndex][pawnIndex].key + (considerCurrentStep ? 0 : 1), _maxTrackIndex);
    }

    //update current step info in the [_pawnCurrentStepInfo] list
    var currentStepInfo = MapEntry(currentStepIndex, _playerTracks[playerIndex][pawnIndex][currentStepIndex]);
    _pawnCurrentStepInfo[playerIndex][pawnIndex] = currentStepInfo;
    var animCont = _playerAnimContList[playerIndex][pawnIndex];

    if (_collisionDetails.isReverse)
    {
      if (currentStepIndex > 0)
      {
        _playerAnimList[_collisionDetails.targetPlayerIndex]
        [_collisionDetails.pawnIndex] = Tween(
            begin: currentStepInfo.value.center,
            end: _playerTracks[_collisionDetails.targetPlayerIndex][_collisionDetails.pawnIndex][currentStepIndex - 1].center).animate(animCont);
        animCont.forward(from: 0.0);
      }
      else
      {
        _playerAnimContList[playerIndex][pawnIndex].duration = Duration(milliseconds: _forwardStepAnimTimeInMillis);
        _collisionDetails.isReverse = false;
        _provideFreeTurn = true;
        _changeTurn();
      }
    }
    else if (_stepCounter != _diceOutput)
    {
      _playerAnimList[playerIndex][pawnIndex] = Tween(
              begin: currentStepInfo.value.center,
              end: _playerTracks[playerIndex][pawnIndex][min(currentStepIndex + 1, _maxTrackIndex)].center)
          .animate(CurvedAnimation(
              parent: animCont,
              curve: const Interval(0.0, 0.5, curve: Curves.easeOutCubic)));
      animCont.forward(from: 0.0);
    }
    else
    {
      if (_checkCollision(currentStepInfo))
      {
        _movePawn(considerCurrentStep: true);
      }
      else
      {
        if (currentStepIndex == _maxTrackIndex)
        {
          _winnerPawnList[_currentTurn].add(_selectedPawnIndex);

          if (_winnerPawnList[_currentTurn].length < 4)
          {
            _provideFreeTurn =
            true;
          }
          else
          {
            _resultNotifier.rebuildPaint(_currentTurn);
            _provideFreeTurn =
            false;
          }
        }

        _changeTurn();
      }
    }
  }

  bool _checkCollision(MapEntry<int, Rect> currentStepInfo)
  {
    var currentStepCenter = currentStepInfo.value.center;

    if (currentStepInfo.key < 52)
    {
      if (!_safeSpots.any((safeSpot)
      {
        return safeSpot.contains(currentStepCenter);
      }))
      {
        List<CollisionDetails> collisions = [];
        for (int playerIndex = 0; playerIndex < _pawnCurrentStepInfo.length; playerIndex++)
        {
          for (int pawnIndex = 0; pawnIndex < _pawnCurrentStepInfo[playerIndex].length; pawnIndex++)
          {
            if (playerIndex != _currentTurn || pawnIndex != _selectedPawnIndex)
              {
                if (_pawnCurrentStepInfo[playerIndex][pawnIndex].value.contains(currentStepCenter))
                {
                  collisions.add(CollisionDetails()..pawnIndex = pawnIndex..targetPlayerIndex = playerIndex);
                }
              }
          }
        }


        if (collisions.isEmpty || collisions.any((collision)
        {
          return collision.targetPlayerIndex == _currentTurn;
        }) || collisions.length > 1)
        {
          _collisionDetails.isReverse = false;
        }
        else
        {
          _collisionDetails = collisions.first;
          _playerAnimContList[_collisionDetails.targetPlayerIndex]
          [_collisionDetails.pawnIndex].duration = Duration(milliseconds: _reverseStepAnimTimeInMillis);
          _collisionDetails.isReverse = true;
        }
      }
    }
    return _collisionDetails.isReverse;
  }

  _changeTurn()
  {
    if (_winnerPawnList.where((playerPawns)
    {
      return playerPawns.length == 4;
    }).length != 3)
    {
      _highlightDice();
      _stepCounter = 0;
      if (!_provideFreeTurn)
      {
        do
        {
          _currentTurn = (_currentTurn + 1) % 4;
          if (_winnerPawnList[_currentTurn].length != 4)
          {
            break;
          }
        } while (true);
        _straightSixesCounter = 0;
      }
      else if (_diceOutput != 6)
      {
        _straightSixesCounter =
            0;
      }

      if (!_playerHighlightAnimCont.isAnimating) _highlightCurrentPlayer();
      _provideFreeTurn = false;
    }
  }

  _highlightCurrentPlayer()
  {
    _playerHighlightAnimCont.repeat(reverse: true);
  }

  _highlightDice()
  {
    _diceHighlightAnimCont.repeat();
  }
}

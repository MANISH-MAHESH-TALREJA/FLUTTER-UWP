import 'package:flutter/material.dart';
import 'package:games/analog_clock/flutter_analog_clock.dart';
import 'package:games/games/2048/home.dart';
import 'package:games/games/bugs/bugs_game.dart';
import 'package:games/games/ludo/game.dart';
import 'package:games/games/memory_game/main.dart';
import 'package:games/games/mine_sweeper/widget/game.dart';
import 'package:games/games/pacman/homepage.dart';
import 'package:games/games/snake_game/snake.dart';
import 'package:games/games/tic_tac_toe/tic_tac_toe.dart';
import 'package:games/sidebar_bigeagle/side_bar_button_flat.dart';
import 'package:games/sidebar_bigeagle/sidebar_bigeagle.dart';
import 'analog_clock/flutter_analog_clock.dart';
import 'games/carrom/views/game_page.dart';
import 'games/dice/main.dart';
import 'games/memory_game/main.dart';

// ignore: use_key_in_widget_constructors
class HomePage extends StatefulWidget
{
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
{

  int _selectedIndex = 0;
  List<Widget> pages = [];
  List<Widget> views = [];
  @override
  void initState()
  {
    super.initState();
    pages =
    [
      const Text("LUDO"),
      const Text("PACMAN"),
      const Text("SNAKE GAME"),
      const Text("RIDING GAME"),
      const Text("BOMBERMAN"),
      const Text("PAIR GAME"),
      const Text("CARROM"),
      const Text("TIC TAC TOE"),
      const Text("CHESS"),
      const Text("TETRIS"),
    ];
    views =
    [
      FludoGame(),
      Pacman(),
      TicTacToe(),
      BugsApp(),
      const CleanStrike(gameType: 1, key: Key("CARROM")),
      GameActivity(),
      const DicePage(key: Key(""),),
      MemoryGame(),
      Game2048(),
      SnakeGame(),
    ];
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: Colors.pink,
      body: Row(
        children:
        [
          SideBar(
              color: Colors.pink,
              backgroundColor: Colors.transparent,
              appColor: Colors.white,
              accentColor: Colors.white,
              onHoverScale: 1.2,
              logo: FlutterAnalogClock(
                // ignore: prefer_const_literals_to_create_immutables
                hourNumbers: ['I', 'II', 'III', 'IV', 'V', 'VI', 'VII', 'VIII', 'IX', 'X', 'XI', 'XII'],
                dialPlateColor: Colors.yellow,
                hourHandColor: Colors.red,
                minuteHandColor: Colors.green,
                tickColor: Colors.green,
                numberColor: Colors.blueAccent,
                centerPointColor: Colors.white,
                borderWidth: 0,
                showSecondHand: true,
                showTicks: true,
                dateTime: DateTime.now(),
                secondHandColor: Colors.black,
                borderColor: Colors.black,
                showBorder: true,
                showMinuteHand: true,
                showNumber: true,
                hourNumberScale: 1,
                isLive: true,
                width: 150.0,
                height: 150.0,
                decoration: const BoxDecoration(),
                key: const Key("MY CLOCK"),
                child: const Text(''),
              ),
              children: [
                SideBarButtonFlat(title: "LUDO", icon: Icons.all_inclusive_outlined),
                SideBarButtonFlat(title: "PACMAN", icon: Icons.accessibility),
                SideBarButtonFlat(title: "TIC TAC TOE", icon: Icons.close_outlined),
                SideBarButtonFlat(title: "BUGS", icon: Icons.animation),
                SideBarButtonFlat(title: "CARROM", icon: Icons.adjust),
                SideBarButtonFlat(title: "MINE SWEEPER", icon: Icons.ac_unit_sharp),
                SideBarButtonFlat(title: "DICE GAME", icon: Icons.dashboard_rounded),
                SideBarButtonFlat(title: "MEMORY GAME", icon: Icons.sentiment_very_satisfied),
                SideBarButtonFlat(title: "2048 GAME", icon: Icons.whatshot_outlined),
                SideBarButtonFlat(title: "SNAKE GAME", icon: Icons.voicemail_outlined),
              ],
              onChange: (value)
              {
                setState(()
                {
                  _selectedIndex = value;
                });
              }, key: const Key("MY KEY"),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top : 10.0, right : 10.0, bottom : 10.0),
              child: Card(
                  elevation: 2,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),

                  ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(30.0), child: views[_selectedIndex])),
            ),
          )
        ],
      ),
    );
  }
}
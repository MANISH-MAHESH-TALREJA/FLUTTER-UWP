import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

// ignore: use_key_in_widget_constructors
class TicTacToe extends StatefulWidget 
{
  @override
  _TicTacToeState createState() => _TicTacToeState();
}

class _TicTacToeState extends State<TicTacToe> 
{
  AssetImage circle = const AssetImage('assets/images/tic_tac_toe/circle.png');
  AssetImage cross = const AssetImage('assets/images/tic_tac_toe/cross.png');
  AssetImage edit = const AssetImage('assets/images/tic_tac_toe/edit.png');

  bool isCross = true;
  late List<String> gameState;

  @override
  void initState() 
  {
    super.initState();
    setState(() 
    {
      gameState = 
      [
        "empty",
        "empty",
        "empty",
        "empty",
        "empty",
        "empty",
        "empty",
        "empty",
        "empty",
      ];
    });
  }

  AlertStyle alertStyle = AlertStyle(
    animationType: AnimationType.grow,
    animationDuration: const Duration(
      milliseconds: 500,
    ),
    alertBorder: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0),
    ),
    titleStyle: const TextStyle(
      fontSize: 30.0,
      fontWeight: FontWeight.bold,
    ),
  );

  void playGame(int index) 
  {
    if (gameState[index] == 'empty') 
    {
      setState(() {
        if (isCross) {
          gameState[index] = 'cross';
        } else {
          gameState[index] = 'circle';
        }
        isCross = !isCross;
        checkWin();
      });
    }
  }

  alertDialogueBoxForWin(context, index) {
    Alert(
      closeFunction: resetGame,
      context: context,
      title: '${gameState[index]} WON',
      buttons: [
        DialogButton(
          child: const Text(
            'OK',
            style: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
      image: Image(
        image: getImage(gameState[index]),
        height: 80.0,
        width: 80.0,
        fit: BoxFit.cover,
      ),
      style: alertStyle,
    ).show();
  }

  alertDialogueBoxForDraw(context) 
  {
    Alert(
      context: context,
      closeFunction: resetGame,
      title: 'GAME DRAW',
      buttons: [
        DialogButton(
          child: const Text(
            'OK',
            style: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        // ignore: prefer_const_literals_to_create_immutables
        children: <Widget>
        [
          const Image(
            image: AssetImage("assets/images/tic_tac_toe/cross.png"),
            height: 80.0,
            width: 80.0,
            fit: BoxFit.cover,
          ),
          const Image(
            image: AssetImage("assets/images/tic_tac_toe/circle.png"),
            height: 80.0,
            width: 80.0,
            fit: BoxFit.cover,
          ),
        ],
      ),
      style: alertStyle,
    ).show();
  }

  void checkWin() 
  {
    if ((gameState[0] != 'empty') &&
        (gameState[0] == gameState[1]) &&
        (gameState[1] == gameState[2])) {
      setState(() {
        alertDialogueBoxForWin(context, 0);
        resetGame();
      });
    } else if ((gameState[3] != 'empty') &&
        (gameState[3] == gameState[4]) &&
        (gameState[4] == gameState[5])) {
      setState(() {
        alertDialogueBoxForWin(context, 3);
        resetGame();
      });
    } else if ((gameState[6] != 'empty') &&
        (gameState[6] == gameState[7]) &&
        (gameState[7] == gameState[8])) {
      setState(() {
        alertDialogueBoxForWin(context, 6);
        resetGame();
      });
    } else if ((gameState[0] != 'empty') &&
        (gameState[0] == gameState[3]) &&
        (gameState[3] == gameState[6])) {
      setState(() {
        alertDialogueBoxForWin(context, 0);
        resetGame();
      });
    } else if ((gameState[1] != 'empty') &&
        (gameState[1] == gameState[4]) &&
        (gameState[4] == gameState[7])) {
      setState(() {
        alertDialogueBoxForWin(context, 1);
        resetGame();
      });
    } else if ((gameState[2] != 'empty') &&
        (gameState[2] == gameState[5]) &&
        (gameState[5] == gameState[8])) {
      setState(() {
        alertDialogueBoxForWin(context, 2);
        resetGame();
      });
    } else if ((gameState[0] != 'empty') &&
        (gameState[0] == gameState[4]) &&
        (gameState[4] == gameState[8])) {
      setState(() {
        alertDialogueBoxForWin(context, 0);
        resetGame();
      });
    } else if ((gameState[2] != 'empty') &&
        (gameState[2] == gameState[4]) &&
        (gameState[4] == gameState[6])) {
      setState(() {
        alertDialogueBoxForWin(context, 2);
        resetGame();
      });
    } else if (!gameState.contains('empty')) {
      setState(() {
        alertDialogueBoxForDraw(context);
        resetGame();
      });
    }
  }

  getImage(String value)
  {
    switch (value)
    {
      case ('empty'):
        return edit;
      case ('cross'):
        return cross;
      case ('circle'):
        return circle;
    }
  }

  void resetGame()
  {
    setState(()
    {
      gameState = [
        "empty",
        "empty",
        "empty",
        "empty",
        "empty",
        "empty",
        "empty",
        "empty",
        "empty",
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>
        [
          Container(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children:
              [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children:
                  [
                    myCard(0), myCard(1), myCard(2)
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children:
                  [
                    myCard(3), myCard(4), myCard(5)
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children:
                  [
                    myCard(6), myCard(7), myCard(8)
                  ],
                )
              ],
            ),
          ),
          /*Container(
            padding: const EdgeInsets.all(10.0),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.0,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
              ),
              itemCount: 9,
              // ignore: sized_box_for_whitespace
              itemBuilder: (context, i) => Container(
                height: MediaQuery.of(context).size.height*0.25,
                width: MediaQuery.of(context).size.height*0.25,
                child: MaterialButton(
                  onPressed: () {
                    playGame(i);
                  },
                  child: Image(
                    image: getImage(gameState[i]),
                  ),
                ),
              ),
            ),
          ),*/
          Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 5.0),
            child: MaterialButton(
              minWidth: 250.0,
              height: 40.0,
              color: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              onPressed: () {
                resetGame();
              },
              child: const Text(
                'RESET GAME',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 27.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget myCard(int index)
  {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: MediaQuery.of(context).size.height*0.2,
        width: MediaQuery.of(context).size.width*0.2,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.blueAccent, width: 1.0),
            borderRadius: BorderRadius.circular(15),
        ),
        child: MaterialButton(
          onPressed: ()
          {
            playGame(index);
          },
          child: Image(
            image: getImage(gameState[index]),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'common.dart';
import 'game.dart';

class DicePage extends StatefulWidget
{
  const DicePage({required Key key}) : super(key: key);

  @override
  _DicePageState createState() => _DicePageState();
}

class _DicePageState extends State<DicePage>
{
  var game = Game(3);

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          controller: ScrollController(),
          scrollDirection: Axis.vertical,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  color: Colors.white,
                  //margin: const EdgeInsets.only(top: 50.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>
                      [
                        const Text(
                          "LEADERBOARD",
                          style: TextStyle(fontSize: 25.0, letterSpacing: 10),
                        ),
                        const Divider(
                          color: Colors.black,
                          thickness: 2,
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            CustomText(
                              game.first.name.toUpperCase(),
                              color: Colors.black,
                            ),
                            Text(game.first.score.toString())
                          ],
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>
                          [
                            CustomText(
                              game.second.name.toUpperCase(),
                              color: Colors.black,
                            ),
                            Text(game.second.score.toString())
                          ],
                        ),
                        const SizedBox(
                          height: 10.0,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height*0.5,
                    width: MediaQuery.of(context).size.width*0.3,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset("assets/images/dice/dice${game.first.diceNumber}.png", color: Colors.red,),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height*0.5,
                    width: MediaQuery.of(context).size.width*0.3,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset("assets/images/dice/dice${game.second.diceNumber}.png", color: Colors.red),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        style: ButtonStyle(foregroundColor: MaterialStateProperty.all(const Color(0xFF0A73BF))),
                        onPressed: game.first.turn && !game.disable ? () => onPlayer1PressButton() : null,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomText(
                            game.first.name,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        style: ButtonStyle(foregroundColor: MaterialStateProperty.all(const Color(0xFF0A73BF))),
                        onPressed: game.second.turn && !game.disable ? () => onPlayer2PressButton() : null,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomText(game.second.name),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              game.hasWinner() ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(top: 40.0),
                    child: getCustomText(),
                  ),
                  TextButton(
                    style: ButtonStyle(foregroundColor: MaterialStateProperty.all(Colors.blue), textStyle: MaterialStateProperty.all(const TextStyle(color: Colors.white))),
                    child: const Text("RESTART"),
                    onPressed: ()
                    {
                      setState(()
                      {
                        game.start();
                      });
                    },
                  )
                ],
              ) : const SizedBox(height: 10,)
            ],
          ),
        ),
      ),
    );
  }

  onPlayer1PressButton()
  {
    setState(()
    {
      game.first.shuffle();
      game.switchTurn();
    });
  }

  onPlayer2PressButton()
  {
    setState(()
    {
      game.second.shuffle();
      game.switchTurn();
      game.calculateRound();
    });
  }

  getCustomText()
  {
    if (game.hasWinner())
    {
      return CustomText("PLAYER ${game.winner} HAS WON !!!", color: Colors.amber,);
    }
    else
    {
      return CustomText("PLAY UNTIL YOU SCORE ${game.limit}!");
    }
  }
}

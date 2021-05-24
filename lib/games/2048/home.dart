import 'package:flutter/material.dart';
import 'mycolor.dart';
import 'tile.dart';
import 'grid.dart';
import 'game.dart';
import 'dart:async';

// ignore: use_key_in_widget_constructors
class Game2048 extends StatefulWidget
{
  @override
  State<StatefulWidget> createState()
  {
    return _HomePageState();
  }
}

class _HomePageState extends State<Game2048>
{
  List<List<int>> grid = [];
  List<List<int>> gridNew = [];
  int score = 0;
  bool isMyGameOver = false;
  bool isMyGameWon = false;

  List<Widget> getGrid(double width, double height)
  {
    List<Widget> grids = [];
    for (int i = 0; i < 4; i++)
    {
      for (int j = 0; j < 4; j++)
      {
        int num = grid[i][j];
        String number;
        int color;
        if (num == 0)
        {
          color = MyColor.emptyGridBackground;
          number = "";
        }
        else if (num == 2 || num == 4)
        {
          color = MyColor.gridColorTwoFour;
          number = "$num";
        }
        else if (num == 8 || num == 64 || num == 256)
        {
          color = MyColor.gridColorEightSixtyFourTwoFiftySix;
          number = "$num";
        }
        else if (num == 16 || num == 32 || num == 1024)
        {
          color = MyColor.gridColorSixteenThirtyTwoOneZeroTwoFour;
          number = "$num";
        }
        else if (num == 128 || num == 512)
        {
          color = MyColor.gridColorOneTwentyEightFiveOneTwo;
          number = "$num";
        }
        else
        {
          color = MyColor.gridColorWin;
          number = "$num";
        }
        double size = 0.0;
        String n = number;
        switch (n.length)
        {
          case 1:
            size = MediaQuery.of(context).size.height*0.05;
            break;
          case 2:
            size = MediaQuery.of(context).size.height*0.05;
            break;
          case 3:
            size = MediaQuery.of(context).size.height*0.05;
            break;
          case 4:
            size = MediaQuery.of(context).size.height*0.05;
            break;
        }
        grids.add(Tile(number, width, height, color, size));
      }
    }
    return grids;
  }

  void handleGesture(int direction)
  {
    bool flipped = false;
    bool played = true;
    bool rotated = false;
    if (direction == 0)
    {
      setState(()
      {
        grid = transposeGrid(grid);
        grid = flipGrid(grid);
        rotated = true;
        flipped = true;
      });
    }
    else if (direction == 1)
    {
      setState(()
      {
        grid = transposeGrid(grid);
        rotated = true;
      });
    }
    else if (direction == 2)
    {

    }
    else if (direction == 3)
    {
      setState(()
      {
        grid = flipGrid(grid);
        flipped = true;
      });
    }
    else
    {
      played = false;
    }

    if (played)
    {
      List<List<int>> past = copyGrid(grid);
      for (int i = 0; i < 4; i++)
      {
        setState(()
        {
          List result = operate(grid[i], score);
          score = result[0];
          grid[i] = result[1];
        });
      }
      setState(()
      {
        grid = addNumber(grid, gridNew);
      });
      bool changed = compare(past, grid);
      if (flipped)
      {
        setState(()
        {
          grid = flipGrid(grid);
        });
      }

      if (rotated)
      {
        setState(()
        {
          grid = transposeGrid(grid);
        });
      }

      if (changed)
      {
        setState(()
        {
          grid = addNumber(grid, gridNew);
        });
      }
      else
      {

      }

      bool allGameOver = isGameOver(grid);
      if (allGameOver)
      {
        setState(()
        {
          isMyGameOver = true;
        });
      }

      bool allGameWon = isGameWon(grid);
      if (allGameWon)
      {
        setState(()
        {
          isMyGameWon=true;
        });
      }
    }
  }

  @override
  void initState()
  {
    grid = blankGrid();
    gridNew = blankGrid();
    addNumber(grid, gridNew);
    addNumber(grid, gridNew);
    super.initState();
  }

  Future<String> getHighScore() async
  {
    int score = 0;
    return score.toString();
  }

  @override
  Widget build(BuildContext context)
  {
    double width = MediaQuery.of(context).size.width;
    double gridWidth = (width - 80) / 4;
    double gridHeight = gridWidth;
    double height = 30 + (gridHeight * 4) + 10;

    return Scaffold(
      body: SingleChildScrollView(
        controller: ScrollController(),
        child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                width: 200.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Color(MyColor.gridBackground),
                ),
                height: 82.0,
                child: Column(
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.only(top: 10.0, bottom: 2.0),
                      child: Text(
                        'SCORE',
                        style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.white70,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Text(
                        '$score',
                        style: const TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: GestureDetector(
                      child: GridView.count(
                        physics: const NeverScrollableScrollPhysics(),
                        controller: ScrollController(),
                        shrinkWrap: true,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                        crossAxisCount: 4,
                        childAspectRatio: MediaQuery.of(context).size.aspectRatio*1.38,
                        children: getGrid(gridWidth, gridHeight),
                      ),
                      onVerticalDragEnd: (DragEndDetails details)
                      {
                        if (details.primaryVelocity! < 0)
                        {
                          handleGesture(0);
                        }
                        else if (details.primaryVelocity! > 0)
                        {
                          handleGesture(1);
                        }
                      },
                      onHorizontalDragEnd: (details)
                      {
                        if (details.primaryVelocity! > 0)
                        {
                          handleGesture(2);
                        }
                        else if (details.primaryVelocity! < 0)
                        {
                          handleGesture(3);
                        }
                      },
                    ),
                  ),
                  isMyGameOver
                      ? Container(
                          height: height,
                          color: Color(MyColor.transparentWhite),
                          child: Center(
                            child: Text(
                              'GAME OVER !',
                              style: TextStyle(
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(MyColor.gridBackground)),
                            ),
                          ),
                        )
                      : const SizedBox(),
                  isMyGameWon
                      ? Container(
                          height: height,
                          color: Color(MyColor.transparentWhite),
                          child: Center(
                            child: Text(
                              'YOU WON !!!',
                              style: TextStyle(
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(MyColor.gridBackground)),
                            ),
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
              color: Color(MyColor.gridBackground),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Color(MyColor.gridBackground),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: IconButton(
                        iconSize: 35.0,
                        icon: const Icon(
                          Icons.refresh,
                          color: Colors.white70,
                        ),
                        onPressed: ()
                        {
                          setState(()
                          {
                            grid = blankGrid();
                            gridNew = blankGrid();
                            grid = addNumber(grid, gridNew);
                            grid = addNumber(grid, gridNew);
                            score = 0;
                            isMyGameOver=false;
                            isMyGameWon=false;
                          });
                        },
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Color(MyColor.gridBackground),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: <Widget>[
                          const Text(
                            'HIGH SCORE',
                            style: TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.bold),
                          ),
                          FutureBuilder<String>(
                            future: getHighScore(),
                            builder: (ctx, snapshot)
                            {
                              if (snapshot.hasData)
                              {
                                return Text(
                                  snapshot.data!,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                );
                              }
                              else
                              {
                                return const Text(
                                  '0',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                );
                              }
                            },
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
      ),
    );
  }
}

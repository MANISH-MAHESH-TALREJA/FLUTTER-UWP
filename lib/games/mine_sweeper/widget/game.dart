import 'dart:math';
import 'package:flutter/material.dart';
import 'package:games/games/mine_sweeper/data/board_square.dart';
import 'package:games/games/mine_sweeper/utils/image_utils.dart';

// ignore: use_key_in_widget_constructors
class GameActivity extends StatefulWidget
{
  @override
  _GameActivityState createState() => _GameActivityState();
}

class _GameActivityState extends State<GameActivity>
{

  int rowCount = 18;
  int columnCount = 10;
  late List<List<BoardSquare>> board;
  late List<bool> openedSquares;
  late List<bool> flaggedSquares;
  int bombProbability = 3;
  int maxProbability = 15;
  int bombCount = 0;
  int squaresLeft = 0;

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Container(
            color: Colors.grey,
            height: 60,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  onTap: ()
                  {
                    _initializeGame();
                  },
                  child: const CircleAvatar(
                    child: Icon(
                      Icons.tag_faces,
                      color: Colors.black,
                      size: 40,
                    ),
                    backgroundColor: Colors.yellowAccent,
                  ),
                )
              ],
            ),
          ),
          // THE GRID VIEW OF SQUARES
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            controller: ScrollController(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: columnCount, childAspectRatio: MediaQuery.of(context).size.aspectRatio*1.9, mainAxisSpacing: 5, crossAxisSpacing: 5),
            itemBuilder: (context, position)
            {
              int rowNumber = (position / columnCount).floor();
              int columnNumber = (position % columnCount);

              Image image;
              if (openedSquares[position] == false)
              {
                if (flaggedSquares[position] == true)
                {
                  image = getImage(ImageType.flagged);
                }
                else
                {
                  image = getImage(ImageType.facingDown);
                }
              }
              else
              {
                if (board[rowNumber][columnNumber].hasBomb)
                {
                  image = getImage(ImageType.bomb);
                }
                else
                {
                  image = getImage(getImageTypeFromNumber(board[rowNumber][columnNumber].bombsAround),);
                }
              }

              return InkWell(
                onTap: ()
                {
                  if (board[rowNumber][columnNumber].hasBomb)
                  {
                    _handleGameOver();
                  }
                  if (board[rowNumber][columnNumber].bombsAround == 0)
                  {
                    _handleTap(rowNumber, columnNumber);
                  }
                  else
                  {
                    setState(()
                    {
                      openedSquares[position] = true;
                      squaresLeft = squaresLeft - 1;
                    });
                  }

                  if(squaresLeft <= bombCount)
                  {
                    _handleWin();
                  }

                },

                onLongPress: ()
                {
                  if (openedSquares[position] == false)
                  {
                    setState(()
                    {
                      flaggedSquares[position] = true;
                    });
                  }
                },
                //splashColor: Colors.grey,
                child: Container(
                  //color: Colors.grey,
                  child: image,
                ),
              );
            },
            itemCount: rowCount * columnCount,
          ),
          const SizedBox(height: 5,)
        ],
      ),
    );
  }

  @override
  void initState()
  {
    super.initState();
    _initializeGame();
  }

  void _initializeGame()
  {
    board = List.generate(rowCount, (i)
    {
      return List.generate(columnCount, (j)
      {
        return BoardSquare();
      });
    });


    openedSquares = List.generate(rowCount * columnCount, (i)
    {
      return false;
    });

    flaggedSquares = List.generate(rowCount * columnCount, (i)
    {
      return false;
    });

    bombCount = 0;
    squaresLeft = rowCount * columnCount;

    Random random = Random();
    for (int i = 0; i < rowCount; i++)
    {
      for (int j = 0; j < columnCount; j++)
      {
        int randomNumber = random.nextInt(maxProbability);
        if (randomNumber < bombProbability)
        {
          board[i][j].hasBomb = true;
          bombCount++;
        }
      }
    }

    // Check bombs around and assign numbers
    for (int i = 0; i < rowCount; i++)
    {
      for (int j = 0; j < columnCount; j++)
      {
        if (i > 0 && j > 0)
        {
          if (board[i - 1][j - 1].hasBomb)
          {
            board[i][j].bombsAround++;
          }
        }

        if (i > 0)
        {
          if (board[i - 1][j].hasBomb)
          {
            board[i][j].bombsAround++;
          }
        }

        if (i > 0 && j < columnCount - 1)
        {
          if (board[i - 1][j + 1].hasBomb)
          {
            board[i][j].bombsAround++;
          }
        }

        if (j > 0)
        {
          if (board[i][j - 1].hasBomb)
          {
            board[i][j].bombsAround++;
          }
        }

        if (j < columnCount - 1)
        {
          if (board[i][j + 1].hasBomb)
          {
            board[i][j].bombsAround++;
          }
        }

        if (i < rowCount - 1 && j > 0)
        {
          if (board[i + 1][j - 1].hasBomb)
          {
            board[i][j].bombsAround++;
          }
        }

        if (i < rowCount - 1)
        {
          if (board[i + 1][j].hasBomb)
          {
            board[i][j].bombsAround++;
          }
        }

        if (i < rowCount - 1 && j < columnCount - 1)
        {
          if (board[i + 1][j + 1].hasBomb)
          {
            board[i][j].bombsAround++;
          }
        }
      }
    }

    setState(() {});
  }

  void _handleGameOver()
  {
    showDialog(
        context: context,
        builder: (context)
        {
          return AlertDialog(
            title: const Text("Game Over :("),
            content: const Text("You click a bomb"),
            actions: <Widget>
            [
              TextButton(
                onPressed: ()
                {
                  _initializeGame();
                  Navigator.pop(context);
                },
                child: const Text("Play again"),
              )
            ],
          );
        }
    );
  }

  void _handleWin()
  {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Congratulations!!!"),
            content: const Text("You win the game"),
            actions: <Widget>[
              TextButton(
                onPressed: ()
                {
                  _initializeGame();
                  Navigator.pop(context);
                },
                child: const Text("Play again"),
              )
            ],
          );
        }
    );
  }


  void _handleTap(int i , int j)
  {
    int position = (i * columnCount) + j;
    openedSquares[position] = true;
    squaresLeft = squaresLeft - 1;

    if (i > 0)
    {
      if (!board[i - 1][j].hasBomb && openedSquares[((i - 1) * columnCount) + j] != true)
      {
        if (board[i][j].bombsAround == 0)
        {
          _handleTap(i - 1, j);
        }
      }
    }

    if (j > 0)
    {
      if (!board[i][j - 1].hasBomb && openedSquares[(i * columnCount) + j - 1] != true)
      {
        if (board[i][j].bombsAround == 0)
        {
          _handleTap(i, j - 1);
        }
      }
    }

    if (j < columnCount - 1)
    {
      if (!board[i][j + 1].hasBomb && openedSquares[(i * columnCount) + j + 1] != true)
      {
        if (board[i][j].bombsAround == 0)
        {
          _handleTap(i, j + 1);
        }
      }
    }

    if (i < rowCount - 1)
    {
      if (!board[i + 1][j].hasBomb && openedSquares[((i + 1) * columnCount) + j] != true)
      {
        if (board[i][j].bombsAround == 0)
        {
          _handleTap(i + 1, j);
        }
      }
    }
    setState(() {});
  }
}
import 'dart:async';
import 'package:flutter/material.dart';
import 'data/data.dart';
import 'models/tile_model.dart';

// ignore: use_key_in_widget_constructors
class MemoryGame extends StatefulWidget
{
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<MemoryGame>
{
  List<dynamic> gridViewTiles = <dynamic>[];
  List<dynamic> questionPairs = <dynamic>[];

  @override
  void initState()
  {
    super.initState();
    reStart();
  }

  void reStart()
  {
    myPairs = getPairs();
    myPairs.shuffle();

    gridViewTiles = myPairs;
    Future.delayed(const Duration(seconds: 5), ()
    {
      setState(()
      {
        questionPairs = getQuestionPairs();
        gridViewTiles = questionPairs;
        selected = false;
      });
    });
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            const SizedBox(
              height: 15,
            ),
            points != 800 ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "YOUR POINTS : $points / 800",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ],
            ) : Container(),
            const SizedBox(
              height: 20,
            ),
            points != 800 ? GridView(
              shrinkWrap: true,
              //physics: ClampingScrollPhysics(),
              scrollDirection: Axis.vertical,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: 10.0, /*maxCrossAxisExtent: 100.0*/ crossAxisCount: 4,  childAspectRatio: MediaQuery.of(context).size.aspectRatio*1.43,),
              children: List.generate(gridViewTiles.length, (index) {
                return Tile(
                  imagePathUrl: gridViewTiles[index].getImageAssetPath(),
                  tileIndex: index,
                  parent: this,
                );
              }),
            ) : Column(
              children: <Widget>[
                GestureDetector(
                  onTap: ()
                  {
                    setState(()
                    {
                      points = 0;
                      reStart();
                    });
                  },
                  child: Container(
                    height: 50,
                    width: 200,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Text("Replay", style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w500
                    ),),
                  ),
                ),
                const SizedBox(height: 20,),
                GestureDetector(
                  onTap: ()
                  {

                  },
                  child: Container(
                    height: 50,
                    width: 200,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.blue,
                          width: 2
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Text("Rate Us", style: TextStyle(
                      color: Colors.blue,
                      fontSize: 17,
                      fontWeight: FontWeight.w500
                    ),),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class Tile extends StatefulWidget
{
  String imagePathUrl;
  int tileIndex;
  _HomeState parent;

  // ignore: use_key_in_widget_constructors
  Tile({required this.imagePathUrl, required this.tileIndex, required this.parent});

  @override
  _TileState createState() => _TileState();
}

class _TileState extends State<Tile>
{
  @override
  Widget build(BuildContext context)
  {
    return GestureDetector(
      onTap: ()
      {
        if (!selected)
        {
          setState(()
          {
            myPairs[widget.tileIndex].setIsSelected(true);
          });
          if (selectedTile != "")
          {
            if (selectedTile == myPairs[widget.tileIndex].getImageAssetPath())
            {
              points = points + 100;
              TileModel tileModel = TileModel(isSelected: false, imageAssetPath: '');
              selected = true;
              Future.delayed(const Duration(seconds: 2), ()
              {
                tileModel.setImageAssetPath("");
                myPairs[widget.tileIndex] = tileModel;
                myPairs[selectedIndex] = tileModel;
                widget.parent.setState(() {});
                setState(()
                {
                  selected = false;
                });
                selectedTile = "";
              });
            }
            else
            {
              selected = true;
              Future.delayed(const Duration(seconds: 2), ()
              {
                widget.parent.setState(()
                {
                  myPairs[widget.tileIndex].setIsSelected(false);
                  myPairs[selectedIndex].setIsSelected(false);
                });
                setState(()
                {
                  selected = false;
                });
              });

              selectedTile = "";
            }
          }
          else
          {
            setState(()
            {
              selectedTile = myPairs[widget.tileIndex].getImageAssetPath();
              selectedIndex = widget.tileIndex;
            });
          }
        }
      },
      child: Container(
        margin: const EdgeInsets.all(5),
        child: myPairs[widget.tileIndex].getImageAssetPath() != ""
            ? Image.asset(myPairs[widget.tileIndex].getIsSelected()
                ? myPairs[widget.tileIndex].getImageAssetPath()
                : widget.imagePathUrl)
            : Container(
                color: Colors.white,
                child: Image.asset("assets/images/memory_game/correct.png"),
              ),
      ),
    );
  }
}

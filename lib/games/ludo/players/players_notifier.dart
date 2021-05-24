import 'package:flutter/material.dart';

class PlayersNotifier with ChangeNotifier
{
  bool _shouldPaintPlayers = false;

  get shouldPaintPlayers => _shouldPaintPlayers;

  void rebuildPaint()
  {
    _shouldPaintPlayers = true;
    notifyListeners();
  }
}

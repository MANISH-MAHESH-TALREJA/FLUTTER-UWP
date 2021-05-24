import 'package:games/games/carrom/models/player.dart';

class Game
{
  Game()
  {
    _blackCoins = 9;
    _redCoin = 1;
    _currentPlayer = 1;
    _score=0;
    _players = <Player>[];
    _players.add(Player());
    _players.add(Player());
  }

  int _blackCoins = 0;
  int _redCoin = 0;
  int _score = 0;
  int _currentPlayer = 0;
  List<Player> _players = [];

  bool _strike()
  {
    if (_blackCoins > 0)
    {
      _blackCoins -= 1;
      final int playerTurn = getCurrentPlayer() - 1;
      _score = getPlayerScore(playerTurn);
      _setPlayerScore(_score + 1, playerTurn);
      _players[playerTurn].setIdleCount(0);
      return _changePlayer();
    }
    return false;
  }

  bool _multiStrike(int scenario)
  {
    if (scenario == 2)
    {
      if (_blackCoins >= 1 && _redCoin == 1)
      {
        _redCoin -= 1;
        final int playerTurn = getCurrentPlayer() - 1;
        _score = getPlayerScore(playerTurn);
        _setPlayerScore(_score + 3, playerTurn);
        _players[playerTurn].setIdleCount(0);
        return _changePlayer();
      }
      return false;
    }
    else
    {
      if (_blackCoins > 1)
      {
        _blackCoins -= 2;
        final int playerTurn = getCurrentPlayer() - 1;
        _score = getPlayerScore(playerTurn);
        _setPlayerScore(_score + 2, playerTurn);
        _players[playerTurn].setIdleCount(0);
        return _changePlayer();
      }
      return false;
    }
  }

  bool _redStrike()
  {
    if (_redCoin == 1)
    {
      _redCoin = 0;
      final int playerTurn = getCurrentPlayer() - 1;
      _score = getPlayerScore(playerTurn);
      _setPlayerScore(_score + 3, playerTurn);
      _players[playerTurn].setIdleCount(0);
      return _changePlayer();
    }
    return false;
  }

  bool _strikerStrike()
  {
    final int playerTurn = getCurrentPlayer() - 1;
    _score = getPlayerScore(playerTurn);
    _setPlayerScore(_score - 1, playerTurn);
    _players[playerTurn].setFoulCount(_incrementFoulCount(playerTurn));
    _players[playerTurn].setIdleCount(_incrementIdleCount(playerTurn));
    return _changePlayer();
  }

  bool _defunctCoin(int scenario)
  {
    if (scenario == 2)
    {
      if (_redCoin == 1)
      {
        _redCoin = 0;
        final int playerTurn = getCurrentPlayer() - 1;
        _score = getPlayerScore(playerTurn);
        _setPlayerScore(_score - 2, playerTurn);
        _players[playerTurn].setFoulCount(_incrementFoulCount(playerTurn));
        _players[playerTurn].setIdleCount(_incrementIdleCount(playerTurn));
        return _changePlayer();
      }
      return false;
    }
    else
    {
      if (_blackCoins >= 1)
      {
        _blackCoins -= 1;
        final int playerTurn = getCurrentPlayer() - 1;
        _score = getPlayerScore(playerTurn);
        _setPlayerScore(_score - 2, playerTurn);
        _players[playerTurn].setFoulCount(_incrementFoulCount(playerTurn));
        _players[playerTurn].setIdleCount(_incrementIdleCount(playerTurn));
        return _changePlayer();
      }
      return false;
    }
  }

  bool _idlePass()
  {
    final int playerTurn = getCurrentPlayer() - 1;
    _players[playerTurn].setIdleCount(_incrementIdleCount(playerTurn));
    _changePlayer();
    return true;
  }

  bool _changePlayer()
  {
    final int player = getCurrentPlayer();
    switch (player)
    {
      case 1:
        {
          _currentPlayer = 2;
          return true;
        }
      case 2:
        {
          _currentPlayer = 1;
          return true;
        }
    }
    return false;
  }

  bool _isInfinite()
  {
    if (_players[0].getScore() + _getAvailablePoints() >= 5 || _players[1].getScore() + _getAvailablePoints() >= 5)
    {
      return false;
    }
    else
    {
      return true;
    }
  }

  int _incrementFoulCount(int player)
  {
    return _players[player].getFoulCount() + 1;
  }

  int _incrementIdleCount(int player)
  {
    return _players[player].getIdleCount() + 1;
  }

  int _getAvailablePoints()
  {
    return getBlackCoins() + (getRedCoins() * 3);
  }

  void _setPlayerScore(int score, int player)
  {
    _players[player].setScore(score);
  }

  void setRedCoins(int count)
  {
    _redCoin = count;
  }

  void setBlackCoins(int count)
  {
    _blackCoins = count;
  }

  int getBlackCoins()
  {
    return _blackCoins;
  }

  int getRedCoins()
  {
    return _redCoin;
  }

  int getCurrentPlayer()
  {
    return _currentPlayer;
  }

  int getPlayerScore(int player)
  {
    return _players[player].getScore();
  }

  gameWinner()
  {
    final bool endGame = _blackCoins == 0 && _redCoin == 0;
    final int player1score = _players[0].getScore();
    final int player2score = _players[1].getScore();
    if (_isInfinite())
    {
      return 0;
    }
    else
    {
      if (player1score > player2score)
      {
        if (player1score - player2score >= 3 && player1score >= 5)
        {
          return 1;
        }
        else
        {
          if (endGame)
          {
            return 0;
          }
          else
          {
            return -1;
          }
        }
      }
      else if (player2score >= player1score)
      {
        if (player2score - player1score >= 3 && player2score >= 5)
        {
          return 2;
        }
        else
        {
          if (endGame)
          {
            return 0;
          }
          else
          {
            return -1;
          }
        }
      }
    }
  }

  bool isFoul(int currentPlayer)
  {
    _score = getPlayerScore(currentPlayer - 1);
    if (_players[currentPlayer - 1].getFoulCount() == 3)
    {
      _setPlayerScore(_score - 1, currentPlayer - 1);
      _players[currentPlayer - 1].setFoulCount(0);
      return true;
    }
    return false;
  }

  bool isIdle(int currentPlayer)
  {
    _score = getPlayerScore(currentPlayer - 1);
    if (_players[currentPlayer - 1].getIdleCount() == 3)
    {
      _setPlayerScore(_score - 1, currentPlayer - 1);
      _players[currentPlayer - 1].setIdleCount(0);
      return true;
    }
    return false;
  }

  bool actions(int action, {int scenario = 0})
  {
    switch (action)
    {
      case 1:
        {
          return _strike();
        }
      case 2:
        {
          return _multiStrike(scenario);
        }
      case 3:
        {
          return _redStrike();
        }
      case 4:
        {
          return _strikerStrike();
        }
      case 5:
        {
          return _defunctCoin(scenario);
        }
      case 6:
        {
          return _idlePass();
        }
    }
    return false;
  }
}

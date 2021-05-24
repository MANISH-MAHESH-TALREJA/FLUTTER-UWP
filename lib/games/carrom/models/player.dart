class Player
{
  Player()
  {
    _score = 0;
    _idleCount = 0;
    _foulCount = 0;
  }

  int _score = 0;
  int _foulCount = 0;
  int _idleCount = 0;

  int getScore()
  {
    return _score;
  }

  int getFoulCount()
  {
    return _foulCount;
  }

  int getIdleCount()
  {
    return _idleCount;
  }

  void setScore(int score)
  {
    _score = score;
  }

  void setFoulCount(int fouls)
  {
    _foulCount = fouls;
  }

  void setIdleCount(int idleCount)
  {
    _idleCount = idleCount;
  }
}

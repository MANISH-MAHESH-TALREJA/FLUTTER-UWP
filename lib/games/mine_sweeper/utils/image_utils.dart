import 'package:flutter/material.dart';

enum ImageType
{
  zero,
  one,
  two,
  three,
  four,
  five,
  six,
  seven,
  eight,
  bomb,
  facingDown,
  flagged,
}

Image getImage(ImageType type)
{
  switch (type)
  {
    case ImageType.zero:
      return Image.asset('assets/images/mine_sweeper/0.png', fit: BoxFit.fill,);
    case ImageType.one:
      return Image.asset('assets/images/mine_sweeper/1.png', fit: BoxFit.fill,);
    case ImageType.two:
      return Image.asset('assets/images/mine_sweeper/2.png', fit: BoxFit.fill,);
    case ImageType.three:
      return Image.asset('assets/images/mine_sweeper/3.png', fit: BoxFit.fill,);
    case ImageType.four:
      return Image.asset('assets/images/mine_sweeper/4.png', fit: BoxFit.fill,);
    case ImageType.five:
      return Image.asset('assets/images/mine_sweeper/5.png', fit: BoxFit.fill,);
    case ImageType.six:
      return Image.asset('assets/images/mine_sweeper/6.png', fit: BoxFit.fill,);
    case ImageType.seven:
      return Image.asset('assets/images/mine_sweeper/7.png', fit: BoxFit.fill,);
    case ImageType.eight:
      return Image.asset('assets/images/mine_sweeper/8.png', fit: BoxFit.fill,);
    case ImageType.bomb:
      return Image.asset('assets/images/mine_sweeper/bomb.png', fit: BoxFit.fill,);
    case ImageType.facingDown:
      return Image.asset('assets/images/mine_sweeper/facingDown.png', fit: BoxFit.fill,);
    case ImageType.flagged:
      return Image.asset('assets/images/mine_sweeper/flagged.png', fit: BoxFit.fill,);
    default:
      return Image.asset('assets/images/mine_sweeper/flagged.png', fit: BoxFit.fill,);
  }
}

ImageType getImageTypeFromNumber(int number)
{
  switch (number)
  {
    case 0:
      return ImageType.zero;
    case 1:
      return ImageType.one;
    case 2:
      return ImageType.two;
    case 3:
      return ImageType.three;
    case 4:
      return ImageType.four;
    case 5:
      return ImageType.five;
    case 6:
      return ImageType.six;
    case 7:
      return ImageType.seven;
    case 8:
      return ImageType.eight;
    default:
      return ImageType.eight;
  }
}
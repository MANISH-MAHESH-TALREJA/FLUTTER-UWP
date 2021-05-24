import 'package:games/games/memory_game/models/tile_model.dart';

String selectedTile = "";
int selectedIndex  = 0;
bool selected = true;
int points = 0;

List<TileModel> myPairs = <TileModel>[];
List<bool> clicked = <bool>[];

List<bool> getClicked()
{
  List<bool> yoClicked = <bool>[];
  List<TileModel> myAirs = <TileModel>[];
  myAirs = getPairs();
  for(int i=0;i<myAirs.length;i++)
  {
    yoClicked[i] = false;
  }
  return yoClicked;
}

List<TileModel>  getPairs()
{

  List<TileModel> pairs = <TileModel>[];
  TileModel tileModel = TileModel(isSelected: false, imageAssetPath: "");

  //1
  tileModel.setImageAssetPath("assets/images/memory_game/fox.png");
  tileModel.setIsSelected(false);
  pairs.add(tileModel);
  pairs.add(tileModel);
  tileModel = TileModel(isSelected: false, imageAssetPath: "");

  //2
  tileModel.setImageAssetPath("assets/images/memory_game/hippo.png");
  tileModel.setIsSelected(false);
  pairs.add(tileModel);
  pairs.add(tileModel);
  tileModel = TileModel(isSelected: false, imageAssetPath: "");

  //3
  tileModel.setImageAssetPath("assets/images/memory_game/horse.png");
  tileModel.setIsSelected(false);
  pairs.add(tileModel);
  pairs.add(tileModel);
  tileModel = TileModel(isSelected: false, imageAssetPath: "");

  //4
  tileModel.setImageAssetPath("assets/images/memory_game/monkey.png");
  tileModel.setIsSelected(false);
  pairs.add(tileModel);
  pairs.add(tileModel);
  tileModel = TileModel(isSelected: false, imageAssetPath: "");
  //5
  tileModel.setImageAssetPath("assets/images/memory_game/panda.png");
  tileModel.setIsSelected(false);
  pairs.add(tileModel);
  pairs.add(tileModel);
  tileModel = TileModel(isSelected: false, imageAssetPath: "");

  //6
  tileModel.setImageAssetPath("assets/images/memory_game/parrot.png");
  tileModel.setIsSelected(false);
  pairs.add(tileModel);
  pairs.add(tileModel);
  tileModel = TileModel(isSelected: false, imageAssetPath: "");

  //7
  tileModel.setImageAssetPath("assets/images/memory_game/rabbit.png");
  tileModel.setIsSelected(false);
  pairs.add(tileModel);
  pairs.add(tileModel);
  tileModel = TileModel(isSelected: false, imageAssetPath: "");

  //8
  tileModel.setImageAssetPath("assets/images/memory_game/zoo.png");
  tileModel.setIsSelected(false);
  pairs.add(tileModel);
  pairs.add(tileModel);
  tileModel = TileModel(isSelected: false, imageAssetPath: "");


  return pairs;
}

List<TileModel>  getQuestionPairs(){

  List<TileModel> pairs = <TileModel>[];

  TileModel tileModel = TileModel(isSelected: false, imageAssetPath: "");

  //1
  tileModel.setImageAssetPath("assets/images/memory_game/question.png");
  tileModel.setIsSelected(false);
  pairs.add(tileModel);
  pairs.add(tileModel);
  tileModel = TileModel(isSelected: false, imageAssetPath: "");

  //2
  tileModel.setImageAssetPath("assets/images/memory_game/question.png");
  tileModel.setIsSelected(false);
  pairs.add(tileModel);
  pairs.add(tileModel);
  tileModel = TileModel(isSelected: false, imageAssetPath: "");

  //3
  tileModel.setImageAssetPath("assets/images/memory_game/question.png");
  tileModel.setIsSelected(false);
  pairs.add(tileModel);
  pairs.add(tileModel);
  tileModel = TileModel(isSelected: false, imageAssetPath: "");

  //4
  tileModel.setImageAssetPath("assets/images/memory_game/question.png");
  tileModel.setIsSelected(false);
  pairs.add(tileModel);
  pairs.add(tileModel);
  tileModel = TileModel(isSelected: false, imageAssetPath: "");
  //5
  tileModel.setImageAssetPath("assets/images/memory_game/question.png");
  tileModel.setIsSelected(false);
  pairs.add(tileModel);
  pairs.add(tileModel);
  tileModel = TileModel(isSelected: false, imageAssetPath: "");

  //6
  tileModel.setImageAssetPath("assets/images/memory_game/question.png");
  tileModel.setIsSelected(false);
  pairs.add(tileModel);
  pairs.add(tileModel);
  tileModel = TileModel(isSelected: false, imageAssetPath: "");

  //7
  tileModel.setImageAssetPath("assets/images/memory_game/question.png");
  tileModel.setIsSelected(false);
  pairs.add(tileModel);
  pairs.add(tileModel);
  tileModel = TileModel(isSelected: false, imageAssetPath: "");

  //8
  tileModel.setImageAssetPath("assets/images/memory_game/question.png");
  tileModel.setIsSelected(false);
  pairs.add(tileModel);
  pairs.add(tileModel);
  tileModel = TileModel(isSelected: false, imageAssetPath: "");

  return pairs;
}
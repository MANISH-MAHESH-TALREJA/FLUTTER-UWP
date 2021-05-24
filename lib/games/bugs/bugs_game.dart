import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:flare_flutter/flare_actor.dart';

// ignore: use_key_in_widget_constructors
class BugsApp extends StatefulWidget
{
  @override
  BugsPage createState() => BugsPage();
}

class BugsPage extends State<BugsApp>
{
  late Timer timer;
  late int bug, score, fly, fly2, press, time;
  Random rnd = Random();


  @override
  void initState()
  {
    super.initState();
    _set();
  }

  void _set()
  {
    bug = 0;
    score = 0;
    fly = 9;
    fly2 = 8;
    press = -1;
    time = 31;
  }

  void start()
  {
    timer = Timer.periodic(const Duration(seconds: 1), (timer)
    {
      if (time > 0)
      {
        setState(()
        {
          time = time - 1;
          bug = rnd.nextInt(9 - 0);
          if (bug > 0)
          {
            fly = rnd.nextInt(bug - 0);
            if (fly > 0)
            {
              if (rnd.nextInt(fly - 0) != bug)
              {
                fly2 = rnd.nextInt(fly - 0);
              }
            }
          }
          press = -1;
        });
      }
    });
  }
  
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(body: stack([pos(flr("assets/images/bugs/lake.flr")), pos(res())]));
  }

  Widget pos(wid)
  {
    return Positioned.fill(child: wid);
  }

  Widget stack(wid)
  {
    return Stack(children: wid);
  }

  Widget col(wid)
  {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: wid, );
  }

  Widget res()
  {
    if (time == 31)
    {
      return col([ply(start)]);
    }
    else if (time > 0)
    {
      return col([
        SizedBox(
          width: double.infinity,
          child: left(),
        ),
        const Padding(padding: EdgeInsets.all(30)),
        Expanded(child: box())
      ]);
    }
    else
    {
      return col([str("SCORE : " + score.toString()), ply(_set)]);
    }
  }

  Widget left()
  {
    return col(
      [
        str("SCORE : " + score.toString()),
        str("TIME LEFT : " + time.toString())
      ],
    );
  }

  Widget str(text)
  {
    return Text(text, style: const TextStyle(color: Colors.white, fontSize: 30));
  }

  Widget ply(func)
  {
    return IconButton(
        iconSize: 150,
        color: Colors.orangeAccent.withOpacity(0.6),
        icon: const Icon(Icons.play_circle_outline),
        onPressed: func);
  }

  Widget card(index)
  {
    if (bug == index)
    {
      if (press == index)
      {
        return img("spark.gif");
      }
      else
      {
        return img("bug.gif");
      }
    }
    else if (fly == index)
    {
      return chk(press, index);
    }
    else if (fly2 == index)
    {
      return chk(press, index);
    }
    else
    {
      if (press == index)
      {
        return flr("assets/images/bugs/sub.flr");
      }
      else
      {
        return img("leaf.gif");
      }
    }
  }

  Widget chk(press, index)
  {
    if (press == index)
    {
      return flr("assets/images/bugs/sub.flr");
    }
    else
    {
      return img("fly.gif");
    }
  }

  Widget img(name)
  {
    return Image(image: AssetImage("assets/images/bugs/" + name));
  }

  Widget flr(text)
  {
    return FlareActor(text, animation: "float", fit: BoxFit.fill,);
  }

  void update(index)
  {
    if (index == bug)
    {
      setState(()
      {
        press = index;
        score += 1;
      });
    }
    else
    {
      setState(()
      {
        press = index;
        if (score > 0)
        {
          score -= 1;
        }
      });
    }
  }

  Widget box()
  {
    return Center(
      child: GridView.builder(
          itemCount: 9,
          physics: const NeverScrollableScrollPhysics(),
          controller: ScrollController(),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount : 3, childAspectRatio: MediaQuery.of(context).size.aspectRatio*1.5,),
          itemBuilder: (BuildContext context, int index)
          {
            return GestureDetector(
              child: card(index),
              onTap: ()
              {
                update(index);
              },
            );
          }),
    );
  }
}

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "动画",
      home: Scaffold(
        appBar: AppBar(
          title: Text("动画"),
        ),
        body: Route1(),
      ),
    );
  }
}

// 位置
class AnimateWidgit extends StatefulWidget {
  @override
  _AnimateWidgitState createState() => _AnimateWidgitState();
}

class _AnimateWidgitState extends State<AnimateWidgit>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  bool forward = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(
        duration: Duration(milliseconds: 2000),
        lowerBound: 10.0,
        upperBound: 100,
        vsync: this);

    controller
      ..addStatusListener((AnimationStatus status) {
        debugPrint("状态$status");
      })
      ..addListener(() {
        setState(() {});
      });
    debugPrint("controller.value:${controller.value}");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: controller.value,
          height: controller.value,
          color: Colors.blue,
        ),
        RaisedButton(
          onPressed: () {
            if (forward) {
              controller.forward();
            } else {
              controller.reverse();
            }
            forward = !forward;
          },
        )
      ],
    );
  }
}

//颜色变化
class AnimateColorWidgte extends StatefulWidget {
  @override
  _AnimateColorWidgteState createState() => _AnimateColorWidgteState();
}

class _AnimateColorWidgteState extends State<AnimateColorWidgte>
    with SingleTickerProviderStateMixin {
  AnimationController controller;

  bool forward = true;

  Tween<Color> tween;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
    //使用Color
    tween = ColorTween(begin: Colors.blue, end: Colors.yellow);
    tween.animate(controller)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: 100,
          height: 100,
          color: tween.evaluate(controller),
        ),
        RaisedButton(
            child: Text("开始"),
            onPressed: () {
              if (forward) {
                controller.forward();
              } else {
                controller.reverse();
              }
              forward = !forward;
            }),
        RaisedButton(
          child: Text("停止"),
          onPressed: () {
            controller.stop();
          },
        )
      ],
    );
  }
}

//动画速度
class AnimateSpeedWidgte extends StatefulWidget {
  @override
  _AnimateSpeedWidgteState createState() => _AnimateSpeedWidgteState();
}

class _AnimateSpeedWidgteState extends State<AnimateSpeedWidgte>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  bool forward = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
    //弹性
    animation = CurvedAnimation(parent: controller, curve: Curves.bounceIn);
    animation = Tween(begin: 10.0, end: 100.0).animate(animation)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
            width: animation.value,
            height: animation.value,
            color: Colors.blue),
        RaisedButton(
            child: Text("开始"),
            onPressed: () {
              if (forward) {
                controller.forward();
              } else {
                controller.reverse();
              }
              forward = !forward;
            }),
        RaisedButton(
          child: Text("停止"),
          onPressed: () {
            controller.stop();
          },
        )
      ],
    );
  }
}

class PackedAnimation extends StatefulWidget {
  @override
  _PackedAnimationState createState() => _PackedAnimationState();
}

class _PackedAnimationState extends State<PackedAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  bool forward = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(
      // 动画的时长
      duration: Duration(milliseconds: 2000),
      // 提供 vsync 最简单的方式，就是直接继承 SingleTickerProviderStateMixin
      vsync: this,
    );

    //弹性
    animation = CurvedAnimation(parent: controller, curve: Curves.bounceIn);
    //使用Color
    animation = Tween(begin: 10.0, end: 100.0).animate(animation);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ScaleTransition(
          child: Container(
            width: 100,
            height: 100,
            color: Colors.blue,
          ),
          scale: controller,
        ),
        RaisedButton(
          child: Text("播放"),
          onPressed: () {
            if (forward) {
              controller.forward();
            } else {
              controller.reverse();
            }
            forward = !forward;
          },
        ),
        RaisedButton(
          child: Text("停止"),
          onPressed: () {
            controller.stop();
          },
        )
      ],
    );
  }
}

//### 组合动画
class Route extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RouteState();
  }
}

class RouteState extends State<Route> with SingleTickerProviderStateMixin {
  Animation<Color> color;
  Animation<double> width;
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      // 动画的时长
      duration: Duration(milliseconds: 2000),
      // 提供 vsync 最简单的方式，就是直接继承 SingleTickerProviderStateMixin
      vsync: this,
    );

    //高度动画
    width = Tween<double>(
      begin: 100.0,
      end: 300.0,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          //间隔，前60%的动画时间 1200ms执行高度变化
          0.0, 0.6,
        ),
      ),
    );

    color = ColorTween(
      begin: Colors.green,
      end: Colors.red,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          0.6, 1.0, //高度变化完成后 800ms 执行颜色编码
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("主页"),
      ),
      body: InkWell(
        ///1、不用显式的去添加帧监听器，再调用setState()
        ///2、缩小动画构建的范围，如果没有builder，setState()将会在父widget上下文调用，导致父widget的build方法重新调用，现在只会导致动画widget的build重新调用
        child: AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              return Container(
                color: color.value,
                width: width.value,
                height: 100.0,
              );
            }),
        onTap: () {
          controller.forward().whenCompleteOrCancel(() => controller.reverse());
        },
      ),
    );
  }
}

//### Hero动画
//
//​	Hero动画就是在路由切换时，有一个共享的Widget可以在新旧路由间切换，由于共享的Widget在新旧路由页面上的位置、外观可能有所差异，所以在路由切换时会逐渐过渡，这样就会产生一个Hero动画。

// 路由A
class Route1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: InkWell(
        child: Hero(
          tag: "avatar", //唯一标记，前后两个路由页Hero的tag必须相同
          child: CircleAvatar(
            backgroundImage: AssetImage(
              "images/logo.png",
            ),
          ),
        ),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return Route2();
          }));
        },
      ),
    );
  }
}

class Route2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Hero(
          tag: "avatar", //唯一标记，前后两个路由页Hero的tag必须相同
          child: Image.asset("images/logo.png")),
    );
  }
}

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:home_work_route/widgt/module.dart';

void main() => runApp(Myapp());

class Myapp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "圆",
      home: Scaffold(
        appBar: AppBar(
          title: Text("圆"),
        ),
        body: Circular(),
      ),
    );
  }
}

class Circular extends StatefulWidget {
  @override
  _CircularState createState() => _CircularState();
}

class _CircularState extends State<Circular> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: MyView(getData(), getData()[2], 2, false),
    );
  }
}

List<PieData> getData() {
  List<PieData> mData = new List();
  PieData p1 = new PieData();
  p1.name = 'A';
  p1.price = 'a';
  p1.percentage = 0.2932;
  p1.color = Color(0xffff3333);
  mData.add(p1);
  PieData p2 = new PieData();
  p2.name = 'B';
  p2.price = 'b';
  p2.percentage = 0.05;
  p2.color = Color(0xffccccff);
  mData.add(p2);

  PieData p3 = new PieData();
  p3.name = 'C';
  p3.price = 'c';
  p3.percentage = 0.1132;
  p3.color = Color(0xffCD00CD);
  mData.add(p3);
  PieData p4 = new PieData();
  p4.name = 'D';
  p4.price = 'd';
  p4.percentage = 0.0868;
  p4.color = Color(0xffFFA500);
  mData.add(p4);

  PieData p5 = new PieData();
  p5.name = 'E';
  p5.price = 'e';
  p5.percentage = 0.18023;
  p5.color = Color(0xff40E0D0);
  mData.add(p5);

  PieData p6 = new PieData();
  p6.name = 'F';
  p6.price = 'f';
  p6.percentage = 0.12888;
  p6.color = Color(0xffFFFF00);
  mData.add(p6);

  PieData p7 = new PieData();
  p7.name = 'G';
  p7.price = 'g';
  p7.percentage = 0.0888;
  p7.color = Color(0xff00ff66);
  mData.add(p7);

  PieData p8 = new PieData();
  p8.name = 'H';
  p8.price = 'h';
  p8.percentage = 0.06;
  p8.color = Color(0xffD9D9D9);
  mData.add(p8);
  return mData;
}

class MyView extends CustomPainter {
  //中间文字
  var text = '111';
  bool isChange = false;

  //当前选中的扇形
  var currentSelect = 2;

  //画笔
  Paint _mPaint;
  Paint TextPaint;

  // 扇形大小
  int mWidth, mHeight;

  // 圆半径
  num mRadius, mInnerRadius, mBigRadius;

  // 扇形起始弧度（Andorid中是角度）
  num mStartAngle = 0;

  // 矩形（扇形绘制的区域）
  Rect mOval, mBigOval;

// 扇形 数据
  List<PieData> mData;
  PieData pieData;

  // 构造函数，接受需要的参数值
  MyView(this.mData, this.pieData, this.currentSelect, this.isChange);

  /**
   * 重写 paint方法，在其中写绘制饼状图的逻辑
   */
  @override
  void paint(Canvas canvas, Size size) {
    // 初始化各类工具等
    _mPaint = new Paint();
    TextPaint = new Paint();
    mHeight = 100;
    mWidth = 100;

    /// 生成纵轴文字的TextPainter
    TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      maxLines: 1,
    );

    // 文字画笔 风格定义
    TextPainter _newVerticalAxisTextPainter(String text) {
      return textPainter
        ..text = TextSpan(
          text: text,
          style: new TextStyle(
            color: Colors.black,
            fontSize: 10.0,
          ),
        );
    }

    // 正常半径
    mRadius = 50.0;
    //加大半径  用来绘制被选中的扇形区域
    mBigRadius = 55.0;
    //內园半径
    mInnerRadius = mRadius * 0.50;
    // 未选中的扇形绘制的矩形区域
    mOval = Rect.fromLTRB(-mRadius, -mRadius, mRadius, mRadius);
    // 选中的扇形绘制的矩形区域
    mBigOval = Rect.fromLTRB(-mBigRadius, -mBigRadius, mBigRadius, mBigRadius);
    //当没有数据时 直接返回
    if (mData.length == null || mData.length <= 0) {
      return;
    }

    ///绘制逻辑与Android差不多
    canvas.save();
    // 将坐标点移动到View的中心
    canvas.translate(60.0, 60.0);
    // 1. 画扇形
    num startAngle = 0.0;
    for (int i = 0; i < mData.length; i++) {
      PieData p = mData[i];
      double hudu = p.percentage;
      //计算当前偏移量（单位为弧度）
      double sweepAngle = 2 * pi * hudu;
      //画笔的颜色
      _mPaint..color = p.color;
      if (currentSelect >= 0 && i == currentSelect) {
        //如果当前为所选中的扇形 则将其半径加大  突出显示
        canvas.drawArc(mBigOval, startAngle, sweepAngle, true, _mPaint);
      } else {
        // 绘制没被选中的扇形  正常半径
        canvas.drawArc(mOval, startAngle, sweepAngle, true, _mPaint);
      }
      //计算每次开始绘制的弧度
      startAngle += sweepAngle;
    }

//    canvas.drawRect(mOval, _mPaint);  // 矩形区域

    // 2.画内圆
    _mPaint..color = Colors.white;
    canvas.drawCircle(Offset.zero, mInnerRadius, _mPaint);

    canvas.restore();

    //当前百分比值
    double percentage = pieData.percentage * 100;
    // 绘制文字内容
    var texts = '${percentage}%';
    var tp = _newVerticalAxisTextPainter(texts)..layout();

    // Text的绘制起始点 = 可用宽度 - 文字宽度 - 左边距
    var textLeft = 35.0;
    tp.paint(canvas, Offset(textLeft, 50.0 - tp.height / 2));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class MyPainter extends CustomPainter {
  MyPainter(this.radius);

  double radius;

  @override
  void paint(Canvas canvas, Size size) {
    ///根据半径计算大小
    size = Size.fromRadius(radius);
    var paint = Paint() //创建一个画笔并配置其属性
      ..isAntiAlias = true //是否抗锯齿
      ..style = PaintingStyle.fill //画笔样式：填充
      ..color = Colors.blue //画笔颜色
      ..strokeWidth = 3.0; //画笔的宽度

    ///画一个实心圆
    Rect rect =
        Rect.fromCircle(center: size.center(Offset.zero), radius: radius);
    canvas.drawCircle(rect.center, radius, paint);
//    canvas.drawArc(rect, 0, 180, true, paint);
  }

  @override
  bool shouldRepaint(MyPainter oldDelegate) {
    if (oldDelegate.radius != radius) {
      return true;
    }
    return false;
  }
}

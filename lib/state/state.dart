import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

void main() => runApp(new MyApp01());
NumModle countModel = NumModle();

class MyApp01 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel(model: countModel,
        child: MaterialApp(
      home: Page01Main(),
    ));
  }
}

class Page01Main extends StatefulWidget {
  @override
  _Page01MainState createState() => _Page01MainState();
}

class _Page01MainState extends State<Page01Main> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("第一页"),
      ),
      body: Column(
        children: <Widget>[
          Center(
              child: Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
            child: Text(countModel.count.toString()),
          )),
          RaisedButton(
              child: Text("跳转下一页"),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return MyApp02();
                }));
              })
        ],
      ),
    );
  }
}

class MyApp02 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: "第二页", home: Page02Main());
  }
}

class Page02Main extends StatefulWidget {
  @override
  _Page02MainState createState() => _Page02MainState();
}

class _Page02MainState extends State<Page02Main> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("第二页"),
        ),
        body: Column(
          children: <Widget>[
            Center(
                child: Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
              child: Text(countModel.count.toString()),
            )),
            Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
              child: InkWell(
                child: Text(
                  "点击加数字",
                  style: TextStyle(color: Colors.blue),
                ),
                onTap: () {
                  countModel.increment();
                  setState(() {});
                },
              ),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("结束"),
            )
          ],
        ));
  }
}

class NumModle extends Model {
  int _count = 0;

  void setcount(int value) {
    _count = value;
  }

  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }
}

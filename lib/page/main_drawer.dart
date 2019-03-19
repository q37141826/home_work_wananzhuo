import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:event_bus/event_bus.dart';
import 'package:home_work_route/event/events.dart';
import 'package:home_work_route/http/api.dart';
import 'package:home_work_route/manager/app_manager.dart';
import 'package:home_work_route/page/page%20_login.dart';
import 'package:home_work_route/page/page_collect.dart';

class MainDrawer extends StatefulWidget {
  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  String _username;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //监听特定的事件：LoginEvent
    AppManager.eventBus.on<LoginEvent>().listen((event) {
      setState(() {
        _username = event.username;
        //sp sharedprefrence
        AppManager.prefs.setString(AppManager.ACCOUNT, _username);
      });
    });
    _username = AppManager.prefs.getString(AppManager.ACCOUNT);
  }

  @override
  Widget build(BuildContext context) {
    Widget useHeader = DrawerHeader(
      decoration: BoxDecoration(color: Colors.blue),
      child: InkWell(
        //点击跳转登录界面
        onTap: () => _itemClick(null),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 18),
              child: CircleAvatar(
                backgroundImage: AssetImage("assets/images/logo.png"),
                radius: 38,
              ),
            ),
            Text(
              _username ?? "请先登录",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
      ),
    );

    return ListView(
      //状态栏默认灰色
      padding: EdgeInsets.zero,
      children: <Widget>[
        useHeader,
        InkWell(
          onTap: () => _itemClick(CollectPage()),
          child: ListTile(
            leading: Icon(Icons.favorite),
            title: Text(
              "收藏列表",
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(18, 0, 18, 0),
        ),
        Offstage(
          offstage: _username == null,
          child: InkWell(
            onTap: () {
              setState(() {
                AppManager.prefs.setString(AppManager.ACCOUNT, null);
                Api.clearCookie();
                _username = null;
              });
            },
            child: ListTile(
              leading: Icon(Icons.exit_to_app), // todo 这个leadding是干什么用的
              title: Text(
                "退出登录",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        )
      ],
    );
  }

  void _itemClick(Widget page) {
    //如果未登录 则进入登陆界面
    var dstPage = _username == null ? LoginPage() : page;
    //如果page为null，则跳转
    if (dstPage != null) {
      Navigator.push(context, new MaterialPageRoute(builder: (context) {
        return dstPage;
      }));
    }
  }
}

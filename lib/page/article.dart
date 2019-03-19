import 'package:flutter/material.dart';
import 'package:home_work_route/http/api.dart';
import 'package:banner_view/banner_view.dart';
import 'package:home_work_route/manager/app_manager.dart';
import 'package:home_work_route/page/main_drawer.dart';
import 'package:toast/toast.dart';
class ArticleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppManager.initApp();
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text(
            '文章',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        body: new ArticlePage(),
        drawer: Drawer(
          child: MainDrawer(),
        ),
      ),
    );
  }
}

class ArticlePage extends StatefulWidget {
  @override
  _ArticlePageState createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  //欢动控制器
  ScrollController _controller = new ScrollController();

//转圈圈的
  bool _isLoading = true;

  ///请求到的文章数据
  List articles = List();

  //轮播
  List banners = List();

  ///总文章数有多少
  var listTotalSize = 0;

  ///分页加载，当前页码
  var curPage = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.addListener(() {
      ///获得 SrollController 监听控件可以滚动的最大范围
      var maxScroll = _controller.position.maxScrollExtent;

      ///获得当前位置的像素值
      var pixels = _controller.position.pixels;

      ///当前滑动位置到达底部，同时还有更多数据
      if (maxScroll == pixels && articles.length < listTotalSize) {
        ///加载更多
        _getArticlelist();
      }
    });
    _pullToRefresh();
  }


  _getArticlelist([bool update = true]) async {
    /// 请求成功是map，失败是null
    var data = await Api.getArticleList(curPage);
    if (data != null) {
      var map = data['data'];
      var datas = map['datas'];

      ///文章总数
      listTotalSize = map["total"];

      if (curPage == 0) {
        articles.clear();
      }
      curPage++;
      articles.addAll(datas);

      ///更新ui
      if (update) {
        setState(() {});
      }
    }
  }

  _getBanner([bool update = true]) async {
    var data = await Api.getBanner();
    if (data != null) {
      banners.clear();
      banners.addAll(data['data']);
      if (update) {
        setState(() {});
      }
    }
  }

  ///下拉刷新
  Future<void> _pullToRefresh() async {
    curPage = 0;
    Iterable<Future> futures = [_getArticlelist(), _getBanner()];
    await Future.wait(futures);
    _isLoading = false;
    setState(() {});
    return null;
  }


  @override
  Widget build(BuildContext context) {
    //Stack：帧布局
    return Stack(
      children: <Widget>[
        ///正在加载
        Offstage( //可以控制是否隐藏
          offstage: !_isLoading, //是否隐藏
          child: new Center(child: CircularProgressIndicator()),//圆形进度指示器(小菊花)
        ),

        ///内容
        Offstage(
          offstage: _isLoading,
          child: new RefreshIndicator( //下拉刷新
              child: ListView.builder(
                itemCount: articles.length + 1,	//列表视图的个数
                itemBuilder: (context, i) => _buildItem(i),//类似adapter，item显示什么？返回widget
                controller: _controller,//滑动控制器
              ),
              onRefresh: _pullToRefresh),//刷新回调方法
        )
      ],
    );
  }

  Widget _buildItem(int i) {
    if (i == 0) {
      return new Container(
        height: 180.0,
        child: _bannerView(),
      );
    }
    var itemData = articles[i - 1];
    return new ArticleItem(itemData);
  }


  Widget _bannerView() {
    ///banners是请求到的banner信息组，其中imagePath代表了图片地址
    ///map意为映射，对banners中的数据进行遍历并返回Iterable<?>迭代器，
    ///？则是在map的参数：一个匿名方法中返回的类型
    var list = banners.map((item) {
      return Image.network(item['imagePath'], fit: BoxFit.cover);
    }).toList();
    ///BannerView的条目不能为空
    return list.isNotEmpty
        ? BannerView(
      list,
      ///切换时间
      intervalDuration: const Duration(seconds: 3),
    )
        : null;
  }
}




class ArticleItem extends StatelessWidget {
  final itemData;

  const ArticleItem(this.itemData);

  @override
  Widget build(BuildContext context) {
    ///时间与作者
    Row author = new Row( //水平线性布局
      children: <Widget>[
        //expanded 最后摆我，相当于linearlayout的weight权重
        new Expanded(
            child: Text.rich(TextSpan(children: [
              TextSpan(text: "作者: "),
              TextSpan(
                  text: itemData['author'],
                  style: new TextStyle(color: Theme.of(context).primaryColor))
            ]))),
        new Text(itemData['niceDate'])//时间
      ],
    );

    ///标题
    Text title = new Text(
      itemData['title'],
      style: new TextStyle(fontSize: 16.0, color: Colors.black),
      textAlign: TextAlign.left,
    );

    ///章节名
    Text chapterName = new Text(itemData['chapterName'],
        style: new TextStyle(color: Theme.of(context).primaryColor));

    ///收藏按钮
    Text collection = new Text("收藏",
        style: new TextStyle(color: Theme.of(context).primaryColor)
    );

    Column column = new Column( //垂直线性布局
      crossAxisAlignment: CrossAxisAlignment.start, //子控件左对齐
      children: <Widget>[
        new Padding(
          padding: EdgeInsets.all(10.0),
          child: author,
        ),
        new Padding(
          padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
          child: title,
        ),
        new Padding(
          padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 10.0),
          child: chapterName,
        ),
        new Padding(
          padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 10.0),
          child:InkWell(
            onTap: (){
              _getCollects(itemData['id'],context);
            },
            child: collection,
          ),
        ),
      ],
    );

    return new Card(
      ///阴影效果
      elevation: 4.0,
      child: column,
    );
  }



  void _getCollects(int id,BuildContext con) async {
    var data = await Api.collectThisArticle(id);
    Toast.show(data['msg'], con);
  }

}


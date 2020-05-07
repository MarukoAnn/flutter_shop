import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../service/service_method.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

//第一步 混入，with AutomaticKeepAliveClientMixin 混入，页面保持
class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin{

  // 第二部 重写wantKeepAlive 方法
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  String homePageContent = '正在获取数据';

  // 初始化数据
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('京东商城'),
        ),
        body: FutureBuilder(
          future: request('homePageContent', null), // 调用异步方法
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var data = snapshot.data;
              // 轮播图
              List<Map> swiper = (data['data']['slide'] as List).cast();
              // 九宫格
              List<Map> navgatorList = (data['data']['category'] as List).cast();
              // 图片地址
              String adPicture = data['data']['advertesPicture'];
              //
              List<Map> recommedList = (data['data']['recommend'] as List).cast();

              List floorListone = (data['data']['floor1'] as List).cast();
              List floorListtwo = (data['data']['floor2'] as List).cast();
              List floorListthr = (data['data']['floor3'] as List).cast();
              return SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SwiperDiy(swiperDateList: swiper),
                    TopNavigator(navigatorList: navgatorList),
//                    AdBanner(adPicture: adPicture),
//                    LeaderPhone(leaderImage: 'assets/image/ic_leaderphone.png', leaderPhone: '18385076519'),
                    Recommend(recommendList: recommedList),
                    // 三层楼
                    FloorTitle(floorTitle: '温婉淑女', floorSmallTitle: 'LADY'),
                    FloorContent(floorGoodsList: floorListone),
                    FloorTitle(floorTitle: '优雅格调', floorSmallTitle: 'GRACE'),
                    FloorContent(floorGoodsList: floorListtwo),
                    FloorTitle(floorTitle: '潮流时尚', floorSmallTitle: 'REND'),
                    FloorContent(floorGoodsList: floorListthr),
                    HotGoods()
                  ],
                ),
              );
            } else {
              return Center(
                child: Text('加载中。。。。'),
              );
            }
          },
        ));
  }


}

// 轮播组件
class SwiperDiy extends StatelessWidget {
  final List swiperDateList;

  SwiperDiy({this.swiperDateList});

  @override
  Widget build(BuildContext context) {
//    print('设备的像素密度：${ScreenUtil.pixelRatio}');
//    print('设备的高度: ${ScreenUtil.screenHeight}');
//    print('设备的宽度: ${ScreenUtil.screenWidth}');
    return SingleChildScrollView(
      child: Container(
        height: ScreenUtil().setHeight(323),
        width: ScreenUtil().setWidth(750),
        child: Swiper(
          itemBuilder: (BuildContext context, int index) {
            return Image.network("${swiperDateList[index]['image']}");
          },
          itemCount: swiperDateList.length,
          pagination: SwiperPagination(), // 切换的导航小点。
          autoplay: true, // 自动播放
        ),
      ),
    );
  }
}

// 顶部九宫格组件
class TopNavigator extends StatelessWidget {
  final List navigatorList;

  TopNavigator({this.navigatorList});

  Widget _gridViewItemUI(BuildContext context, item) {
    return InkWell(
      onTap: () {
        print('点击了导航');
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // 设置主轴垂直居中
        children: <Widget>[
          Image.network(item['image'], width: ScreenUtil().setWidth(60)),
          Text(item['mallCategoryName'])
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(340),
      padding: EdgeInsets.all(3.0),
      child: GridView.count(
        crossAxisCount: 5, // 每行多少个
        padding: EdgeInsets.all(5.0),
        children: navigatorList.map((item) {
          return _gridViewItemUI(context, item);
        }).toList(),
      ),
    );
  }
}

// 广告组件
class AdBanner extends StatelessWidget {
  final String adPicture;
  AdBanner({this.adPicture});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(70),
      child: Image.network(adPicture, fit: BoxFit.fill),
    );
  }
}

// 店长电话
class LeaderPhone extends StatelessWidget {
  final String leaderImage; // 店长图片
  final String leaderPhone; // 店长电话
  LeaderPhone({this.leaderImage, this.leaderPhone});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setHeight(800),
      child: InkWell(
        onTap: _launchURL,
        child: Image.asset(leaderImage, fit: BoxFit.fill),
      ),
    );
  }
  // 拨打电话的事件
  void _launchURL() async {
    String url = 'tel:' + leaderPhone;
//    String url = 'http://www.baidu.com';
    if(await canLaunch(url)){
      await launch(url);
    }else{
      throw 'url 不能进行访问';
    }
  }
}

// 商品推荐
class Recommend extends StatelessWidget {
  final List recommendList;
  Recommend({Key key, this.recommendList}): super(key: key);

  // 标题方法  
  Widget _titleWidget(){
    return Container(
      alignment: Alignment.centerLeft,  // 左居中对齐
      padding: EdgeInsets.fromLTRB(10.0, 2.0, 0, 5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(  // 设置底部下划线
              width: 1,
              color: Colors.black26
          )
        )
      ),
      child: Text('商品推荐', style: TextStyle(
        color: Colors.pink
      )),
    );
  }
  // 商品单独项方法  
  Widget _item(index){
    return InkWell(
      onTap: (){},
      child: Container(
        height: ScreenUtil().setHeight(330),
        width: ScreenUtil().setWidth(250),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            left: BorderSide(
              color: Colors.black26,
              width: 1 // 边框不支持0.5
            )
          )
        ),
        child: Column(
          children: <Widget>[
            Image.network(recommendList[index]['image']),
            Text('￥${recommendList[index]['mallPrice']}'),
            Text('￥${recommendList[index]['price']}',
            style: TextStyle(
              color: Colors.grey,
              decoration: TextDecoration.lineThrough
            ),
            )
          ],
        ),
      ),
    );
  }

  // 横向列表方法
  Widget _recommedList(){
    return Container(
      height: ScreenUtil().setHeight(345),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recommendList.length,
        itemBuilder: (context, index){
          return _item(index);
        }
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(420),
      margin: EdgeInsets.only(top: 10.0),
      child: Column(
        children: <Widget>[
          _titleWidget(),
          _recommedList()
        ],
      ),
    );
  }
}

//楼层标题
class FloorTitle extends StatelessWidget {
  final String floorTitle;
  final String floorSmallTitle;
  FloorTitle({Key key, this.floorTitle, this.floorSmallTitle}): super(key:key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            floorTitle,
            style: TextStyle(
              fontSize: ScreenUtil().setSp(40),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 10.0),
            child: Text(
              floorSmallTitle,
              textAlign:TextAlign.start,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(20),
                color: Colors.grey
              ),
            ),
          )
        ],
      )
    );
  }
}
// 楼层尚品列表
class FloorContent extends StatelessWidget {
  final List floorGoodsList;
  FloorContent({Key key, this.floorGoodsList}):super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          _fristRow(),
          otherGoods(),
        ],
      ),
    );
  }



  Widget _fristRow(){
    return Row(
      children: <Widget>[
        _goodsItem(floorGoodsList[0]),
        Column(
          children: <Widget>[
            _goodsItem(floorGoodsList[1]),
            _goodsItem(floorGoodsList[2]),
          ],
        )
      ],
    );
  }

  Widget otherGoods(){
    return Row(
      children: <Widget>[
        _goodsItem(floorGoodsList[3]),
        _goodsItem(floorGoodsList[4]),
      ],
    );
  }
  
  Widget _goodsItem(goods){
    return Container(
      width: ScreenUtil().setWidth(375),
      child: InkWell(
        onTap: (){print('点击了楼层尚品');},
        child: Image.network(goods, fit: BoxFit.fitHeight),
      ),
    );
  }
}


// 火爆专区模块

class HotGoods extends StatefulWidget {
  @override
  _HotGoodsState createState() => _HotGoodsState();
}

class _HotGoodsState extends State<HotGoods> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(123);
    request('homePageBlowContent', null).then((val) {
      print(val);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('火爆专区'),
    );
  }
}


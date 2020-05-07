import 'package:flutter/material.dart';  // 风格一 有质感，卡片画的风格
import 'package:flutter/cupertino.dart'; // 风格二  ios的风格
import 'package:flutter_screenutil/flutter_screenutil.dart';
// 引入变量
import 'home_page.dart';
import 'cart_page.dart';
import 'category_page.dart';
import 'member_page.dart';

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  // 定义底部导航栏的数据
  final List<BottomNavigationBarItem>  bottomTabs = [
    BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.home),
      title: Text('首页')
    ),
    BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.search),
      title: Text('分类')
    ),
    BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.shopping_cart),
      title: Text('购物车')
    ),
    BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.profile_circled),
      title: Text('会员中心')
    )
  ];
  // 定义页面数组
  final List<Widget> tabBoids = [
    HomePage(),
    CardPage(),
    CategoryPage(),
    MemberPage(),
  ];
  int currentIndex = 0;
  var currentPage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // 页面初始化的时候
    currentPage = tabBoids[currentIndex];
  }

  @override
  Widget build(BuildContext context) {

    ScreenUtil.init(context, width: 750, height: 1334);  // 设置全局屏幕大小

    return Scaffold(
      backgroundColor: Color.fromRGBO(244, 245, 245, 1.0),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        items: bottomTabs,
        onTap: (index){
          setState(() {
            currentIndex = index;
            currentPage = tabBoids[index];
          });
        },
      ),
      body: IndexedStack(
        index: currentIndex,
        children: tabBoids,
      ),
    );
  }
}


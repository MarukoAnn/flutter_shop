import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_shop/config/httpHeaders.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  TextEditingController typeController = TextEditingController();
  String showText = '还没有请求数据';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
          appBar: AppBar(
            title: Text('请求远程数据'),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                RaisedButton(
                  onPressed: _jikeGet,
                  child: Text('请求数据'),
                ),
                Text(showText)
              ],
            ),
          )
      ),
    );
  }
  void _jikeGet(){
    print('开始向极客时间请求数据.............');
    getHttp().then((val){
      setState(() {
        showText = val['data'].toString();
      });
    });
  }

  Future getHttp() async{
    try{
      Response response;
      Dio dio = new Dio();
      dio.options.headers = httpHeaders;
      response = await dio.get("https://time.geekbang.org/serv/v1/column/newAll");
      print(response);
      return response.data;
    }catch(e){
      print(e);
    }
  }

// 内部方法
//  void _choiceAction(){
//    print('开始选择你喜欢的类型..........');
//    if(typeController.text.toString() == ''){
//      showDialog(
//        context: context,
//        builder: (context) => AlertDialog(title: Text('美女类型不能为空'))
//      );
//    } else{
//      getHttp(typeController.text.toString()).then((val){
//        print(val);
//        setState(() {
//          showText = val['data']['name'].toString();
//        });
//      });
//    }
//  }
//
////  Future getHttp(String TypeText) async{
////    try{
////      Response response;
////      var data = {'name': TypeText};
////      response = await Dio().get(
////          "https://www.easy-mock.com/mock/5c60131a4bed3a6342711498/baixing/dabaojian",
////          queryParameters: data
////      );
////      return response.data;
////    }catch(e){
////      return print(e);
////    }
////  }
//  Future getHttp(String TypeText) async{
//    try{
//      Response response;
//      var data = {'name': TypeText};
//      response = await Dio().post(
//          "https://www.easy-mock.com/mock/5c60131a4bed3a6342711498/baixing/dabaojian",
//          queryParameters: data
//      );
//      return response.data;
//    }catch(e){
//      return print(e);
//    }
//  }
}

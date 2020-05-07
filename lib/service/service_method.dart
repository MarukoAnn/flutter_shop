import 'package:dio/dio.dart';
import 'dart:async';
import 'dart:io';
import '../config/service_url.dart';

// 获取首页主体内容
Future request(url, formData) async{
  try{
    print('开始获取首页数据');
    Response response;
    Dio dio = new Dio();
    Options options = Options(headers: {HttpHeaders.authorizationHeader : "application/json"});
    if(formData == null){
      response = await dio.post(servicePath[url], options: options, data: formData);
    }else{
      response = await dio.post(servicePath[url], options: options, data: formData);
    }
    if (response.statusCode == 200){
      print("请求：123");
      return response.data;
    }else{
      throw Exception('后端接口出现异常');
    }
  }catch(e){
    return print('ERROR: ======> ${e}');
  }
}

// 获得火爆专区的尚品方法
Future getHomePageBlowContent() async{
  try{
    print('开始获取火爆专区数据.........');
    Response response;
    Dio dio = new Dio();
    response = await dio.post(servicePath['homePageBlowContent']);
    if (response.statusCode == 200){
      return response.data;
    }else{
      throw Exception('后端接口出现异常');
    }
  }catch(e){
    return print('ERROR: ======> ${e}');
  }
}
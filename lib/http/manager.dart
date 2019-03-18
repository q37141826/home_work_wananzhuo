import 'package:dio/dio.dart';
import 'package:home_work_route/http/api.dart';

class HttpManager {
  Dio _dio;
  static HttpManager _instance;

  factory HttpManager.getInstance(){
    if (null == _instance) {
      _instance = new HttpManager._internal();
    }
    return _instance;
  }

  HttpManager._internal(){
    ///基础配置
    BaseOptions options = new BaseOptions(
        baseUrl: Api.baseUrl,
        connectTimeout: 5000,
        receiveTimeout: 3000
    );
    _dio=new Dio(options);
  }

  request (url,{String method="get"})async{
    try {
      ///默认使用get请求
      Options option = new Options(method: method);
      Response response = await _dio.request(url, options: option);
      ///一般来说，提供的是json字符串，response.data得到的就是这个json对应的map
      return response.data;
    } catch (e) {
      return null;
    }
  }


}

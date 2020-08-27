import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter_zdds/debug/debug_print.dart';

class BaseUrl {
  // 配置默认请求地址
  static const String url = 'https://gateway-mobile.wyawds.com/';
}

typedef DownloadProgressCallback = Function(double count);
typedef UploadProgressCallback = Function(double count);

class HttpQuerery {

  static Future get(String url,
      {Map<String, dynamic> data, Map<String, dynamic> headers}) async {
    // 数据拼接
    if (data != null && data.isNotEmpty) {
      StringBuffer options = new StringBuffer('?');
      data.forEach((key, value) {
        options.write('${key}=${value}&');
      });
      String optionsStr = options.toString();
      optionsStr = optionsStr.substring(0, optionsStr.length - 1);
      url += optionsStr;
    }

    // 发送get请求
    return await _sendRequest(url, 'get', data: data, headers: headers);
  }

  static Future post(String url,
      {Map<String, dynamic> data, Map<String, dynamic> headers}) async {
    // 发送post请求
    return await _sendRequest(url, 'post', data: data, headers: headers);
  }

  // 请求处理
  static Future _sendRequest(String url, String method,
      {Map<String, dynamic> data, Map<String, dynamic> headers}) async {
    int _code;
    String _msg;

    // 检测请求地址是否是完整地址
    if (!url.startsWith('http')) {
      url = BaseUrl.url + url;
    }

    var deviceInfo = DeviceInfoPlugin();
    var platformName = 'ios';
    var platformVersion = '13';
//    if (Platform.isIOS) {
//      var iosInfo = await deviceInfo.iosInfo;
//      platformName = iosInfo.systemName;
//      platformVersion = iosInfo.systemVersion;
//      print('iosInfo=====${iosInfo.utsname.machine}===');
//    } else if (Platform.isAndroid) {
//      var androidInfo = await deviceInfo.androidInfo;
//      platformName = 'android';
//      platformVersion = androidInfo.version.release;
//      print('androidInfo===$androidInfo====');
//    }


    try {
      Map<String, dynamic> params = {

      };

      if (data != null) {
        params.addAll(data);
      }

      Map<String, dynamic> httpHeader = {

      };



      if (headers != null) {
        httpHeader.addAll(headers);
      }
//      llog([httpHeader, params, url],
//          titles: ['requestHeader', 'requesParams', 'requestUrl']);

      // 配置dio请求信息
      Response response;
      BaseOptions option = BaseOptions(
        connectTimeout: 10000,
        // 服务器链接超时，毫秒
        receiveTimeout: 3000,
        // 响应流上前后两次接受到数据的间隔，毫秒
        headers: httpHeader,
        // 添加headers,如需设置统一的headers信息也可在此添加
        contentType: "application/json",
        responseType: ResponseType.plain,
      );
      Dio dio = Dio(option);
      dio.interceptors.add(LogInterceptor(responseBody: true));
      if (method == 'get') {
        response = await dio.get(url, queryParameters: params);
      } else {
        response = await dio.post(url, data: params);
      }
//      llog([
//        url,
//        response.headers,
//        response.request,
//        response.isRedirect,
//        response.statusCode,
//        response.statusMessage,
//        response.redirects,
//        response.extra,
//        response.data
//      ], titles: [
//        'requestUrl',
//        'response.headers',
//        'response.request',
//        'response.isRedirect',
//        'response.statusCode',
//        'response.statusMessage',
//        'response.redirects',
//        'response.extra',
//        'response.data'
//      ]);
      if (response.statusCode != 200) {
        _msg = '网络请求错误,状态码:' + response.statusCode.toString();
        return _msg;
      }

      // 返回结果处理
      Map<String, dynamic> resCallbackMap = json.decode(response.data);
      _code = resCallbackMap['status'];
      _msg = resCallbackMap['msg'];
      if (_code == -1) {

      } else if (_code == 0) {

      } else {
        return response.data;
      }
    } catch (exception) {
      return '数据请求错误：' + exception.toString();
    }
  }

  static Future download(String url, String path,
      {Map<String, dynamic> params, DownloadProgressCallback progress}) async {
    try {
      Dio dio = Dio();
      Response response = await dio.download(url, path,
          onReceiveProgress: (int count, int total) {
            if (progress != null) {
              progress(count / total);
            }
          }, queryParameters: params);

      llog('response.statusCode===${response.statusCode}====');
      llog('response.statusMessage===${response.statusMessage}====');
      if (response.statusCode != 200) {
        return '网络请求错误,状态码:' + response.statusCode.toString();
      } else {
        return response.data;
      }
    } catch (exception) {
      return '下载失败：' + exception.toString();
    }
  }

  static Future upload(String url, File file,
      {Map<String, dynamic> map, UploadProgressCallback progress}) async {
    try {
      Dio dio = Dio();
      var path = file.path;
      var name = path.substring(path.lastIndexOf("/") + 1, path.length);
      map['file'] = MultipartFile.fromFileSync(path, filename: name);
      FormData formData = FormData.fromMap(map);
      Response response = await dio.post(url, data: formData,
          onSendProgress: (int count, int total) {
            if (progress != null) {
              progress(count / total);
            }
          });
      llog('response.statusCode===${response.statusCode}====');
      llog('response.statusMessage===${response.statusMessage}====');
      if (response.statusCode != 200) {
        return '网络请求错误,状态码:' + response.statusCode.toString();
      } else {
        return url + map['key'];
      }
    } catch (exception) {
      return '上传失败：' + exception.toString();
    }
  }
}

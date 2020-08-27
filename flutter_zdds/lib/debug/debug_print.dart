import 'package:flutter/material.dart';
import 'package:flutter_zdds/debug/debug_widget.dart';


/// 判断当前环境，
/// true：release环境，
/// false：debug、profile环境
const bool inProduction = const bool.fromEnvironment("dart.vm.product");

llog(dynamic str,
    {bool needTime = true,
    bool needLocation = true,
    List<String> titles,
    StackTrace stackTrace}) {
  if (inProduction == true) return;
  String header = '------------本次输出开始------------';
  String footer = '------------本次输出结束------------';
  String stackInfo = '';
  if (stackTrace != null) {
    stackInfo = _stackCut(stackTrace, startIndex: 1, endIndex: 2);
  } else {
    stackInfo = _stackCut(StackTrace.current, startIndex: 1, endIndex: 2);
  }

  var location = 'location:' + stackInfo;

  var time = 'time:' + DateTime.now().toString();
  var printString = header;
  printString += '\n';
  if (needTime == true) {
    printString += time;
    printString += '\n';
  }
  if (needLocation = true) {
    printString += location;
    printString += '\n';
  }
//  var aa = str.runtimeType;
  if (str is List && titles != null) {
    List paramsList = str;
    if (paramsList.length == titles.length) {
      for (int i = 0; i < titles.length; i++) {
        var obj = paramsList[i];
        var title = titles[i];
        var string = title + ':  ' + obj.toString() + '\n';
        printString += string;
      }
      printString += footer;
      debugPrint(printString);
      return;
    }
  }
  printString += ('result:' + str.toString());
  printString += '\n';
  printString += footer;
  debugPrint(printString);
}

debugErrorWidget({Widget widget}) {
  ErrorWidget.builder = (FlutterErrorDetails details) {
    llog([
      details.exception,
      details.stack,
      details.library,
      details.context,
      details.stackFilter,
      details.informationCollector,
      details.silent
    ], titles: [
      'details.exception',
      'details.stack',
      'details.library',
      'details.context',
      'details.stackFilter',
      'details.informationCollector',
      'details.silent'
    ], stackTrace: details.stack);
    if (inProduction == true) {
      return widget != null ? widget : Text('加载失败');
    } else {
      return DebugWidget(details.exception.toString() +
          _stackCut(details.stack, startIndex: 1, endIndex: 2));
    }
  };
}

String _stackCut(StackTrace stackTrace,
    {int startIndex = 0, int endIndex = 1}) {
  if (endIndex <= startIndex) {
    return '栈内信息截取错误,请重新写入开始和结束索引';
  }
  List<String> lines = stackTrace.toString().trimRight().split('\n').toList();
  List<String> cutLines = lines.getRange(startIndex, endIndex).toList();
  return cutLines.toString();
}

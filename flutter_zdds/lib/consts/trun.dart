List<T> listTrun<T>(List<dynamic> list) {
  List<T> copyList = [];
  list.forEach((element) {
    copyList.add(element as T);
  });
  return copyList;
}

String urlTrun(String imageUrl, {bool isOriginal = false}) {
  if (isOriginal == false) {
    return imageUrl + '?x-oss-process=image/resize,w_400,h_400,limit_0';
  }
  return imageUrl;
}

String numberTrun(num number) {
  if (number >= 1000 && number < 10000) {
    num aaa = number / 1000;
    return _formatNum(aaa, 1) + 'k';
  } else if (number >= 10000 && number < 100000) {
    num aaa = number / 10000;
    return _formatNum(aaa, 1) + 'w';
  } else if (number >= 100000 && number < 1000000) {
    num aaa = number / 10000;
    return _formatNum(aaa, 1) + 'w';
  } else {
    return number.toString();
  }
}

/// 截取小数位数，不包括四舍五入
String _formatNum(double num, int postion) {
  if ((num.toString().length - num.toString().lastIndexOf(".") - 1) < postion) {
    //小数点后有几位小数
    return num.toStringAsFixed(postion)
        .substring(0, num.toString().lastIndexOf(".") + postion + 1)
        .toString();
  } else {
    return num.toString()
        .substring(0, num.toString().lastIndexOf(".") + postion + 1)
        .toString();
  }
}

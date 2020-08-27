import 'package:flutter_zdds/consts/screen_info.dart';

double scale(
    {double targetWidth,
      double targetHeight,
      double customWidth = 375.0,
      double customHeight = 667.0}) {

  if (targetWidth != null) {
    return targetWidth * (PhoneWidth / PhoneAdb) / customWidth;
  } else if (targetHeight != null) {
    return targetHeight * (PhoneHeight / PhoneAdb) / customHeight;
  }
  return 0.0;
}
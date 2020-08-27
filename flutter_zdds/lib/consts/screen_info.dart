import 'dart:ui';
import 'package:flutter/material.dart';

final PhoneWidth = window.physicalSize.width;
final PhoneHeight = window.physicalSize.height;
final PhoneAdb = window.devicePixelRatio;

double getScreenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}


double getScreenHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}
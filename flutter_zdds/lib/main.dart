import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zdds/debug/debug_print.dart';
import 'package:flutter_zdds/routes/application.dart';
import 'package:flutter_zdds/routes/routes.dart';
import 'package:flutter_zdds/views/root_widget_page.dart';

void main() {
  debugErrorWidget();
  var router = Router();
  Routes.configureRoutes(router);
  Application.router = router;
  runApp(RootWidgetPage());
}
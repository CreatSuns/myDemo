import 'package:flutter/material.dart';
import 'package:flutter_zdds/views/homepage.dart';
import 'package:flutter_zdds/views/minepage.dart';
import 'package:flutter_zdds/views/otherpage.dart';


class RootWidgetPage extends StatefulWidget {
  @override
  _RootWidgetPageState createState() => _RootWidgetPageState();
}

class _RootWidgetPageState extends State<RootWidgetPage> {
  int _currentIndex = 0;
  var _body;

  List<String> bottomBarTitles = ['首页', '其它', '我的'];
  List<Icon> bottomSelectImages = [
    Icon(Icons.home),
    Icon(Icons.devices_other),
    Icon(Icons.person)
  ];
  List<Icon> bottomUnselectImages = [
    Icon(Icons.home),
    Icon(Icons.devices_other),
    Icon(Icons.person)
  ];

  Map routes = {};

  changeIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  initData() {
    _body = IndexedStack(
      children: <Widget>[HomePage(), OtherPage(), MinePage()],
      index: _currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    initData();
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          items: _getBottomNavigatorItems(),
          onTap: changeIndex,
          currentIndex: _currentIndex,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
        ),
        body: _body,
      ),
    );
  }

  List<BottomNavigationBarItem> _getBottomNavigatorItems() {
    List<BottomNavigationBarItem> items = [];
    for (int i = 0; i < bottomBarTitles.length; i++) {
      items.add(_getBottomNavigatorItem(
          bottomBarTitles[i], bottomSelectImages[i], bottomUnselectImages[i]));
    }
    return items;
  }

  BottomNavigationBarItem _getBottomNavigatorItem(
      String title, Icon selectIcon, Icon unSelectIcon) {
    return BottomNavigationBarItem(
      icon: selectIcon,
//      activeIcon: unSelectIcon,
      title: Text(title),
    );
  }
}

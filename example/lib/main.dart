import 'package:flutter/material.dart';
import 'package:flutter_leak_find/leak_observer.dart';

import 'home_page.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyAppState();
  }
}

class _MyAppState extends State <MyApp>{

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter leak find',
      theme: ThemeData(
        primaryColor: Color(0xFFFF552E),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
      navigatorObservers: [
        LeakObserver()
      ],
    );
  }

}



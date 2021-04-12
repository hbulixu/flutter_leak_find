import 'package:flutter/material.dart';
import 'page_one.dart';
import 'page_two.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<WidgetBuilder> pages = [
    (context)=>PageOne(),
    (context)=>PageTwo()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Leak Find'),

      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(pages.length, (index) {
              final pagebuilder = pages[index];
              return FlatButton(
                  onPressed: () => Navigator.
                      push(context,new MaterialPageRoute(builder: pagebuilder)),
                  child: Text(pagebuilder.toString()));
            }),
          ),
        ),
      ),
    );
  }
}

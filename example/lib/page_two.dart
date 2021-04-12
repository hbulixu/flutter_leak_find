import 'dart:async';

import 'package:flutter/material.dart';

class PageTwo extends StatefulWidget {
  @override
  _PageTwoState createState() => _PageTwoState();

}

class _PageTwoState extends State<PageTwo> {

  @override
  Widget build(BuildContext context) {

    leakByGlobal._stateList.add(this);
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child:RaisedButton(child: Text("push") ,
          onPressed: (){
//
            Future.delayed(Duration(minutes: 5), () {
              print('delay 5m ');
              print(context);
            });
            Navigator.pop(context);
            //Navigator.pop(context);

          },),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
   // anotherTestForLeak = null;
    super.dispose();
  }
}
//这个被引用的原理

LeakByGlobal leakByGlobal = LeakByGlobal();

class LeakByGlobal{
  Set<State> _stateList = {};
}



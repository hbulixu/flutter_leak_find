import 'package:flutter/material.dart';

import 'leak_check.dart';

class LeakObserver extends NavigatorObserver {

  @override
  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) => _findLeak(route, previousRoute);


  @override
  void didReplace({Route<dynamic> newRoute, Route<dynamic> oldRoute}) => _findLeak(newRoute, oldRoute);


  @override
  void didRemove(Route<dynamic> route, Route<dynamic> previousRoute) => _findLeak(route, previousRoute);

  Future<bool> get enableCheck => Future.value(true);

  void _findLeak(Route<dynamic> route, Route<dynamic> previousRoute) async{
    final enableCheck = await this.enableCheck;
    if(!enableCheck) return;
    Future.delayed(const Duration(milliseconds: 1000),(){
      findLeak(route, previousRoute, navigator);
    });

  }

}
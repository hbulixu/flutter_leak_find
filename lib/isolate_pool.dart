import 'dart:async';

import 'package:isolate/isolate.dart';

class IsolatePool{

  static final IsolatePool _isolatePool =  IsolatePool._internal();

  factory IsolatePool(){
    return _isolatePool;
  }
  IsolatePool._internal();

  LoadBalancer _loadBalance;

  Future <R> compute<R,P>(FutureOr<R> Function(P argument) function, argument) async{

    if(_loadBalance == null){
      _loadBalance = await LoadBalancer.create(2, IsolateRunner.spawn);
    }
    final res =  await _loadBalance.run<R,P>(function,argument);

    return res;
  }

}
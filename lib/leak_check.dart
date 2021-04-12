
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'isolate_pool.dart';
import 'leak_list_page.dart';
import 'overlay_tools.dart';
import 'vm_utils.dart';

bool canCheck = true;

bool isDebug() {
  bool inDebug = false;
  assert(inDebug = true);
  return inDebug;
}

 void findLeak(Route<dynamic>  route, Route<dynamic>  previousRoute, NavigatorState navigator) async{
   if(!isDebug()) return;
   if(!canCheck) return;
    String widgetName;
    BuildContext context = navigator.context;
    switch (route.runtimeType) {
      case MaterialPageRoute:
        final r = route as MaterialPageRoute;
        Widget widget = r.builder.call(context);
        widgetName = widget.toString();
        widget = null;
        break;
      case CupertinoPageRoute:
        final r = route as MaterialPageRoute;
        Widget widget = r.builder.call(context);
        widgetName = widget.toString();
        widget = null;
        break;
      default:
        if (route is PageRoute) {
          Widget widget =
          route.buildPage(context, ProxyAnimation(), ProxyAnimation());
          widgetName = widget.toString();
          widget = null;
        }
        break;
    }
    IsolatePool().compute(_findLeakInstance,[widgetName]).then((value){
        List<LeakObject> leakList = value;
        if(leakList.length > 0){

          OverlayTools().show(AlertDialog(
                    title: Text('警告'),
                    content: Text('发现泄漏是否查看'),
                    actions: <Widget>[
                      FlatButton(
                          onPressed: (){
                            OverlayTools().hide();
                          },
                          child: Text('取消',style: TextStyle(color: Color(0xFFFF552E)))
                      ),
                      FlatButton(
                          onPressed: (){
                            OverlayTools().hide();
                            canCheck = false;
                            navigator.push(new MaterialPageRoute(builder: (context)=>LeakListPage(leakList: leakList))).then((value){
                              canCheck = true;
                            });
                          },
                          child:Text('查看',style: TextStyle(color: Color(0xFFFF552E))) )
                    ],
                  ), navigator.overlay);
        }
    });

  }

  Future<List<LeakObject>> _findLeakInstance(List<String> widgetNames)async{
    VmInfo vmInfo =  await VMUtils().connect();
    List <ClassInfo> classInfoList = await VMUtils().getClassInfo(vmInfo,widgetNames);
    List<LeakObject> leakObjectList = await VMUtils().getInstance(vmInfo,classInfoList);
    return leakObjectList;
  }

  Future<List<RetainInfo>> getRetainPath(String objectId) async{
    return await IsolatePool().compute(_getRetainPath, objectId);
  }

  Future<List<RetainInfo>> _getRetainPath(String objectId) async{
    VmInfo vmInfo =  await VMUtils().connect();
    List<RetainInfo>  retainInfo = await VMUtils().getRetainPath(vmInfo, objectId);
    return retainInfo;
  }

  Future<List<String>> getRetainInfoList(List<RetainInfo> retainInfoList) async{
    return await IsolatePool().compute(_getRetainInfoList, retainInfoList);
  }

  List<String> _getRetainInfoList(List<RetainInfo> retainInfoList){

    var retainInfoSet = Map<String,String>();
    var retList = List<String>();
    retainInfoList.forEach((element) {
      var elementKey = element.className+'.'+element.field;
      if(retainInfoSet.containsKey(elementKey)){
          return;
      }
      retainInfoSet.putIfAbsent(elementKey, () =>'true');
      retList.add(elementKey);
    });
    return  retList;
  }

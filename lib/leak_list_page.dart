

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'leak_detail_page.dart';
import 'vm_utils.dart';

class LeakListPage extends StatefulWidget{
  final List<LeakObject> leakList;

  const LeakListPage({Key key, this.leakList}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LeakListPageState();
  }

}
class _LeakListPageState extends State<LeakListPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('泄漏列表'),
       // backgroundColor: Color(0xFFFF552E),
      ),
      body:buildBody() ,
    );
  }

  Widget buildBody(){
    return Container(
      child: ListView.builder(
          itemBuilder: (context,index){
            final curObj = this.widget.leakList[index];
            return buildItem(context,curObj);
          },
          itemCount: this.widget.leakList.length,
      ),
    );
  }

  Widget buildItem(BuildContext context,LeakObject leakObject){
    final leakCount = leakObject.existCount;
    final leakObjName = leakObject.classInfo.leakClass.name;
    final filePath = leakObject.classInfo.filePath;
    return GestureDetector(
        onTap: (){
          Navigator.of(context).push(new MaterialPageRoute(builder: (context)=>LeakDetailPage(objName: leakObjName,objId: leakObject.instance.instances.first.id,)));
        },
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('类名    :  '+leakObjName),
              Text('实例数:  '+leakCount.toString()),
              Text('路径    :  '+filePath)
            ],
          ),
        ),
    );

  }

}

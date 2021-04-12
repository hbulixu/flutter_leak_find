


import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'leak_check.dart';
import 'vm_utils.dart';

class LeakDetailPage extends StatefulWidget{

  final String objId;
  final String objName;

  const LeakDetailPage({Key key, this.objId, this.objName}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
      return _LeakDetailState();
  }

}

class _LeakDetailState extends State<LeakDetailPage>{
  List<RetainInfo> retainList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRetainPath(widget.objId).then((value){
        retainList = value;
        setState(() {

        });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.objName),
        backgroundColor: Color(0xFFFF552E),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.details),
            onPressed: (){
              getRetainInfoList(retainList).then((list){

                var encoder = JsonEncoder.withIndent('  ');
                String strJson = encoder.convert(list);
                showDialog(context: context,builder: (BuildContext context)=>AlertDialog(
                  content: SingleChildScrollView(child: Text(strJson)),
                  actions: <Widget>[
                    FlatButton(onPressed: ()=>Navigator.pop(context), child: Text('关闭',style: TextStyle(color: Color(0xFFFF552E)))),
                    FlatButton(onPressed: ()=>Clipboard.setData(ClipboardData(text: strJson)), child: Text('复制',style: TextStyle(color: Color(0xFFFF552E))))
                  ],
                ));
              });
            },
          )
        ],
      ),
      body:buildBody(),
    );
  }

  Widget buildBody(){
    return Container(
      child: ListView.builder(
        itemBuilder: (context,index){
          final curObj = retainList[index];
          return buildItem(context,curObj);
        },
        itemCount: retainList.length,
      ),
    );
  }

  Widget buildItem(BuildContext context,RetainInfo retainInfo){
    final className = retainInfo.className;
    final filedName = retainInfo.field;
    return GestureDetector(
      child: Container(
      height: 70,
      child: Row(
        children: <Widget>[
          Container(
            height: 70,
            width: 20,
            child: leftItem(),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
          ),
          Expanded(child: rightItem(className,filedName))
        ],
      ),
    )
    );
  }

  Widget leftItem() {
    return Stack(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 1),
          child: VerticalDivider(
            thickness: 2,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 5, top: 25),
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFFF552E),
            ),
          ),
        ),
      ],
    );
  }

  Widget rightItem( String className,String fieldName) {
    return Container(
           height: 50,
           decoration: new BoxDecoration(
              color: Colors.white,
              //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
              //设置四周边框
              border: new Border.all(width: 1, color:Color(0xFFFF552E)),
          ),
           child: Center(child: Text(className+'.'+fieldName,style: TextStyle(color: Colors.black)))
          );

  }

}




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
          return buildItem(context,curObj,index);
        },
        itemCount: retainList.length,
      ),
    );
  }

  Widget buildItem(BuildContext context,RetainInfo retainInfo,int index){
    final className = retainInfo.className;
    final filedName = retainInfo.field;
    return GestureDetector(
      child: Container(
        height: 80,
        child: Row(
          children: <Widget>[
            Container(
              width: 40,
              child: leftItem(index),
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

  Widget leftItem(int index) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 15),
          child: VerticalDivider(
            thickness: 1,
            color: Color(0xFFFF552E),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 5, top: 0),
          child: Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: Center(
              child: Container(
                width: 25,
                height: 25,
                child: Center(
                    child: Text(
                      index.toString(),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 10
                      ),
                    )
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFFF552E),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget rightItem( String className,String fieldName) {
    return Container(
           height: 80,
           child: Text(
              'ClassName:  ' +className+'\n'+'FieldName :  ' +fieldName,
               style: TextStyle(color:  Color(0xFFFF552E)))
          );

  }

}

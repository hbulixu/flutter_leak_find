import 'package:flutter/material.dart';

class OverlayTools{
  static OverlayTools _instance = OverlayTools._internal();

  factory OverlayTools(){
    return _instance;
  }

  OverlayTools._internal();

  OverlayEntry _overlayEntry;

  void show(Widget showWidget,OverlayState overlayState){

    _overlayEntry = OverlayEntry(builder: (ctx){
      return showWidget;
    });
    overlayState.insert(_overlayEntry);
  }

  void hide(){
    if(_overlayEntry != null){
      _overlayEntry.remove();
    }
  }

}
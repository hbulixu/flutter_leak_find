import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class PageOne extends StatefulWidget {

  @override
  _PageOneState createState() => _PageOneState();
}

class _PageOneState extends State<PageOne> with SingleTickerProviderStateMixin,TickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;
  @override
  void initState() {
    _controller =
        AnimationController(duration: Duration(seconds: 2), vsync: this);
    _animation = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
    _controller.repeat();

    super.initState();
  }

  @override
  void dispose() {
   // _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: AnimatedBuilder(
          builder: (context, child) {
            return Transform.scale(
              scale:_animation.value,
              child: Container(
                color: Color(0xFFFF552E),
                width: 100,
                height: 100,
              ),
            );
          },
          animation: _animation,
        ),
      ),
    );
  }
}

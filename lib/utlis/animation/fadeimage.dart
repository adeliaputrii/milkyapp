

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class FadeInImageWidget extends StatefulWidget {
  final String imageUrl;
  final double height;
  final double width;

  FadeInImageWidget({
    required this.imageUrl, 
    required this.height,
    required this.width
    });

  @override
  _FadeInImageWidgetState createState() => _FadeInImageWidgetState();
}

class _FadeInImageWidgetState extends State<FadeInImageWidget> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return 
    Container(
      height: widget.height,
      width: widget.width,
      child: FadeTransition(
        opacity: _animation,
        child: Image.asset(
        widget.imageUrl, 
        fit: BoxFit.cover,),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
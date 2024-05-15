import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FadeAnimationTextWidget extends StatefulWidget {
  final String imageUrl;

  FadeAnimationTextWidget({required this.imageUrl});

  @override
  _FadeAnimationTextWidgetState createState() => _FadeAnimationTextWidgetState();
}

class _FadeAnimationTextWidgetState extends State<FadeAnimationTextWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Text(
        '${widget.imageUrl}',
        style: GoogleFonts.orbitron(
          fontSize: 50,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        overflow: TextOverflow.fade,
        maxLines: 1,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

import 'package:flutter/cupertino.dart';

class ArrowBounceAnimation extends StatefulWidget {
  final Function onTap;
  final Widget child;

  ArrowBounceAnimation({this.child, this.onTap});

  @override
  _ArrowBounceAnimationState createState() => _ArrowBounceAnimationState();
}

class _ArrowBounceAnimationState extends State<ArrowBounceAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> animation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 600,
      ),
    )..addListener(() {
        if (mounted) setState(() {});
      });
    animation = Tween(begin: 0.0, end: 0.3)
        .chain(CurveTween(curve: Curves.easeInCubic))
        .animate(_controller);
    super.initState();
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.removeListener(() {});
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double scale = 1.3 - animation.value;
    return GestureDetector(
      onTap: _onTap,
      child: Transform.scale(
        scale: scale,
        child: Container(child: widget.child),
      ),
    );
  }

  void _onTap() {
    if (widget.onTap != null) widget.onTap();
  }
}

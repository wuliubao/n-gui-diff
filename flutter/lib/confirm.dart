import 'dart:math' as math;
import 'package:flutter/material.dart';

class ConfirmBox extends StatefulWidget {
 // final boxPosition;
  final AnimationController controller;
  final Animation<double> doubleAnimation;
  final Offset start;

  ConfirmBox({
   // this.boxPosition = 0.0,
    this.controller,
    this.doubleAnimation,
    this.start,
  });

  @override
  ConfirmState createState() => ConfirmState();
}

class ConfirmState extends State<ConfirmBox> with TickerProviderStateMixin {
  double boxPosition;
  double boxPositionOnStart;
  Offset start;
  Offset point;


  AnimationController controller;
  Animation<double> doubleAnimation;

  @override
  void initState() {
//    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 2000));
//    final CurvedAnimation curve =  new CurvedAnimation(parent: controller, curve: Curves.linear);
//    doubleAnimation = new Tween(begin: 0.0, end: 2.0).animate(curve)
//      ..addListener((){
//      setState(() {
//        print(doubleAnimation.value);
//      });
//    });
    controller = widget.controller;
    doubleAnimation = widget.doubleAnimation;
    start = widget.start;

    super.initState();

  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void startDrag(DragStartDetails details) {
    print("touch start?");
    start = (context.findRenderObject() as RenderBox)
        .globalToLocal(details.globalPosition);
    setState(() {
      controller.forward(from:0.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
//      color: Colors.blue,
//      width: 200.0,
//      height: 500.0,
      child:GestureDetector(
//        onPanStart: startDrag,
        child: CustomPaint(
          painter: confirmPainter(doubleAnimation.value, start),
          child: Container(),
        ),
      ),
    )
;
  }

}

class confirmPainter extends CustomPainter {
  final double boxPosition;
  final Offset start;

  confirmPainter(this.boxPosition,this.start);


  double midPositionX = 180.0;
  double midPositionY = 320.0;

  double postPositionX = 330.0;
  double postPositionY = 50.0;

  double currentPositionX = 0.0;
  double currentPositionY = 0.0;

  double scale = 1.0;
  double scaleUp = 1.0;

  double _evaluateCubic(double a, double b, double m) {
    return 3 * a * (1 - m) * (1 - m) * m +
        3 * b * (1 - m) *           m * m +
        m * m * m;
  }

  double CubicTransform(double t) {
    double _cubicErrorBound = 0.001;
    double a = 0.0;
    double b = 0.0;
    double c = 0.48;
    double d = 1.0;
    assert(t >= 0.0 && t <= 1.0);
    double start = 0.0;
    double end = 1.0;
    while (true) {
      final double midpoint = (start + end) / 2;
      final double estimate = _evaluateCubic(a, c, midpoint);
      if ((t - estimate).abs() < _cubicErrorBound)
        return _evaluateCubic(b, d, midpoint);
      if (estimate < t)
        start = midpoint;
      else
        end = midpoint;
    }
  }

  double transform(double t) {
    double period = 0.4;
    assert(t >= 0.0 && t <= 1.0);
    final double s = period / 4.0;
    return math.pow(2.0, -10 * t) * math.sin((t - s) * (math.pi * 2.0) / period) + 1.0;
  }

  void paint(Canvas canvas, Size size) {
    var paint;
    
    final Gradient gradient = new RadialGradient(colors: []);
    var paintScale =new Paint()
      ..color = Colors.green[300];
    if (boxPosition < 0.5) {
      double t = boxPosition * 2;
      paint = new Paint()
        ..color = Colors.pink;
      currentPositionX = (midPositionX - start.dx)*t +start.dx;
      currentPositionY = (midPositionY - start.dy)*t+ start.dy;
    } else if (boxPosition >= 0.5 && boxPosition < 1.5){
      double t = boxPosition - 0.5;
      paint = new Paint()
        ..color = Colors.green;
      scale = scale*(0.2 +transform(t));
      scaleUp = scale*(0.5 +transform((t)));
      currentPositionX = midPositionX;
      currentPositionY = midPositionY;

    } else if (boxPosition >= 1.5){
      double t = (boxPosition - 1.5) * 2;
      scale = scale * (1.2 - t);
      scaleUp = scale * (1.5 - t);
      paint = new Paint()
        ..color = Colors.green;
      currentPositionX = (postPositionX - midPositionX)*CubicTransform(t) + midPositionX;
      currentPositionY = (postPositionY - midPositionY)*t + midPositionY;
//      changePositionX = (boxPosition-0.8) * changePositionX;
//      changePositionY = - (boxPosition-1) * changePositionY;
    }


    canvas.drawCircle(
        Offset(currentPositionX, currentPositionY),
        30.0*scaleUp,
        paintScale
    );
    canvas.drawCircle(
        Offset(currentPositionX, currentPositionY),
        30.0*scale,
        paint
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
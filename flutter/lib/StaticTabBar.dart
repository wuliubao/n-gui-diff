import 'package:flutter/material.dart';

double _indexChangeProgress(TabController controller) {
  final double controllerValue = controller.animation.value;
  final double previousIndex = controller.previousIndex.toDouble();
  final double currentIndex = controller.index.toDouble();

  // The controller's offset is changing because the user is dragging the
  // TabBarView's PageView to the left or right.
  if (!controller.indexIsChanging)
    return (currentIndex - controllerValue).abs().clamp(0.0, 1.0);

  // The TabController animation's value is changing from previousIndex to currentIndex.
  return (controllerValue - currentIndex).abs() / (currentIndex - previousIndex).abs();
}


/// Used by [TabPageSelector] to indicate the selected page.
class TabPageSelectorIndicator extends StatelessWidget {
  /// Creates an indicator used by [TabPageSelector].
  ///
  /// The [backgroundColor], [borderColor], and [size] parameters must not be null.
  const TabPageSelectorIndicator({
    Key key,
    @required this.backgroundColor,
    @required this.borderColor,
    @required this.size,
  }) : assert(backgroundColor != null), assert(borderColor != null), assert(size != null), super(key: key);

  /// The indicator circle's background color.
  final Color backgroundColor;

  /// The indicator circle's border color.
  final Color borderColor;

  /// The indicator circle's diameter.
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80.0,
      height: size,
      margin: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        //border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(5.0),
        //shape: BoxShape.circle,
      ),
    );
  }
}

/// Displays a row of small circular indicators, one per tab. The selected
/// tab's indicator is highlighted. Often used in conjunction with a [TabBarView].
///
/// If a [TabController] is not provided, then there must be a [DefaultTabController]
/// ancestor.
class StaticTabBarSelector extends StatelessWidget {
  /// Creates a compact widget that indicates which tab has been selected.
  const StaticTabBarSelector({
    Key key,
    this.controller,
    this.indicatorSize = 20.0,
    this.color,
    this.selectedColor,
  }) : assert(indicatorSize != null && indicatorSize > 0.0), super(key: key);

  /// This widget's selection and animation state.
  ///
  /// If [TabController] is not provided, then the value of [DefaultTabController.of]
  /// will be used.
  final TabController controller;

  /// The indicator circle's diameter (the default value is 12.0).
  final double indicatorSize;

  /// The indicator circle's fill color for unselected pages.
  ///
  /// If this parameter is null then the indicator is filled with [Colors.transparent].
  final Color color;

  /// The indicator circle's fill color for selected pages and border color
  /// for all indicator circles.
  ///
  /// If this parameter is null then the indicator is filled with the theme's
  /// accent color, [ThemeData.accentColor].
  final Color selectedColor;

  Widget _buildTabIndicator(
      int tabIndex,
      TabController tabController,
      ColorTween selectedColorTween,
      ColorTween previousColorTween,
      Tween<double> selectedScaleTween,
      Tween<double> previousScaleTween,
      ) {
    Color background;
    double scale;
    if (tabController.indexIsChanging) {
      // The selection's animation is animating from previousValue to value.
      final double t = 1.0 - _indexChangeProgress(tabController);
      if (tabController.index == tabIndex) {
        background = selectedColorTween.lerp(t);
        scale = selectedScaleTween.lerp(t);
      }else if (tabController.previousIndex == tabIndex) {
        background = previousColorTween.lerp(t);
        scale = previousScaleTween.lerp(t);
      }else
        background = selectedColorTween.begin;
        scale = selectedScaleTween.begin;
    } else {
      // The selection's offset reflects how far the TabBarView has / been dragged
      // to the previous page (-1.0 to 0.0) or the next page (0.0 to 1.0).
      final double offset = tabController.offset;
      if (tabController.index == tabIndex) {
        background = selectedColorTween.lerp(1.0 - offset.abs());
        scale = selectedScaleTween.lerp(1.0 - offset.abs());

      } else if (tabController.index == tabIndex - 1 && offset > 0.0) {
        background = selectedColorTween.lerp(offset);
        scale = selectedScaleTween.lerp(offset);
      } else if (tabController.index == tabIndex + 1 && offset < 0.0) {
        background = selectedColorTween.lerp(-offset);
        scale = selectedScaleTween.lerp(-offset);
      } else {
        background = selectedColorTween.begin;
        scale = selectedScaleTween.begin;
      }
    }
//    return new Container(
//      width: 100.0,
//      height: 100.0,
//      color: Colors.red,
//    );
    return TabPageSelectorIndicator(
      backgroundColor: background,
      borderColor: selectedColorTween.end,
      size: indicatorSize * scale,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color fixColor = color ?? Colors.transparent;
    final Color fixSelectedColor = selectedColor ?? Theme.of(context).accentColor;
    final ColorTween selectedColorTween = ColorTween(begin: fixColor, end: fixSelectedColor);
    final ColorTween previousColorTween = ColorTween(begin: fixSelectedColor, end: fixColor);
    final Tween selectedScaleTween = Tween<double>(begin: 1.0, end: 1.5);
    final Tween previousScaleTween = Tween<double>(begin: 1.5, end: 1.0);
    final TabController tabController = controller ?? DefaultTabController.of(context);
    final Tween moveTween = Tween<double>(begin: 0.0, end: 90.0);
    assert(() {
      if (tabController == null) {
        throw FlutterError(
            'No TabController for $runtimeType.\n'
                'When creating a $runtimeType, you must either provide an explicit TabController '
                'using the "controller" property, or you must ensure that there is a '
                'DefaultTabController above the $runtimeType.\n'
                'In this case, there was neither an explicit controller nor a default controller.'
        );
      }
      return true;
    }());
    final Animation<double> animation = CurvedAnimation(
      parent: tabController.animation,
      curve: Curves.fastOutSlowIn,
    );

    double translateX ;
    return AnimatedBuilder(
        animation: animation,
        builder: (BuildContext context, Widget child) {

          final double offset = tabController.offset;
         // print(offset);
          translateX = moveTween.lerp(offset);
          //print(tabController.index);
          return Semantics(
            label: 'Page ${tabController.index + 1} of ${tabController.length}',
            child: Transform(
                transform: Matrix4.translationValues(90.0-tabController.index*90.0-translateX, 0.0, 0.0),
                child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List<Widget>.generate(tabController.length, (int tabIndex) {
              return _buildTabIndicator(tabIndex, tabController, selectedColorTween, previousColorTween,selectedScaleTween,previousScaleTween);
            }).toList(),)
          ),
          );
        }
    );
  }
}
import 'package:any1/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomActiveDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.55,
      width: double.maxFinite,
      margin: EdgeInsets.only(left: 75.0, right: 50.0, bottom: 3.0, top: 3.0),
      decoration: BoxDecoration(
        color: isLightTheme(context) ? Colors.black26 : Colors.white10,
        borderRadius: BorderRadius.circular(0.55),
      ),
    );
  }
}

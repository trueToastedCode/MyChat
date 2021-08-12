import 'package:any1/colors.dart';
import 'package:any1/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final Function(String str) onChanged;
  final double height;
  final TextInputAction inputAction;

  const CustomTextField({
    required this.hint,
    required this.onChanged,
    this.height = 54.0,
    required this.inputAction
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: TextField(
        keyboardType: TextInputType.text,
        onChanged: onChanged,
        textInputAction: inputAction,
        cursorColor: kPrimary,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 4.5),
          hintText: hint,
          border: InputBorder.none,
        ),
        style: Theme.of(context).textTheme.bodyText1!.copyWith(
          color: isLightTheme(context) ? Colors.black : Colors.white,
          fontWeight: FontWeight.bold
        ),
        textAlign: TextAlign.center,
        // textAlign: TextAlign.center,
      ),
      decoration: BoxDecoration(
        color: isLightTheme(context) ? Colors.white : kBubbleDark,
        borderRadius: BorderRadius.circular(45.0),
        border: Border.all(
          color: isLightTheme(context) ? Color(0xffc4c4c4) : Color(0xff393737),
          width: 1.5,
        ),
      ),
    );
  }
}

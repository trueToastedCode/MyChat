import 'package:flutter/cupertino.dart';

class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // colors used: 1a85d0, ae4099, ee5598
      child: Image.asset('assets/logo.png', fit: BoxFit.fill),
    );
  }
}

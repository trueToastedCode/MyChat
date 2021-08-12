import 'package:any1/ui/widgets/home/online_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileImage extends StatelessWidget {
  final String imageUrl;
  final bool online;
  final double size;
  ProfileImage({required this.imageUrl, this.online = false, this.size = 126.0});
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.transparent,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(size),
            child: Image.network(imageUrl, width: size, height: size, fit: BoxFit.fill),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: online ? OnlineIndicator() : Container(),
          ),
        ],
      ),
    );
  }
}

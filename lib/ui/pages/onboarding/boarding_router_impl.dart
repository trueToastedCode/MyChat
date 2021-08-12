import 'package:chat/src/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'boarding_router_contract.dart';

class OnboardingRouter implements IOnboardingRouter {
  final Widget Function(User boardedUser) onSessionConnected;

  OnboardingRouter(this.onSessionConnected);

  @override
  void onSessionSuccess(BuildContext context, User boardedUser) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => onSessionConnected(boardedUser)),
        (Route<dynamic> route) => false);
  }
}
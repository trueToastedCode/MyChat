import 'package:chat/chat.dart';
import 'package:flutter/cupertino.dart';

abstract class IOnboardingRouter {
  void onSessionSuccess(BuildContext context, User boardedUser);
}
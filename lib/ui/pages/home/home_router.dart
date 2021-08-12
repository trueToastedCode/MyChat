import 'package:chat/chat.dart';
import 'package:flutter/material.dart';

abstract class IHomeRouter {
  Future<void> onShowMessageThread(BuildContext context, User receiver, User me,
      {required String chatId});
}

class HomeRouter implements IHomeRouter {
  final Widget Function(User receiver, User me, {required String chatId}) showMessageThread;

  const HomeRouter({required this.showMessageThread});

  @override
  Future<void> onShowMessageThread(BuildContext context, User receiver, User me,
      {required String chatId}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => showMessageThread(receiver, me, chatId: chatId),
      ),
    );
  }
}
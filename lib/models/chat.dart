import 'package:any1/models/local_message.dart';
import 'package:chat/chat.dart';

class Chat {
  String id;
  int unread = 0;
  List<LocalMessage> messages;
  LocalMessage? mostRecent;
  User? from;

  Chat(this.id, {List<LocalMessage>? messages, this.mostRecent})
      : this.messages = messages == null ? [] : messages;

  toMap() => {'id': id};

  factory Chat.fromMap(Map<String, dynamic> json) => Chat(json['id']);
}
import 'package:any1/models/chat.dart';
import 'package:any1/models/local_message.dart';
import 'package:chat/chat.dart';

abstract class IDatasource {
  Future<void> addChat(Chat chat);
  Future<void> addMessage(LocalMessage message);
  Future<void> deleteChat(String chatId);
  Future<List<Chat>> findAllChats();
  Future<Chat?> findChat(String chatId);
  Future<List<LocalMessage>> findMessages(String chatId);
  Future<void> updateMessage(LocalMessage message);
  Future<void> updateMessageReceipt(String messageId, ReceiptStatus status);
}
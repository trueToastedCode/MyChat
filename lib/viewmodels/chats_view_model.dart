import 'package:any1/data/datasource/datasource_contract.dart';
import 'package:any1/models/chat.dart';
import 'package:any1/models/local_message.dart';
import 'package:any1/viewmodels/base_view_model.dart';
import 'package:chat/chat.dart';

class ChatsViewModel extends BaseViewModel {
  IDatasource _datasource;
  IUserService _userService;

  ChatsViewModel(this._datasource, this._userService) : super(_datasource);

  Future<List<Chat>> getChats() async {
    final chats = await _datasource.findAllChats();
    await Future.forEach(chats, (Chat chat) async {
      chat.from = await _userService.fetch(chat.id);
    });
    return chats;
  }

  Future<void> receivedMessage(Message message) async {
    LocalMessage localMessage = LocalMessage(message.from, message, ReceiptStatus.deliverred);
    await addMessage(localMessage);
  }
}
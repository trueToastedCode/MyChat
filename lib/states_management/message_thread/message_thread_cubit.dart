import 'package:any1/data/datasource/datasource_contract.dart';
import 'package:any1/models/local_message.dart';
import 'package:any1/viewmodels/chat_view_model.dart';
import 'package:bloc/bloc.dart';
import 'package:chat/chat.dart';

class MessageThreadCubit extends Cubit<List<LocalMessage>> {
  final ChatViewModel viewModel;
  final IDatasource _datasource;

  MessageThreadCubit(this.viewModel, this._datasource) : super([]);

  Future<void> messages(String chatId) async {
    final messages = await viewModel.getMessages(chatId);
    emit(messages);
  }
}
import 'package:any1/models/chat.dart';
import 'package:any1/viewmodels/chats_view_model.dart';
import 'package:bloc/bloc.dart';

class ChatsCubit extends Cubit<List<Chat>> {
  final ChatsViewModel viewModel;

  ChatsCubit(this.viewModel) : super([]);

  Future<void> chats() async {
    final chats = await viewModel.getChats();
    emit(chats);
  }
}
import 'package:any1/colors.dart';
import 'package:any1/models/chat.dart';
import 'package:any1/states_management/home/chats_cubit.dart';
import 'package:any1/states_management/message/message_bloc.dart';
import 'package:any1/states_management/typing_notification/typing_notification_bloc.dart';
import 'package:any1/theme.dart';
import 'package:any1/ui/pages/home/home_router.dart';
import 'package:any1/ui/widgets/home/profile_image.dart';
import 'package:chat/chat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class Chats extends StatefulWidget {
  final User user;
  final IHomeRouter _homeRouter;
  const Chats(this.user, this._homeRouter);
  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  List<Chat> _chats = [];
  final typingEvents = [];

  @override
  void initState() {
    super.initState();
    _updateChatsOnMessageReceived();
    context.read<ChatsCubit>().chats();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatsCubit, List<Chat>>(
      builder: (_, chats) {
        this._chats = chats;
        if (this._chats .isEmpty) return Container();
        context.read<TypingNotificationBloc>().add(
            TypingNotificationEvent.onSubscribed(
                widget.user,
                usersWithChat: _chats
                    .map<String>((e) => e.from!.id!)
                    .toList()));
        return _buildListView();
      },
    );
  }

  _buildListView() {
    return ListView.separated(
        padding: EdgeInsets.only(top: 30.0, right: 15.0, left: 15.0), // don't forget about the curved displays
        itemBuilder: (_, index) => _chatItem(_chats[index]),
        separatorBuilder: (_, __) => SizedBox(height: 15.0),
        itemCount: _chats.length
    );
  }

  _chatItem(Chat chat) => ClipRRect(
    borderRadius: BorderRadius.circular(20.0),
    child: Material(
      color: isLightTheme(context) ? kBubbleLight2 : kBubbleDark2,
      child: ListTile(
        onTap: () async {
          await this.widget._homeRouter.onShowMessageThread(
              context, chat.from!, widget.user, chatId: chat.id);
          await context.read<ChatsCubit>().chats();
        },
        leading: SizedBox(
          width: 44.0,
          height: 44.0,
          child: ProfileImage(
            size: 44.0,
            imageUrl: chat.from!.photoUrl,
            online: true,
          ),
        ),
        title: Text(
          chat.from!.username,
          style: Theme.of(context).textTheme.subtitle2!.copyWith(
              fontWeight: FontWeight.bold,
              color: isLightTheme(context) ? Colors.black : Colors.white
          ),
        ),
        subtitle: BlocBuilder<TypingNotificationBloc, TypingNotificationState>(
          builder: (__, state) {
            if (state is TypingNotificationReceivedSuccess &&
                state.event.event == Typing.start &&
                state.event.from == chat.from!.id)
              this.typingEvents.add(state.event.from);

            if (state is TypingNotificationReceivedSuccess &&
                state.event.event == Typing.stop &&
                state.event.from == chat.from!.id)
              this.typingEvents.remove(state.event.from);

            if (this.typingEvents.contains(chat.from!.id))
              return Text('typing...',
                  style: Theme.of(context)
                      .textTheme
                      .caption!
                      .copyWith(fontStyle: FontStyle.italic));

            return Text(
              chat.mostRecent!.message.contents,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              style: Theme.of(context).textTheme.overline!.copyWith(
                color: chat.unread > 0
                    ? kIndicatorBubble // lets focus on new messages...
                    : isLightTheme(context) ? Colors.black54 : Colors.white70,
                fontWeight: chat.unread > 0 ? FontWeight.bold : FontWeight.normal
              ),
            );
          },
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              DateFormat('h:mm a').format(chat.mostRecent!.message.timestamp),
              style: Theme.of(context)
                  .textTheme
                  .overline!
                  .copyWith(color: isLightTheme(context) ? Colors.black54 : Colors.white70),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50.0),
                child: chat.unread > 0
                    ? Container(
                        height: 15.0,
                        width: 15.0,
                        color: kPrimary,
                        child: Center(
                          child: Text(chat.unread.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .overline!
                                .copyWith(color: Colors.white),
                          ),
                        ),
                      )
                    : SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  void _updateChatsOnMessageReceived() async {
    final chatsCubit = context.read<ChatsCubit>();
    context.read<MessageBloc>().stream.listen((state) async {
      if (state is MessageReceivedSuccess) {
        await chatsCubit.viewModel.receivedMessage(state.message);
        chatsCubit.chats();
      }
    });
  }
}

import 'package:any1/states_management/home/chats_cubit.dart';
import 'package:any1/states_management/home/home_cubit.dart';
import 'package:any1/states_management/home/home_state.dart';
import 'package:any1/theme.dart';
import 'package:any1/ui/pages/home/home_router.dart';
import 'package:any1/ui/widgets/home/profile_image.dart';
import 'package:any1/ui/widgets/home/active/custom_divider.dart';
import 'package:chat/chat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ActiveUsers extends StatefulWidget {
  final User me;
  final IHomeRouter _homeRouter;
  const ActiveUsers(this.me, this._homeRouter);
  @override
  _ActiveUsersState createState() => _ActiveUsersState();
}

class _ActiveUsersState extends State<ActiveUsers> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (_, state) {
        if (state is HomeLoading)
          return Center(child: CircularProgressIndicator());
        if (state is HomeSuccess)
          return _buildList(state.onlineUsers);
        return Container();
      }
    );
  }

  _listItem(User user) => ClipRRect(
    borderRadius: BorderRadius.circular(20.0),
    child: Material(
      // color: isLightTheme(context) ? kBubbleLight2 : kBubbleDark2,
      color: Colors.transparent,
      child: ListTile(
        onTap: () async {
          await this.widget._homeRouter.onShowMessageThread(
              context, user, widget.me, chatId: user.id!);
          await context.read<ChatsCubit>().chats();
        },
        leading: ProfileImage(
          imageUrl: user.photoUrl,
          online: true,
        ),
        title: Text(
          user.username,
          style: Theme.of(context).textTheme.headline6!.copyWith(
              color: isLightTheme(context) ? Colors.black : Colors.white
          ),
        ),
      ),
    ),
  );

  _buildList(List<User> users) => ListView.separated(
      padding: EdgeInsets.only(top: 30.0, right: 15.0, left: 15.0), // don't forget about the curved displays
      itemBuilder: (_, index) => _listItem(users[index]),
      separatorBuilder: (_, __) => CustomActiveDivider(),
      itemCount: users.length
  );
}

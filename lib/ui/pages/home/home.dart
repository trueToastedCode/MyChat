import 'package:any1/states_management/home/chats_cubit.dart';
import 'package:any1/states_management/home/home_cubit.dart';
import 'package:any1/states_management/home/home_state.dart';
import 'package:any1/states_management/message/message_bloc.dart';
import 'package:any1/ui/pages/home/home_router.dart';
import 'package:any1/ui/widgets/home/active/active_users.dart';
import 'package:any1/ui/widgets/home/chats/chats.dart';
import 'package:any1/ui/widgets/home/profile_image.dart';
import 'package:any1/ui/widgets/shared/header_status.dart';
import 'package:chat/chat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Home extends StatefulWidget {
  final User boardedUser;
  final IHomeRouter _homeRouter;
  const Home(this.boardedUser, this._homeRouter);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin {
  late User _user;

  @override
  void initState() {
    super.initState();
    _initalSetup();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: HeaderStatus(
            _user.username,
            _user.photoUrl,
            true,
            typing:false
          ),
          bottom: TabBar(
            indicatorPadding: EdgeInsets.only(top: 10.0, bottom: 10.0),
            tabs: [
              Tab(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text('Messages'),
                  ),
                ),
              ),
              Tab(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: BlocBuilder<HomeCubit, HomeState>(
                      builder: (_, state) => Text('Active (${state is HomeSuccess
                          ? state.onlineUsers.length
                          : 0})'
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Chats(_user, widget._homeRouter),
            ActiveUsers(_user, widget._homeRouter),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  void _initalSetup() async {
    _user = (!widget.boardedUser.active)
        ? await context.read<HomeCubit>().connect()
        : widget.boardedUser;
    context.read<ChatsCubit>().chats();
    context.read<HomeCubit>().activeUsers(_user);
    context.read<MessageBloc>().add(MessageEvent.onSubscribed(_user));
  }
}

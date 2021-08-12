import 'package:any1/cache/local_cache_contract.dart';
import 'package:any1/cache/local_cache_impl.dart';
import 'package:any1/data/datasource/sqflite_datasource.dart';
import 'package:any1/data/services/image_uploader.dart';
import 'package:any1/states_management/home/chats_cubit.dart';
import 'package:any1/states_management/home/home_cubit.dart';
import 'package:any1/states_management/message/message_bloc.dart';
import 'package:any1/states_management/message_thread/message_thread_cubit.dart';
import 'package:any1/states_management/onboarding/onboarding_cubit.dart';
import 'package:any1/states_management/onboarding/profile_image_cubit.dart';
import 'package:any1/states_management/receipt/receipt_bloc.dart';
import 'package:any1/states_management/typing_notification/typing_notification_bloc.dart';
import 'package:any1/ui/pages/home/home.dart';
import 'package:any1/ui/pages/home/home_router.dart';
import 'package:any1/ui/pages/message_thread/message_thread.dart';
import 'package:any1/ui/pages/onboarding/boarding_router_impl.dart';
import 'package:any1/ui/pages/onboarding/onboarding.dart';
import 'package:any1/viewmodels/chat_view_model.dart';
import 'package:any1/viewmodels/chats_view_model.dart';
import 'package:chat/chat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rethinkdb_dart/rethinkdb_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import 'data/datasource/datasource_contract.dart';
import 'data/factories/db_factory.dart';

class CompositionRoot {
  static Rethinkdb? _r;
  static Connection? _connection;
  static IUserService? _userService;
  static Database? _db;
  static IMessageService? _messageService;
  static IDatasource? _datasource;
  static ILocalCache? _localCache;
  static MessageBloc? _messageBloc;
  static ITypingNotification? _typingNotification;
  static TypingNotificationBloc? _typingNotificationBloc;
  static ChatsCubit? _chatsCubit;

  static configure() async {
    _r = Rethinkdb();
    _connection = await _r!.connect(host: '127.0.0.1', port: 28015);
    _userService = UserService(_r!, _connection!);
    _messageService = MessageService(_r!, _connection!);
    _typingNotification = TypingNotification(_r!, _connection!, _userService!);
    _typingNotificationBloc = TypingNotificationBloc(_typingNotification!);
    _db = await LocalDatabaseFactory().createDatabase();
    _datasource = SqfliteDatasource(_db!);
    final sp = await SharedPreferences.getInstance();
    _localCache = LocalCache(sp);
    _messageBloc = MessageBloc(_messageService!);
    final viewModel = ChatsViewModel(_datasource!, _userService!);
    _chatsCubit = ChatsCubit(viewModel);

    // _db!.delete('chats');
    // _db!.delete('messages');
  }

  static Widget start() {
    final user = _localCache!.fetch('USER');
    return user.isEmpty ? composeOnboardingUi() : composeHomeUi(User.fromJson(user));
  }

  static Widget composeOnboardingUi() {
    final imageUploader = ImageUpload('http://localhost:3000/upload');
    
    final onboardingCubit = OnboardingCubit(_userService!, imageUploader, _localCache!);
    final imageCubit = ProfileImageCubit();
    final router = OnboardingRouter(composeHomeUi);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => onboardingCubit),
        BlocProvider(create: (BuildContext context) => imageCubit),
      ],
      child: Onboarding(router),
    );
  }

  static Widget composeHomeUi(User boardingUser) {
    final homeCubit = HomeCubit(_userService!, _localCache!);
    final homeRouter = HomeRouter(showMessageThread: composeMessageThreadUi);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => homeCubit),
        BlocProvider(create: (BuildContext context) => _messageBloc!),
        BlocProvider(create: (BuildContext context) => _typingNotificationBloc!),
        BlocProvider(create: (BuildContext context) => _chatsCubit!),
      ],
      child: Home(boardingUser, homeRouter),
    );
  }

  static Widget composeMessageThreadUi(User receiver, User me,
      {required String chatId}) {
    ChatViewModel viewModel = ChatViewModel(_datasource!);
    MessageThreadCubit messageThreadCubit = MessageThreadCubit(viewModel, _datasource!);
    IReceiptService receiptService = ReceiptService(_r!, _connection!);
    ReceiptBloc receiptBloc = ReceiptBloc(receiptService);

    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (BuildContext context) => messageThreadCubit),
          BlocProvider(create: (BuildContext context) => receiptBloc)
        ],
        child: MessageThread(
            receiver, me, _messageBloc!, _chatsCubit!, _typingNotificationBloc!,
            chatId: chatId));
    }
}
import 'package:any1/cache/local_cache_contract.dart';
import 'package:any1/states_management/home/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat/chat.dart';

class HomeCubit extends Cubit<HomeState> {
  final IUserService _userService;
  final ILocalCache _localCache;

  HomeCubit(this._userService, this._localCache) : super(HomeInitial());

  Future<User> connect() async {
    final userJson = _localCache.fetch('USER');
    userJson['last_seen'] = DateTime.now();
    userJson['active'] = true;

    final user = User.fromJson(userJson);
    await _userService.connect(user);
    return user;
  }

  Future<void> activeUsers(User currentUser) async {
    emit(HomeLoading());
    final users = await _userService.online();
    users.removeWhere((element) => element.id == currentUser.id);
    emit(HomeSuccess(users));
  }
}

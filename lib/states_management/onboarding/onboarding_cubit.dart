import 'dart:io';

import 'package:any1/cache/local_cache_contract.dart';
import 'package:any1/data/services/image_uploader.dart';
import 'package:any1/states_management/onboarding/onboarding_state.dart';
import 'package:chat/chat.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  final IUserService _userService;
  final ImageUpload _imageUpload;
  final ILocalCache _iLocalCache;

  OnboardingCubit(this._userService, this._imageUpload, this._iLocalCache)
      : super(OnboardingInitial());

  Future<bool> connect(String name, File profileImage) async {
    emit(Loading());

    final url = await _imageUpload.uploadImage(profileImage);
    if (url == null) {
      emit(OnboardingInitial());
      return false;
    }

    final user = User(
        username: name,
        photoUrl: url,
        active: true,
        lastseen: DateTime.now());
    final createdUser = await _userService.connect(user);
    final createdUserJson = {
        'username': createdUser.username,
        'active': true,
        'photo_url': createdUser.photoUrl,
        'id': createdUser.id};
    await _iLocalCache.save('USER', createdUserJson);
    emit(OnboardingSuccess(createdUser));
    return true;
  }
}
import 'dart:convert';

import 'package:any1/cache/local_cache_contract.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalCache implements ILocalCache {
  final SharedPreferences _sharedPreferences;

  const LocalCache(this._sharedPreferences);

  @override
  Map<String, dynamic> fetch(String key) {
    return jsonDecode(_sharedPreferences.getString(key) ?? '{}');
  }

  @override
  Future<void> save(String key, Map<String, dynamic> json) async {
    await _sharedPreferences.setString(key, jsonEncode(json));
  }
}
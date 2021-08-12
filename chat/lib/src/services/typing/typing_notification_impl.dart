import 'dart:async';

import 'package:chat/chat.dart';
import 'package:chat/src/models/typing_event.dart';
import 'package:chat/src/models/user.dart';
import 'package:chat/src/services/typing/typing_notification_contract.dart';
import 'package:rethinkdb_dart/rethinkdb_dart.dart';

class TypingNotification implements ITypingNotification {
  final Connection _connection;
  final Rethinkdb _r;

  final _controller = StreamController<TypingEvent>.broadcast();
  StreamSubscription? _changefeed;
  IUserService _userService;

  TypingNotification(this._r, this._connection, this._userService);

  @override
  void dispose() {
    _changefeed?.cancel();
    _controller.close();
  }

  @override
  Future<bool> send({required TypingEvent event}) async {
    final receiver = await _userService.fetch(event.to);
    if (!receiver.active) return false;
    var data = event.toJson();
    final record = await _r
        .table('typing_events')
        .insert(data, {'conflict': 'update'})
        .run(_connection);
    return record['inserted'] == 1;
  }

  @override
  Stream<TypingEvent> subscribe(User user, List<String> userIds) {
    _startReceivingTypingEvents(user, userIds);
    return _controller.stream;
  }

  _startReceivingTypingEvents(User user, List<String> userIds) {
    _changefeed = _r
        .table('typing_events')
        .filter((event) {
          return event('to')
              .eq(user.id)
              .and(_r.expr(userIds).contains(event('from')));
        })
        .changes({'include_initial': true})
        .run(_connection)
        .asStream()
        .cast<Feed>()
        .listen((event) {
          event.forEach((feedData) {
            if (feedData['new_val'] == null) return;

            final event = _eventFromFeed(feedData);
            _controller.sink.add(event);
            _removeDeliverredTypingEvent(event);
          }).catchError((err) => print(err))
              .onError((error, stackTrace) => print(error));
        });
  }

  _eventFromFeed(feedData) {
    return TypingEvent.fromJson(feedData['new_val']);
  }

  _removeDeliverredTypingEvent(TypingEvent event) {
    _r.table('typing_events').get(event.id).delete({'return_changes': false}).run(_connection);
  }
}
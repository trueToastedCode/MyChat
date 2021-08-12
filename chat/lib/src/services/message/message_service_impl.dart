import 'dart:async';

import 'package:chat/src/models/message.dart';
import 'package:chat/src/models/user.dart';
import 'package:chat/src/services/encryption/encryption_contract.dart';
import 'package:chat/src/services/message/message_service_contract.dart';
import 'package:rethinkdb_dart/rethinkdb_dart.dart';

class MessageService implements IMessageService {
  final Connection _connection;
  final Rethinkdb _r;
  final IEncryption? encryption;

  final _controller = StreamController<Message>.broadcast();
  StreamSubscription? _changefeed;

  MessageService(this._r, this._connection, {this.encryption});

  @override
  dispose() {
    _changefeed?.cancel();
    _controller.close();
  }

  @override
  Stream<Message> messages({required User activeUser}) {
    _startReceivingMessages(activeUser);
    return _controller.stream;
  }

  @override
  Future<Message> send(Message message) async {
    var data = message.toJson();
    if (encryption != null)
      data['contents'] = encryption!.encrypt(message.contents);
    final record = await _r
        .table('messages')
        .insert(data, {'return_changes': true})
        .run(_connection);
    return Message.fromJson(record['changes'].first['new_val']);
  }

  _startReceivingMessages(User user) async {
    _changefeed = _r
        .table('messages')
        .filter({'to': user.id})
        .changes({'include_initial': true})
        .run(_connection)
        .asStream()
        .cast<Feed>()
        .listen((event) {
          event.forEach((feedData) {
            if (feedData['new_val'] == null) return;

            final message = _messageFromFeed(feedData);
            _controller.sink.add(message);
            _removeDeliverredMessage(message);
          }).catchError((err) => print(err))
          .onError((error, stackTrace) => print(error));
        });
  }

  Message _messageFromFeed(feedData) {
    var data = feedData['new_val'];
    if (encryption != null)
      data['contents'] = encryption!.decrypt(data['contents']);
    return Message.fromJson(data);
  }

  _removeDeliverredMessage(Message message) {
    _r.table('messages').get(message.id).delete({'return_changes': false}).run(_connection);
  }
}
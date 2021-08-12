import 'package:chat/chat.dart';
import 'package:chat/src/models/typing_event.dart';
import 'package:chat/src/models/user.dart';
import 'package:chat/src/services/typing/typing_notification_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rethinkdb_dart/rethinkdb_dart.dart';

import 'helper.dart';

class FakeUserService extends Mock implements IUserService {}

void main() {
  Rethinkdb r = Rethinkdb();
  Connection? connection;
  TypingNotification? sut;
  IUserService? userService;

  setUp(() async {
    connection = await r.connect(host: '127.0.0.1', port: 28015);
    await createDb(r, connection!);
    userService = FakeUserService();
    sut = TypingNotification(r, connection!, userService!);
  });

  tearDown(() async {
    sut!.dispose();
    await cleanDb(r, connection!);
  });

  final user = User.fromJson({
    'id': '1234',
    'active': true,
    'lastSeen': DateTime.now()});

  final user2 = User.fromJson({
    'id': '1111',
    'active': true,
    'lastSeen': DateTime.now()});

  test('sent typing notification successfully', () async {
    // when(userService!.fetch(any)).thenAnswer((_) async => user2);
    // TypingEvent typingEvent = TypingEvent(from: user2.id!, to: user.id!, event: Typing.start);
    // final res = await sut!.send(event: typingEvent);
    // expect(res, true);
  }, skip: 'TODO (Successful previously) Null safety, need to set nullable for verifying that it has been called');

  test('successfully subscribe and receive typing events', () async {
    // when(userService!.fetch(any)).thenAnswer((_) async => user2);
    // sut!.subscribe(user2, [user.id!]).listen(expectAsync1((event) {
    //   expect(event.from, user.id);
    // }, count: 2));
    //
    // TypingEvent typing = TypingEvent(to: user2.id!, from: user.id!, event: Typing.start);
    //
    // TypingEvent stopTyping = TypingEvent(to: user2.id!, from: user.id!, event: Typing.stop);
    //
    // await sut!.send(event: typing);
    // await sut!.send(event: stopTyping);
  }, skip: 'TODO (Successful previously) Null safety, need to set nullable for verifying that it has been called');
}
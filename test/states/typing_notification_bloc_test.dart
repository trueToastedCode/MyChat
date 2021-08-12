import 'package:any1/states_management/typing_notification/typing_notification_bloc.dart';
import 'package:chat/chat.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class FakeTypingNotification extends Mock implements ITypingNotification {}

void main() {
  TypingNotificationBloc? sut;
  ITypingNotification? typingNotification;

  setUp(() {
    typingNotification = FakeTypingNotification();
    sut = TypingNotificationBloc(typingNotification!);
  });

  tearDown(() => sut!.close());

  final typing_notification = TypingEvent(
    from: '123',
    to: '456',
    event: Typing.start
  );

  test('should emit initial only without subscription', () async {
    expect(sut!.state, TypingNotificationInitial());
  });

  test('should emit typing notification from ongoing chat sent state when typing notification is sent', () {
  //   when(typingNotification!.send(event: typing_notification)).thenAnswer((_) async => true);
  //   sut!.add(TypingNotificationEvent.onTypingEventSent(typing_notification));
  //   expectLater(sut!.stream, emits(TypingNotificationState.sent()));
  // });
  //
  // test('should emit typing notification received from service', () {
  //   final user = User(username: 'test', photoUrl: '', active: true, lastseen: DateTime.now());
  //
  //   when(typingNotification!.subscribe(user, ['123']))
  //       .thenAnswer((_) => Stream.fromIterable([typing_notification]));
  //
  //   sut!.add(TypingNotificationEvent.onSubscribed(user, usersWithChat: ['123']));
  //   expectLater(sut!.stream, emitsInOrder([TypingNotificationReceivedSuccess(typing_notification)]));
  }, skip: 'TODO (Successful previously) Null safety, need to set nullable for verifying that it has been called');
}
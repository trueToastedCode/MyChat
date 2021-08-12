import 'package:any1/data/datasource/datasource_contract.dart';
import 'package:any1/models/chat.dart';
import 'package:any1/models/local_message.dart';
import 'package:any1/viewmodels/chat_view_model.dart';
import 'package:chat/chat.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockDatasource extends Mock implements IDatasource {}

void main() {
  ChatViewModel? sut;
  MockDatasource? mockDatasource;

  setUp(() async {
    mockDatasource = MockDatasource();
    sut = ChatViewModel(mockDatasource!);
  });

  Message message = Message.fromJson({
    'from': '111',
    'to': '222',
    'timestamp': DateTime.parse('2021-08-01'),
    'id': '4444'
  });

  test('initial messages return empty list', () async {
    // when(mockDatasource!.findMessages(any)).thenAnswer((_) async => []);
    // expect(await sut!.getMessages('123'), isEmpty);
  }, skip: 'TODO (Successful previously) Null safety, need to set nullable for verifying that it has been called');

  test('returns list of messages from local storage', () async {
    final chat = Chat('123');
    final localMessage = LocalMessage(chat.id, message, ReceiptStatus.deliverred);
    when(mockDatasource!.findMessages(chat.id)).thenAnswer((_) async => [localMessage]);
    final messages = await sut!.getMessages('123');
    expect(messages, isNotEmpty);
  });

  test('creates a new chat when sending first message', () async {
    // when(mockDatasource!.findChat(any)).thenAnswer((_) async => null);
    // await sut!.sendMessage(message);
    // verify(mockDatasource!.addChat(any)).called(1);
  }, skip: 'TODO (Successful previously) Null safety, need to set nullable for verifying that it has been called');

  test('add new sent message to the chat', () async {
    // final chat = Chat('123');
    // final localMessage = LocalMessage(chat.id, message, ReceiptStatus.sent);
    // when(mockDatasource!.findMessages(chat.id))
    //     .thenAnswer((_) async => [localMessage]);
    //
    // await sut!.getMessages(chat.id);
    // await sut!.sendMessage(message);
    //
    // verifyNever(mockDatasource!.addChat(any));
    // verify(mockDatasource!.addMessage(any)).called(1);
  }, skip: 'TODO (Successful previously) Null safety, need to set nullable for verifying that it has been called');

  test('add new received message to the chat', () async {
    // final chat = Chat('111');
    // final localMessage =
    // LocalMessage(chat.id, message, ReceiptStatus.deliverred);
    // when(mockDatasource!.findMessages(chat.id))
    //     .thenAnswer((_) async => [localMessage]);
    // when(mockDatasource!.findChat(chat.id)).thenAnswer((_) async => chat);
    //
    // await sut!.getMessages(chat.id);
    // await sut!.receivedMessage(message);
    //
    // verifyNever(mockDatasource!.addChat(any));
    // verify(mockDatasource!.addMessage(any)).called(1);
  }, skip: 'TODO (Successful previously) Null safety, need to set nullable for verifying that it has been called');

  test('creates new chat when message received is not apart of this chat', () async {
    // final chat = Chat('123');
    // final localMessage =
    // LocalMessage(chat.id, message, ReceiptStatus.deliverred);
    // when(mockDatasource!.findMessages(chat.id))
    //     .thenAnswer((_) async => [localMessage]);
    // when(mockDatasource!.findChat(chat.id)).thenAnswer((_) async => null);
    //
    // await sut!.getMessages(chat.id);
    // await sut!.receivedMessage(message);
    //
    // verify(mockDatasource!.addChat(any)).called(1);
    // verify(mockDatasource!.addMessage(any)).called(1);
    // expect(sut!.otherMessages, 1);
  }, skip: 'TODO (Successful previously) Null safety, need to set nullable for verifying that it has been called');
}
import 'package:any1/data/datasource/datasource_contract.dart';
import 'package:any1/models/chat.dart';
import 'package:any1/viewmodels/chats_view_model.dart';
import 'package:chat/chat.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockDatasource extends Mock implements IDatasource {}

void main() {
  ChatsViewModel? sut;
  MockDatasource? mockDatasource;

  setUp(() async {
    mockDatasource = MockDatasource();
    sut = ChatsViewModel(mockDatasource!);
  });

  Message message = Message.fromJson({
    'from': '111',
    'to': '222',
    'timestamp': DateTime.parse('2021-08-01'),
    'id': '4444'
  });

  test('initial chats return empty list', () async {
    when(mockDatasource!.findAllChats()).thenAnswer((_) async => []);
    expect(await sut!.getChats(), isEmpty);
  });

  test('returns list of chats', () async {
    final chat = Chat('123');
    when(mockDatasource!.findAllChats()).thenAnswer((_) async => [chat]);
    final chats = await sut!.getChats();
    expect(chats, [chat]);
  });

  test('creates a new chat when receiving message for the first time', () async {
    // when(mockDatasource!.findChat(message.from)).thenAnswer((_) async => null);
    // await sut!.receivedMessage(message);
    // verify(mockDatasource!.addChat(any)).called(1);
  }, skip: 'TODO (Successful previously) Null safety, need to set nullable for verifying that it has been called');

  test('add new message to existing chat', () async {
    // final chat = Chat('132');
    //
    // when(mockDatasource!.findChat(any)).thenAnswer((_) async => chat);
    // await sut!.receivedMessage(message);
    // verifyNever(mockDatasource!.addChat(any));
    // verify(mockDatasource!.addMessage(any)).called(1);
  }, skip: 'TODO (Successful previously) Null safety, need to set nullable for verifying that it has been called');
}
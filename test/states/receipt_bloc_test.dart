import 'package:any1/states_management/receipt/receipt_bloc.dart';
import 'package:chat/chat.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class FakeReceiptService extends Mock implements IReceiptService {}

void main() {
  ReceiptBloc? sut;
  IReceiptService? receiptService;

  setUp(() {
    receiptService = FakeReceiptService();
    sut = ReceiptBloc(receiptService!);
  });

  tearDown(() => sut!.close());

  final receipt = Receipt(
      recipient: '123',
      messageId: '456',
      status: ReceiptStatus.sent,
      timestamp: DateTime.now());

  test('should emit initial only without subscription', () async {
    expect(sut!.state, ReceiptInitial());
  });

  test('should emit receipt sent state when receipt is sent', () {
  //   when(receiptService!.send(receipt)).thenAnswer((_) async => true);
  //   sut!.add(ReceiptEvent.onReceiptSent(receipt));
  //   expectLater(sut!.stream, emits(ReceiptState.sent(receipt)));
  // });
  //
  // test('should emit receipt received from service', () {
  //   final user = User(username: 'test', photoUrl: '', active: true, lastseen: DateTime.now());
  //
  //   when(receiptService!.receipts(any))
  //       .thenAnswer((_) => Stream.fromIterable([receipt]));
  //
  //   sut!.add(ReceiptEvent.onSubscribed(user));
  //   expectLater(sut!.stream, emitsInOrder([ReceiptReceivedSuccess(receipt)]));
  }, skip: 'TODO (Successful previously) Null safety, need to set nullable for verifying that it has been called');
}
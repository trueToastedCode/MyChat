import 'dart:async';

import 'package:chat/src/models/receipt.dart';
import 'package:chat/src/models/user.dart';
import 'package:chat/src/services/receipt/receipt_service_contract.dart';
import 'package:rethinkdb_dart/rethinkdb_dart.dart';

class ReceiptService implements IReceiptService {
  final Connection _connection;
  final Rethinkdb _r;

  final _controller = StreamController<Receipt>.broadcast();
  StreamSubscription? _changefeed;

  ReceiptService(this._r, this._connection);

  @override
  dispose() {
    _changefeed?.cancel();
    _controller.close();
  }

  @override
  Stream<Receipt> receipts(User user) {
    _startReceivingReceipts(user);
    return _controller.stream;
  }

  @override
  Future<bool> send(Receipt receipt) async {
    var data = receipt.toJson();
    Map record = await _r.table('receipts').insert(data).run(_connection);
    return record['inserted'] == 1;
  }

  _startReceivingReceipts(User user) async {
    _changefeed = _r
        .table('receipts')
        .filter({'recipient': user.id})
        .changes({'include_initial': true})
        .run(_connection)
        .asStream()
        .cast<Feed>()
        .listen((event) {
          event.forEach((feedData) {
            if (feedData['new_val'] == null) return;

            final receipt = _receiptFromFeed(feedData);
            _removeDeliverredReceipt(receipt);
            _controller.sink.add(receipt);
          }).catchError((err) => print(err))
              .onError((error, stackTrace) => print(error));
        });
  }

  Receipt _receiptFromFeed(feedData) {
    return Receipt.fromJson(feedData['new_val']);
  }

  _removeDeliverredReceipt(Receipt receipt) {
    _r.table('receipts').get(receipt.id).delete({'return_changes': false}).run(_connection);
  }
}
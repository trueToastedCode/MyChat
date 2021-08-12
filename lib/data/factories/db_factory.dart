import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabaseFactory {
  Future<Database> createDatabase() async {
    final databasesPath = await getDatabasesPath();
    final dbPath = join(databasesPath, 'mychat.db');
    final database = await openDatabase(dbPath, version: 1, onCreate: populateDb);
    return database;
  }

  void populateDb(Database db, int version) async {
    await _createChatTable(db);
    await _createMessagesTable(db);
  }

  Future<void> _createChatTable(Database db) async {
    await db
        .execute('''CREATE TABLE chats(
                    id TEXT PRIMARY KEY,
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL)''')
        .then((_) => print('creating table chats'))
        .catchError((e) => print('error creating chats table: $e'));
  }

  Future<void> _createMessagesTable(Database db) async {
    await db
        .execute('''
          CREATE TABLE messages(
            chat_id TEXT NOT NULL,
            id TEXT PRIMARY KEY,
            sender TEXT NOT NULL,
            receiver TEXT NOL NULL,
            contents TEXT NOT NULL,
            receipt TEXT NOT NULL,
            received_at TIMESTAMP NOT NULL,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL)''')
        .then((_) => print('creating table messages'))
        .catchError((e) => print('error creating messages table: $e'));
  }
}

import 'package:sqflite/sqflite.dart';

class DbEventSupplies {
  static const String dbName = 'event_supplies.db';
  static const int dbVersion = 1;

  static Future<Database> initDatabase() async {
    return openDatabase(
      dbName,
      version: dbVersion,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE conta (
            _id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT,
            sobrenome TEXT,
            email TEXT,
            celular TEXT,
            senha TEXT
          );
        ''');

        await db.execute('''
          CREATE TABLE categoria (
            _id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT
          );
        ''');

        await db.execute('''
          CREATE TABLE item (
            _id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome_item TEXT,
            descricao TEXT,
            categoria_id INTEGER,
            quantidade REAL,
            unidade_medida TEXT,
            FOREIGN KEY (categoria_id) REFERENCES categoria(_id)
          );
        ''');

        await db.execute('CREATE INDEX idx_categoria_id ON item(categoria_id);');

        await db.execute('''
          CREATE TABLE evento (
            _id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT,
            descricao TEXT,
            situacao TEXT,
            data TEXT,
            hora TEXT
          );
        ''');

        await db.execute('CREATE INDEX idx_data ON evento(data);');

        await db.execute('''
          CREATE TABLE items_evento (
            evento_id INTEGER,
            item_id INTEGER,
            embalado INTEGER,
            quantidade_enviado REAL,
            quantidade_retornado REAL,
            observacao TEXT,
            FOREIGN KEY (evento_id) REFERENCES evento(_id),
            FOREIGN KEY (item_id) REFERENCES item(_id),
            PRIMARY KEY (evento_id, item_id)
          );
        ''');

        await db.execute('CREATE INDEX idx_item_id ON items_evento(item_id);');
      },
    );
  }
}
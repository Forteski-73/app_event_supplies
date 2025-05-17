import 'package:sqflite/sqflite.dart';
import '../db/db_event_supplies.dart';

class EventSuppliesService {
  static Future<Database> get _db async => await DbEventSupplies.initDatabase();

  // ---------------- Conta ----------------
  static Future<int> insertConta(Map<String, dynamic> data) async {
    final db = await _db;
    return db.insert('conta', data);
  }

  static Future<int> updateConta(int id, Map<String, dynamic> data) async {
    final db = await _db;
    return db.update('conta', data, where: '_id = ?', whereArgs: [id]);
  }

  static Future<List<Map<String, dynamic>>> getContas() async {
    final db = await _db;
    return db.query('conta');
  }

  // ---------------- Categoria ----------------
  static Future<int> insertCategoria(Map<String, dynamic> data) async {
    final db = await _db;
    return db.insert('categoria', data);
  }

  static Future<int> updateCategoria(int id, Map<String, dynamic> data) async {
    final db = await _db;
    return db.update('categoria', data, where: '_id = ?', whereArgs: [id]);
  }

  static Future<List<Map<String, dynamic>>> getCategorias() async {
    final db = await _db;
    return db.query('categoria');
  }

  // ---------------- Item ----------------
  static Future<int> insertItem(Map<String, dynamic> data) async {
    final db = await _db;
    return db.insert('item', data);
  }

  static Future<int> updateItem(int id, Map<String, dynamic> data) async {
    final db = await _db;
    return db.update('item', data, where: '_id = ?', whereArgs: [id]);
  }

  static Future<List<Map<String, dynamic>>> getItens() async {
    final db = await _db;
    return db.query('item');
  }

  static Future<List<Map<String, dynamic>>> getItensPorCategoria(int categoriaId) async {
    final db = await _db;
    return db.query('item', where: 'categoria_id = ?', whereArgs: [categoriaId]);
  }

  static Future<int> deleteItem(int id) async {
    final db = await _db;
    return db.delete('item', where: '_id = ?', whereArgs: [id]);
  }

  // ---------------- Evento ----------------
  static Future<int> insertEvento(Map<String, dynamic> data) async {
    final db = await _db;
    return db.insert('evento', data);
  }

  static Future<int> updateEvento(int id, Map<String, dynamic> data) async {
    final db = await _db;
    return db.update('evento', data, where: '_id = ?', whereArgs: [id]);
  }

  static Future<List<Map<String, dynamic>>> getEventos() async {
    final db = await _db;
    return db.query('evento');
  }

  static Future<List<Map<String, dynamic>>> getEventosPorData(String data) async {
    final db = await _db;
    return db.query('evento', where: 'data = ?', whereArgs: [data]);
  }

  static Future<int> deleteEvento(int id) async {
    final db = await _db;
    return await db.delete('evento', where: '_id = ?', whereArgs: [id]);
  }

  static Future<List<Map<String, dynamic>>> selectEvento() async {
    final db = await _db;
    return await db.query('evento');
  }

  // ---------------- Items_Evento ----------------
  static Future<int> insertItemEvento(Map<String, dynamic> data) async {
    final db = await _db;
    return db.insert('items_evento', data);
  }

  static Future<int> updateItemEvento(int eventoId, int itemId, Map<String, dynamic> data) async {
    final db = await _db;
    return db.update(
      'items_evento',
      data,
      where: 'evento_id = ? AND item_id = ?',
      whereArgs: [eventoId, itemId],
    );
  }

  static Future<List<Map<String, dynamic>>> getItemsEvento() async {
    final db = await _db;
    return db.query('items_evento');
  }

  static Future<List<Map<String, dynamic>>> getItemsPorEvento(int eventoId) async {
    final db = await _db;
    return db.query('items_evento', where: 'evento_id = ?', whereArgs: [eventoId]);
  }

  static Future<List<Map<String, dynamic>>> getEventosPorItem(int itemId) async {
    final db = await _db;
    return db.query('items_evento', where: 'item_id = ?', whereArgs: [itemId]);
  }

  // Deleta um item do evento pela chave composta eventoId + itemId
  static Future<int> deleteItemEvento(int eventoId, int itemId) async {
    final db = await _db;
    return await db.delete(
      'items_evento',
      where: 'evento_id = ? AND item_id = ?',
      whereArgs: [eventoId, itemId],
    );
  }

}

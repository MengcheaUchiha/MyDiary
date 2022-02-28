import 'package:flutter_mydiary/model/entry.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class EntryDB {
  final String table = "entry";
  final String columnEid = "eid";
  final String columnTitle = "title";
  final String columnDesc = "desc";
  final String columnDate = "date";
  final String columnMood = "mood";
  final String columnWeather = "weather";

  EntryDB._();
  static final EntryDB db = EntryDB._();
  static Database? _database;

  initDB() async {
    return await openDatabase(join(await getDatabasesPath(), "entry_db.db"),
        version: 1, onCreate: _onCreate);
  }

  Future<Database> get database async {
    if (_database == null) _database = await initDB();
    return _database!;
  }

  _onCreate(Database db, int version) {
    return db.execute('''
      CREATE TABLE $table (
        $columnEid integer primary key autoincrement,
        $columnTitle text,
        $columnDesc text not null,
        $columnDate text not null,
        $columnMood integer not null,
        $columnWeather text not null
      );
    ''');
  }

  Future<int> insert(Entry entry) async {
    Database db = await database;
    return await db.insert(table, entry.toMap());
  }

  Future<List<Entry>> getEntries() async {
    Database db = await database;
    final List<Map<String, dynamic>> map = await db.query(table);
    print("${map.length} Entries");
    map.forEach((e) {
      print("${e["eid"]} : ${e["date"]}");
    });
    List<Entry> entries = map.map((json) => Entry.fromJson(json)).toList();
    // Sort from latest date to first date
    entries.sort((a, b) => b.date!.compareTo(a.date!));
    return entries;
  }

  Future<List<Entry>> getEntriesByYear(int year) async {
    Database db = await database;
    final List<Map<String, dynamic>> map =
        await db.query(table, where: "strftime('%Y', $columnDate) = '$year'");
    print("${map.length} Entries");
    map.forEach((e) {
      print("${e["eid"]} : ${e["date"]}");
    });
    List<Entry> entries = map.map((json) => Entry.fromJson(json)).toList();
    // Sort from latest date to first date
    entries.sort((a, b) => b.date!.compareTo(a.date!));
    return entries;
  }

  Future<List<int>> getYears() async {
    Database db = await database;
    final List<Map<String, dynamic>> map = await db.query(table,
        columns: ["CAST(strftime('%Y', $columnDate) as INT) as year"],
        distinct: true);
    final years = map.map<int>((e) => e['year']).toList();
    years.sort((a, b) => b.compareTo(a));
    print("All Years $years");
    return years;
  }

  Future<Map<DateTime, List<Entry>>> getEventsDay() async {
    Database db = await database;
    final List<Map<String, dynamic>> map = await db.query(table);

    List<Entry> entries = map.map((json) => Entry.fromJson(json)).toList();

    Map<DateTime, List<Entry>> maps = {};

    entries.forEach((entry) {
      final dt = entry.date;
      final dd = DateTime(dt!.year, dt.month, dt.day);
      print(dd);
      maps[dd] = entries
          .where((entry) =>
              entry.date!.year == dt.year &&
              entry.date!.month == dt.month &&
              entry.date!.day == dt.day)
          .toList();
    });
    print(maps.length);

    return maps;
  }

  Future<List<Entry>> getEntriesByDate(DateTime dt) async {
    Database db = await database;
    final List<Map<String, dynamic>> map = await db.query(table);
    final en = map.map<Entry>((json) => Entry.fromJson(json)).toList();
    final entries = en
        .where((entry) =>
            entry.date!.year == dt.year &&
            entry.date!.month == dt.month &&
            entry.date!.day == dt.day)
        .toList();
    return entries;
  }

  Future<void> updateEntry(Entry entry) async {
    Database db = await database;
    print("${entry.eid}");
    await db.update(table, entry.toMap(),
        where: '$columnEid = ?', whereArgs: [entry.eid]);
  }

  Future<void> deleteEntry(Entry entry) async {
    Database db = await database;
    await db.delete(table, where: "$columnEid = ?", whereArgs: [entry.eid]);
  }

  Future<void> deleteAll() async {
    Database db = await database;
    await db.delete(table);
  }

  Future close() async => _database!.close();
}

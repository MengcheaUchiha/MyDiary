import 'package:flutter/material.dart';
import 'package:flutter_mydiary/model/entry_db.dart';

import 'entry.dart';

class EntryProvider extends ChangeNotifier {
  List<Entry> _entries = [];
  List<Entry> _entriesByDate = [];
  List<int> _years = [];
  int? _selectedYear;
  Map<DateTime, List<Entry>> _eventDays = {};

  DateTime _selectedDate = DateTime.now();
  DateTime _focusedDate = DateTime.now();

  List<Entry> get entries => _entries;
  List<Entry> get entriesByDate => _entriesByDate;
  Map<DateTime, List<Entry>> get eventDays => _eventDays;

  DateTime get selectedDate => _selectedDate;
  DateTime get focusedDate => _focusedDate;
  int get selectedYear => _selectedYear!;
  List<int> get years => _years;

  EntryProvider() {
    _selectedYear = _selectedDate.year;
    getYears();
    getEntries();
    getEventsDay();
    setSelectedDay(_selectedDate, _focusedDate);
    notifyListeners();
  }

  getYears() async {
    _years = await EntryDB.db.getYears();
    notifyListeners();
  }

  getEntries() async {
    //_entries = await EntryDB.db.getEntries();
    _entries = await EntryDB.db.getEntriesByYear(_selectedYear!);
    notifyListeners();
  }

  add(Entry entry) async {
    final int id = await EntryDB.db.insert(entry);
    getYears();
    getEntries();
    getEventsDay();
    // final en = _entries;
    // en.insert(0, entry.copyWith(eid: id));
    // _entries = en;
    notifyListeners();
  }

  update(Entry entry) async {
    await EntryDB.db.updateEntry(entry);
    final index = _entries.indexWhere((e) => entry.eid == e.eid);
    print("$index");
    final en = _entries;
    en[index] = entry;
    _entries = en;
    notifyListeners();
  }

  delete(Entry entry) async {
    await EntryDB.db.deleteEntry(entry);
    final en = _entries;
    en.remove(entry);
    _entries = en;
    notifyListeners();
  }

  getEventsDay() async {
    _eventDays = await EntryDB.db.getEventsDay();
    notifyListeners();
  }

  Future<List<Entry>> getEntriesByDate(DateTime _selectedDate) async {
    final en = await EntryDB.db.getEntriesByDate(_selectedDate);
    return en;
  }

  setSelectedDay(DateTime dt, DateTime dt1) async {
    _selectedDate = dt;
    _focusedDate = dt1;
    _entriesByDate = await getEntriesByDate(dt);
    print(_entriesByDate.length);
    notifyListeners();
  }

  setSelectedYear(int year) {
    _selectedYear = year;
    getEntries();
    notifyListeners();
  }
}
